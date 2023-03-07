//
//  SignInScreen.swift
//  Smarkt Go
//
//  Created by Zied Dahmani on 7/3/2023.
//

import Foundation


import SwiftUI

struct SignInScreen: View {
    
    @State private var username: String = ""
    @FocusState private var emailFieldIsFocused: Bool
    
    var body: some View {
        
        VStack(alignment: .center) {
            
            TextField("Phone Number", text: $username)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            
            Button {
                
            } label: {
                Text("Sign in")
                    .frame(maxWidth: .infinity)
                    .foregroundColor(.white)
            }
            .frame(height: 50)
            .background(Color.accentColor)
            .clipShape(Capsule())
            .padding([.horizontal,.bottom],30)

            
            Divider().padding(.horizontal,40)

  	
            
        }.padding()

    }
}

struct SignInScreen_Preview: PreviewProvider {
    static var previews: some View {
        SignInScreen()
    }
}
