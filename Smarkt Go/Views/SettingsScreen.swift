//
//  SettingsScreen.swift
//  Smarkt Go
//
//  Created by Zied Dahmani on 18/3/2023.
//

import SwiftUI

struct SettingsScreen: View {
    @Environment(\.presentationMode) var presentationMode

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
                        Alert(title: Text("Sign out?"), message: Text("Are you sure you want to sign out?"), primaryButton: .destructive(Text("Yes"),action: {
                            signInScreenViewModel.signOut()
                            presentationMode.wrappedValue.dismiss()
                        }), secondaryButton: .default(Text("No")))

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
