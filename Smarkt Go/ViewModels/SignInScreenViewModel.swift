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
    @Published var aUsers : [UserInfo] = []

    @Published var nonce  = ""
    @Published var isLoading  = false
    @Published var userLoggedIn : String?
    @Published var isNotFirstTime : Bool
    @Published var showAlert = false
    @Published var alertMessage = ""
    @Published var phone = ""
    
    
    init(){
        userLoggedIn = UserDefaults.standard.string(forKey: "userLoggedIn") ?? ""
        isNotFirstTime = UserDefaults.standard.bool(forKey: "isNotFirstTime")
    }
    
    
    func addUser (userId: String)
    {
        let url = URL(string: Constants.kbaseUrl + Constants.kaddUser)!

           var request = URLRequest(url: url)
           request.httpMethod = "POST"
           request.setValue("application/json", forHTTPHeaderField: "Content-Type")
           
           let parameters: [String: Any] = [
               "group": userId
             
           ]
           
           do {
               request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: [])
           } catch let error {
               print(error.localizedDescription)
               return
           }
           
           URLSession.shared.dataTask(with: request) { data, response, error in
               
               guard let data = data, error == nil else {
                   print(error?.localizedDescription ?? "Unknown error")
                   return
               }
               
           }
           .resume()
       }
   
    
    func getNonMembers(onCompletion: @escaping (Int, [UserInfo]?) -> Void) {
        let url = URL(string: Constants.kbaseUrl + Constants.knonMembers)!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                onCompletion(-1, nil) // server error
                return
            }
            guard let httpResponse = response as? HTTPURLResponse else {
                onCompletion(-1, nil) // server error
                return
            }
            switch httpResponse.statusCode {
            case 200:
                guard let data = data else {
                    onCompletion(-1, nil) // server error
                    return
                }
                do {
                    let users = try JSONDecoder().decode([UserInfo].self, from: data)
                    DispatchQueue.main.async {
                        onCompletion(200, users)
                    }
                } catch let error {
                    print("Error decoding JSON: \(error)")
                    onCompletion(-1, nil) // server error
                }
            case 403:
                onCompletion(403, nil) // no data found
            default:
                onCompletion(-1, nil) // server error
            }
        }.resume()
    }

    
    
    
    func redeemTicket(id: String, code: Int,  wallet: Float, onCompletion: @escaping (Int) -> Void) {
        
        let url = URL(string: Constants.kbaseUrl + Constants.kredeemCode)!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let parameters: [String: Any] = [
            "id": id,
            "code": code,
            "wallet": wallet
        ]
        request.httpBody = try! JSONSerialization.data(withJSONObject: parameters, options: [])
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                onCompletion(-1) // server error
                return
            }
            guard let httpResponse = response as? HTTPURLResponse else {
                onCompletion(-1) // server error
                return
            }
            switch httpResponse.statusCode {
            case 200:
                DispatchQueue.main.async {
                    if let data = data {
                        do {
                            let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                            if let newWallet = json?["newWallet"] as? Float {
                                print("new wallet value is \(newWallet.formatted())")
                                self.user?.wallet = newWallet
                            }
                            onCompletion(1) // success
                        } catch {
                            onCompletion(-1) // server error
                        }
                    }
                }
            case 400:
                onCompletion(0) // ticket already used
            case 401:
                onCompletion(2) // invalid code
            case 404:
                onCompletion(3) // ticket not found
            default:
                onCompletion(-1) // server error
            }
        }
        
        task.resume()
        
    }
    
    func uploadImage(id: String, image: UIImage) {
        let url = URL(string: Constants.kbaseUrl + Constants.kupdatePic)!
        let boundary = UUID().uuidString
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        let imageData = image.jpegData(compressionQuality: 0.8)!
        let body = NSMutableData()
        let filename = "image.jpeg"
        let mimetype = "image/jpeg"
        body.append("--\(boundary)\r\n".data(using: .utf8)!)
        body.append("Content-Disposition:form-data; name=\"id\"\r\n\r\n".data(using: .utf8)!)
        body.append("\(id)".data(using: .utf8)!)
        body.append("\r\n".data(using: .utf8)!)
        body.append("--\(boundary)\r\n".data(using: .utf8)!)
        body.append("Content-Disposition:form-data; name=\"image\"; filename=\"\(filename)\"\r\n".data(using: .utf8)!)
        body.append("Content-Type: \(mimetype)\r\n\r\n".data(using: .utf8)!)
        body.append(imageData)
        body.append("\r\n".data(using: .utf8)!)
        body.append("--\(boundary)--\r\n".data(using: .utf8)!)
        request.httpBody = body as Data
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
                return
            }
            guard let data = data else {
                print("Error: No data received")
                return
            }
            do {
                let responseJSON = try JSONSerialization.jsonObject(with: data, options: [])
                print("Response: \(responseJSON)")
            } catch {
                print("Error decoding response: \(error.localizedDescription)")
            }
        }.resume()
    }
    
    func isCodeValid(_ text: String) -> String {
        if text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        {
            return "Please type your Code"
        }
        else if text.count != 6
        {
            return "Please type a valid Code"
        }
        else
        {
            return ""
        }
    }
    
    func updateProfile(id: String, fullName: String, wallet: String, completion: @escaping (Error?) -> Void) {
        let url = URL(string: Constants.kbaseUrl + Constants.kupdate)!
        if let userLoggedIn = UserDefaults.standard.value(forKey: "userLoggedIn") as? String {
            
            print("The logged in User "+userLoggedIn)
            
        } else {
            print("not found")
            
        }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let parameters: [String: Any] = [
            "id": id,
            "fullName": fullName,
            "wallet": wallet
        ]
        request.httpBody = try! JSONSerialization.data(withJSONObject: parameters, options: [])
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                completion(error)
                return
            }
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                if let userDict = json as? [String: Any], let fullName = userDict["fullname"] as? String {
                    self.user!.fullName = fullName
                }
                print(json)
                completion(nil)
            } catch {
                completion(error)
            }
        }
        task.resume()
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
                UserDefaults.standard.set(self.user?.id, forKey: "userLoggedIn")
                
                if let isNewUser=result?.additionalUserInfo?.isNewUser,isNewUser{
                    self.signInUp(provider:"phone",url: Constants.ksignUp, id: (result?.user.phoneNumber)!)
                }
                else{
                    self.signInUp(url: Constants.ksignIn, id: (result?.user.phoneNumber)!)
                }
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
                DispatchQueue.main.async {
                    self.isLoading = false
                }
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
    
    func deleteAccount(token: String) {
        do {
            guard let url = URL(string: Constants.kbaseUrl+Constants.kdeleteMyAccount) else {
                return
            }
            
            var request = URLRequest(url: url)
            request.httpMethod = "DELETE"
            request.setValue(token, forHTTPHeaderField: "jwt")
            
            URLSession.shared.dataTask(with: request) { data, response, error in
                guard let data = data else {
                    return
                }
            
                do {
                    if let jsonDict = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                        if let message = jsonDict["msg"] as? String {
                            if message == "success"
                            {
                                let user = Auth.auth().currentUser
                                user?.delete { error in
                                    if let error = error {
                                        print("Error deleting user account: \(error.localizedDescription)")
                                    } else {
                                        print("User account deleted successfully.")
                                        DispatchQueue.main.async {
                                            self.userLoggedIn = ""
                                            UserDefaults.standard.set("", forKey: "userLoggedIn")
                                        }
                                        
                                    }
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
    
    
}


