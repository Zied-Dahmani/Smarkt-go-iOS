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
    @Published var currentUser  : User?
    @Published var nonce  = ""
    @Published var supermarkets = [Supermarket]()

    
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
    
    
    func signInWithGoogle()
    {
        guard let clientID = FirebaseApp.app()?.options.clientID else {
            return  }
        
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config
        
        
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
                
                self.currentUser = User(id: (result?.user.email)!, name: (result?.user.displayName)!)
                UserDefaults.standard.set(true, forKey: "isUserLoggedIn")
            }
        }
        
    }
    
    func signOut()
    {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            UserDefaults.standard.set(false, forKey: "isUserLoggedIn")
            
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


