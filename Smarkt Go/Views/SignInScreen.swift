//
//  SignInScreen.swift
//  Smarkt Go
//
//  Created by Zied Dahmani on 7/3/2023.
//

import Foundation


import SwiftUI

struct SignInScreen: View {
    @ObservedObject var signInScreenViewModel: SignInScreenViewModel
    @State private var phoneNumber = ""
    @State private var navigateToSecondView = false
    @State private var InputError = ""
    
    
    var body: some View {
        
        NavigationView {
            
            VStack(alignment: .center) {
                
                Image("shopping_app")
                    .resizable()
                    .frame(width: UIScreen.main.bounds.width / 1.5  , height: UIScreen.main.bounds.height / 4)
                    .aspectRatio(contentMode: .fit)
                    .padding(.vertical,Constants.khugeSpace)
                
                Text(Strings.kappName)
                    .fontWeight(.semibold)
                    .font(.system(size:Constants.kheadlineLarge))
                    .foregroundColor(.black)
                    .padding()
                
                CustomTextField(text:Strings.kphoneNumber, keyboardType: .numberPad,textValue: $phoneNumber )
                if !InputError.isEmpty {
                    Text(InputError)
                        .fontWeight(.semibold)
                        .font(.system(size:Constants.kbodySmall))
                        .foregroundColor(.red)
                        .frame(maxWidth: .infinity,alignment: .leading)
                        .padding(.horizontal,Constants.kbigSpace)
                    
                }
                
                CustomButton(text: Strings.ksignInWithPhone, icon: "phone.fill", textColor: .white, iconColor: .white, backgroundColor: .accentColor,action:{
                    InputError = signInScreenViewModel.isValid(phoneNumber)
                })
                .padding()
                .fullScreenCover(isPresented: $navigateToSecondView) {
                    MainScreen()
                }
                
                Divider()
                    .frame(height: Constants.kdividerHeight)
                    .background(.gray)
                    .padding(.horizontal,Constants.kbigSpace * 2)
                
                
                CustomButton(text: Strings.ksignInWithGoogle, icon: "google", textColor: .black, iconColor: nil, backgroundColor: .white, action: {
                })
                .padding()
                
                
                CustomButton(text: Strings.ksignInWithApple, icon: "applelogo", textColor: .white, iconColor: .white, backgroundColor: .black, action: {
                })
                
                Spacer()
                
            }
            
        }
        
    }
    
    
}

struct SignInScreen_Preview: PreviewProvider {
    
    static var previews: some View {
        SignInScreen(signInScreenViewModel: SignInScreenViewModel())
    }
}
