//
//  SignInScreen.swift
//  Smarkt Go
//
//  Created by Zied Dahmani on 7/3/2023.
//

import Foundation


import SwiftUI

struct SignInScreen: View {
    
    @State private var phoneNumber = ""

    
    var body: some View {
        
        VStack(alignment: .center) {
            
            Image("shopping_app")
                        .resizable()
                        .frame(width: UIScreen.main.bounds.width / 1.5  , height: UIScreen.main.bounds.height / 4)
                       .aspectRatio(contentMode: .fit)
                       .padding()
            
            
            TextField("Phone number", text: $phoneNumber)
                .padding(EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16))
                .frame(width: UIScreen.main.bounds.width - 40  , height: 50)
                      .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .strokeBorder(Color.accentColor, lineWidth: 1)
                                  )
                      .padding()
            
            Button(action: {
                print("ca marche")
            }) {
                HStack {
                    Image(systemName: "phone")
                        .foregroundColor(.white)
                    Text("Sign in with phone")
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                }
                .padding()
                .frame(width: UIScreen.main.bounds.width - 40  , height: 50)
                .background(Color.accentColor)
                .cornerRadius(10)
                .shadow(radius: 5)
                
            }.padding()

            
            Divider()
                .frame(height: 2)
                .background(Color.gray)
                .padding(.horizontal,40)

            Button(action: {
                        // Action when button is pressed
                    }) {
                        HStack {
                            Image("google")
                                       .resizable()
                                       .aspectRatio(contentMode: .fit)
                            Text("Sign in with Google")
                                .fontWeight(.semibold)
                                .foregroundColor(.black)
                        }
                        .padding()
                        .frame(width: UIScreen.main.bounds.width - 40  , height: 50)
                        .background(Color.white)
                        .cornerRadius(10)
                        .shadow(radius: 5)

                    }
                    .padding()
            
            
            Button(action: {
                        // Action when button is pressed
                    }) {
                        HStack {
                            Image(systemName: "applelogo")
                                .foregroundColor(.white)
                            Text("Sign in with Apple")
                                .fontWeight(.semibold)
                                .foregroundColor(.white)
                        }
                        .padding()
                        .frame(width: UIScreen.main.bounds.width - 40  , height: 50)
                        .background(Color.black)
                        .cornerRadius(10)
                        .shadow(radius: 5)

                    }

            Spacer()

            
        }.padding()

    }
}

struct SignInScreen_Preview: PreviewProvider {
    static var previews: some View {
        SignInScreen()
    }
}
