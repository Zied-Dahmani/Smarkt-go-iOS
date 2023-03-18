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
    @Published var navigateToSecondView = false
    @Published var nonce  = ""
    @Published var isLoading  = false
    @Published var userLoggedIn : String?
    @Published var isNotFirstTime : Bool
    
    init(){
        userLoggedIn = UserDefaults.standard.string(forKey: "userLoggedIn") ?? ""
        isNotFirstTime = UserDefaults.standard.bool(forKey: "isNotFirstTime")
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
    
    func signInUp(url: String,id: String,fullName:String? = nil,image: String? = nil){
        let url = URL(string: Constants.kbaseUrl + url)!
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        var data: [String: Any]
        if fullName == nil {
            data = ["id": id]
        }
        else {
            data = ["id": id,"fullName":fullName,"image":image]
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
                        self.isLoading = false
                        self.navigateToSecondView = true
                    } catch {
                        print("Error decoding JSON: \(error.localizedDescription)")
                    }
                }
                
            }
        }
        
        task.resume()
        
        
    }
    
    func signIn(){
        
    }
    
    func signInWithGoogle()
    {
        self.isLoading = true
        
        GIDSignIn.sharedInstance.signIn(withPresenting: (UIApplication.shared.windows.first?.rootViewController)! ) {result, error in
            guard error == nil else {
                print("Error signInWithGoogle : %@", error)
                return
            }
            
            guard let user = result?.user,let idToken = user.idToken?.tokenString
            else {
                return
            }
            
            let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: user.accessToken.tokenString)
            
            Auth.auth().signIn(with: credential) { result, error in
                guard error == nil else {
                    return
                }
                
                let url: String
                if let isNewUser = result?.additionalUserInfo?.isNewUser, isNewUser {
                    url = Constants.ksignUp
                } else {
                    url = Constants.ksignIn
                }
                
                if let photoURL = result?.user.photoURL {
                    self.userLoggedIn = result?.user.email
                    self.signInUp(url: url, id: (result?.user.email)!, fullName: result?.user.displayName, image: photoURL.absoluteString)
                }
                
            }
        }
        
    }
    
    func signOut()
    {
        let firebaseAuth = Auth.auth()
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
                                try firebaseAuth.signOut()
                                DispatchQueue.main.async {
                                    self.userLoggedIn = ""
                                    self.navigateToSecondView = false
                                    UserDefaults.standard.set("", forKey: "userLoggedIn")
                                }
                            }
                        }
                    }
                    
                } catch {
                    print(error.localizedDescription)
                }
            }.resume()
            
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
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
        
        guard let token = credential.identityToken else {
            return
        }
        
        guard let tokenString = String(data:token,encoding: .utf8) else {
            return
        }
        let firebaseCredential = OAuthProvider.credential(withProviderID:"apple.com",idToken: tokenString,rawNonce: nonce )
        
        Auth.auth().signIn(with: firebaseCredential) {(result,err) in
            if let error = err {
                return
            }
            
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


