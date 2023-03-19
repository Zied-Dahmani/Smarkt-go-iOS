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
    @ObservedObject var networkMonitor =  NetworkMonitor()
    
    init() {
        if !signInScreenViewModel.userLoggedIn!.isEmpty
        {
            signInScreenViewModel.signInUp(url: Constants.ksignIn, id: signInScreenViewModel.userLoggedIn!)
        }
    }
    
    var body: some Scene {
        WindowGroup{
            if networkMonitor.isConnected == "true" {
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
            else if networkMonitor.isConnected == "false" {
                VStack(alignment: .center){
                    Image("no_wifi")
                        .resizable()
                        .frame(width: UIScreen.main.bounds.width / 1.5  , height: UIScreen.main.bounds.height / 4)
                        .aspectRatio(contentMode: .fit)
                        .padding(.bottom,Constants.khugeSpace)
                    
                    Text(Strings.kcheckInternetConnection)
                        .fontWeight(.medium)
                        .font(.title3)
                        .foregroundColor(.black)
                        .padding()
                }
            }
        }
    }
}


