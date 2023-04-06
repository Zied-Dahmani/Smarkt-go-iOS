//
//  SettingsScreen.swift
//  Smarkt Go
//
//  Created by Zied Dahmani on 18/3/2023.
//

import SwiftUI

struct SettingsScreen: View {
    @EnvironmentObject var signInScreenViewModel: SignInScreenViewModel
    @State private var showAlert = false
    
    
    var body: some View {
        NavigationView{
            List {
                Text(Strings.ksignOut)
                    .onTapGesture {
                        showAlert = true
                    }
                    .alert(isPresented: $showAlert) {
                        Alert(title: Text(Strings.ksignOutTitle), message: Text(Strings.ksignOutSubTitle), primaryButton: .destructive(Text(Strings.kyes),action: {
                            signInScreenViewModel.signOut()
                        }), secondaryButton: .default(Text(Strings.kno)))
                        
                    }
                
            }
            .navigationTitle(Strings.ksettings)
        }
        
    }
}

struct SettingsScreen_Previews: PreviewProvider {
    static var previews: some View {
        SettingsScreen()
    }
}
