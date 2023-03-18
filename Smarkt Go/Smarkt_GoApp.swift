//
//  Smarkt_GoApp.swift
//  Smarkt Go
//
//  Created by Zied Dahmani on 14/1/2023.
//

import SwiftUI

@main
struct Smarkt_GoApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @ObservedObject var signInScreenViewModel =  SignInScreenViewModel()
    @Environment(\.presentationMode) var presentationMode
    
    init() {
        if !signInScreenViewModel.userLoggedIn!.isEmpty
        {
            signInScreenViewModel.signInUp(url: Constants.ksignIn, id: signInScreenViewModel.userLoggedIn!)
        }
    }
    
    var body: some Scene {
        WindowGroup {
            if signInScreenViewModel.userLoggedIn!.isEmpty && !signInScreenViewModel.isNotFirstTime {
                OnboardingScreen()
            }
            else if  signInScreenViewModel.userLoggedIn!.isEmpty && signInScreenViewModel.isNotFirstTime {
                SignInScreen()
                    .environmentObject(signInScreenViewModel)
            }
            else {
                MainScreen()
                    .environmentObject(signInScreenViewModel)
            }
        }
    }
}
