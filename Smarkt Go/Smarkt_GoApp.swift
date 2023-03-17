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
    let isUserLoggedIn = UserDefaults.standard.bool(forKey: "isUserLoggedIn")

    var body: some Scene {
        WindowGroup {
            if !isUserLoggedIn {
                OnboardingScreen()
            }
            else {
                // TODO: Init user ( signed in )
                MainScreen()
                    .environmentObject(SignInScreenViewModel())
            }
        }
    }
}
