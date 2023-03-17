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

class SignInScreenViewModel: ObservableObject {
    @Published var currentUser  : FirebaseAuth.User?
    
    
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
    
    func signInWithGoogle() -> Bool
    {
        guard let clientID = FirebaseApp.app()?.options.clientID else { return false }
        
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
                
                self.currentUser = result?.user
                UserDefaults.standard.set(true, forKey: "isUserLoggedIn")
            }
        }
        // TODO: Return true when this user is signed in 
        return true

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
    
}




