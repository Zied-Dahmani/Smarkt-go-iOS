//
//  SignInScreenViewModel.swift
//  Smarkt Go
//
//  Created by Zied Dahmani on 15/3/2023.
//

import SwiftUI

import Foundation
import Combine
import GoogleSignIn
import Firebase
import AuthenticationServices

class SignInScreenViewModel: ObservableObject {
    @Published var user  : User?
    @Published var nonce  = ""
    @Published var isLoading  = false
    @Published var userLoggedIn : String?
    @Published var isNotFirstTime : Bool
    @Published var showAlert = false
    @Published var alertMessage = ""
    
    init(){
        userLoggedIn = UserDefaults.standard.string(forKey: "userLoggedIn") ?? ""
        isNotFirstTime = UserDefaults.standard.bool(forKey: "isNotFirstTime")
    }
    
    
    
    func signInWithPhone(_ phoneNumber: String, callback: @escaping (Bool) -> Void) {
        let phoneNumber = "+216\(phoneNumber)"
        PhoneAuthProvider.provider().verifyPhoneNumber(phoneNumber, uiDelegate: nil) { verificationID, error in
            if let error = error {
                print("Error verifying phone number: \(error.localizedDescription)")
                callback(false)
                return
            }
            
            UserDefaults.standard.set(verificationID, forKey: "authVerificationID")
            
            callback(true)
        }
    }
    

    func verifyCode(_ code: String) {
        guard let verificationID = UserDefaults.standard.string(forKey: "authVerificationID") else {
            return
        }
        
        let credential = PhoneAuthProvider.provider().credential(withVerificationID: verificationID, verificationCode: code)
        
        Auth.auth().signIn(with: credential) { result, error in
            if let error = error {
                print("Error signing in with phone: \(error.localizedDescription)")
                return
            }
            else{
              //Handle the signInUp scenario
            }
         
        }
    }

    func isOTPValid(_ text: String) -> String {
        if text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        {
            return "Please type your code"
        }
        else if text.count != 6
        {
            return "Please type a valid OTP"
        }
        else
        {
            return ""
        }
    }
    
    func isValid(_ text: String) -> String {
        if text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        {
            return "Please type your phone number!"
        }
        else if text.count != 8
        {
            return "Please type a valid phone number!"
        }
        else
        {
            return ""
        }
    }
    
    func signInUp(provider: String? = nil, url: String,id: String,fullName:String? = nil,image: String? = nil){
        let url = URL(string: Constants.kbaseUrl + url)!
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let data: [String: String?]
        if provider == nil {
            if fullName == nil {
                data = ["id": id]
            }
            else {
                data = ["id": id,"fullName":fullName,"image":image]
            }
        }
        else{
            if fullName == nil {
                data = ["provider":provider,"id": id]
            }
            else {
                data = ["provider":provider,"id": id,"fullName":fullName,"image":image]
            }
        }
        
        
        let jsonData = try? JSONSerialization.data(withJSONObject: data)
        request.httpBody = jsonData
        let session = URLSession.shared
        
        let task = session.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode)
                  
            else {
            
                print("Invalid response")
                return
            }
            
            if let data = data {
                DispatchQueue.main.async {
                    do {
                        let decoder = JSONDecoder()
                        self.user = try decoder.decode(User.self, from: data)
                        UserDefaults.standard.set(self.user?.id, forKey: "userLoggedIn")
                        self.userLoggedIn = self.user?.id
                        self.isLoading = false
                    } catch {
                        print("Error decoding JSON: \(error.localizedDescription)")
                    }
                }
            }
        }
        
        task.resume()
        
    }
    
    func signInWithGoogle()
    {
        self.isLoading = true
        
        GIDSignIn.sharedInstance.signIn(withPresenting: (UIApplication.shared.windows.first?.rootViewController)! ) {result, error in
            guard error == nil else {
                print("Error signInWithGoogle : %@", error as Any)
                self.isLoading = false
                return
            }
            
            guard let user = result?.user,let idToken = user.idToken?.tokenString
            else {
                self.isLoading = false
                return
            }
            
            let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: user.accessToken.tokenString)
            
            Auth.auth().signIn(with: credential) { result, error in
                guard error == nil else {
                    self.isLoading = false
                    return
                }
                
                if let isNewUser = result?.additionalUserInfo?.isNewUser, isNewUser {
                    
                    Auth.auth().fetchSignInMethods(forEmail: (result?.user.email)!) { [self] (providers, error) in
                        if let error = error {
                            print("Error fetching sign-in methods for email \(String(describing: result?.user.email)): \(error.localizedDescription)")
                            return
                        }
                        
                        // TODO: alreadySignedInWithApple & swap
                        if providers!.contains("apple.com") {
                            self.alertMessage = Strings.kalreadySignedInWithApple
                            self.showAlert = true
                            return
                        }
                        else{
                            if let photoURL = result?.user.photoURL {
                                self.signInUp(provider:"google",url: Constants.ksignUp, id: (result?.user.email)!, fullName: result?.user.displayName, image: photoURL.absoluteString)
                            }
                        }
                       
                        
                    }
                    
                } else {
                        self.signInUp(url: Constants.ksignIn, id: (result?.user.email)!)
                }
                
                
                
            }
        }
        
    }
        
    func onCompletionSignInWithApple(result : Result<ASAuthorization, Error>){
        switch result {
        case .success(let user):
            guard let credential = user.credential as?  ASAuthorizationAppleIDCredential else {
                return
            }
            signInWithApple(credential: credential)
        case .failure(let error):
            print(error.localizedDescription)
        }
    }
    
    func signInWithApple(credential: ASAuthorizationAppleIDCredential){
        self.isLoading = true

        guard let token = credential.identityToken else {
            self.isLoading = false
            return
        }
        
        guard let tokenString = String(data:token,encoding: .utf8) else {
            self.isLoading = false
            return
        }
        let firebaseCredential = OAuthProvider.credential(withProviderID:"apple.com",idToken: tokenString,rawNonce: nonce )
        
        Auth.auth().signIn(with: firebaseCredential) {(result,err) in
            if err != nil {
                self.isLoading = false
                return
            }
            
            if let isNewUser = result?.additionalUserInfo?.isNewUser, isNewUser {
                
                Auth.auth().fetchSignInMethods(forEmail: (result?.user.email)!) { [self] (providers, error) in
                    if let error = error {
                        print("Error fetching sign-in methods for email \(String(describing: result?.user.email)): \(error.localizedDescription)")
                        return
                    }
                    
                    // TODO: alreadySignedInWithGoogle & swap
                    if providers!.contains("google.com") {
                        self.alertMessage = Strings.kalreadySignedInWithGoogle
                        self.showAlert = true
                        return
                    }
                    else {
                        self.signInUp(provider:"apple", url:Constants.ksignUp,id: (result?.user.email)!)
                    }
                }
                
            } else {
                self.signInUp(url: Constants.ksignIn, id: (result?.user.email)!)
            }
            
            
        }
        
    }
    
    func signOut()
    {
        do {
            guard let url = URL(string: Constants.kbaseUrl+Constants.ksignOut) else {
                return
            }
            
            URLSession.shared.dataTask(with: url) { data, _, error in
                guard let data = data else {
                    return
                }
                do {
                    if let jsonDict = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                        if let message = jsonDict["msg"] as? String {
                            if message == "signed out"
                            {
                                try Auth.auth().signOut()
                                DispatchQueue.main.async {
                                    self.userLoggedIn = ""
                                    UserDefaults.standard.set("", forKey: "userLoggedIn")
                                }
                            }
                        }
                    }
                    
                } catch {
                    print(error.localizedDescription)
                }
            }.resume()
            
        }
    }

    
    /*func getSupermarkets() {
     guard let url = URL(string: "http://localhost:9090/supermarket/") else {
     return
     }
     
     URLSession.shared.dataTask(with: url) { data, _, error in
     guard let data = data else {
     return
     }
     
     do {
     let decodedUsers = try JSONDecoder().decode([Supermarket].self, from: data)
     DispatchQueue.main.async {
     self.supermarkets = decodedUsers
     }
     } catch {
     print(error.localizedDescription)
     }
     }.resume()
     }*/
    
}


