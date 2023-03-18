//
//  SignInScreen.swift
//  Smarkt Go
//
//  Created by Zied Dahmani on 7/3/2023.
//

import Foundation


import SwiftUI
import _AuthenticationServices_SwiftUI

struct SignInScreen: View {
    @Environment(\.presentationMode) var presentationMode

    @EnvironmentObject var signInScreenViewModel:SignInScreenViewModel
    
    @State private var phoneNumber = ""
    @State private var InputError = ""
    
    
    var body: some View {
        
        NavigationView {
            
            ZStack {
                // Your content here
                if signInScreenViewModel.isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle())
                }
                
                
                VStack(alignment: .center) {
                    
                    Image("shopping_app")
                        .resizable()
                        .frame(width: UIScreen.main.bounds.width / 1.5  , height: UIScreen.main.bounds.height / 4)
                        .aspectRatio(contentMode: .fit)
                        .padding(.bottom,Constants.khugeSpace)
                    
                    Text(Strings.kappName)
                        .fontWeight(.semibold)
                        .font(.title)
                        .foregroundColor(.black)
                        .padding()
                    
                    CustomTextField(text:Strings.kphoneNumber, keyboardType: .numberPad,textValue: $phoneNumber )
                    if !InputError.isEmpty {
                        Text(InputError)
                            .fontWeight(.semibold)
                            .font(.footnote)
                            .foregroundColor(.red)
                            .frame(maxWidth: .infinity,alignment: .leading)
                            .padding(.horizontal,Constants.kbigSpace)
                        
                    }
                    
                    CustomButton(text: Strings.ksignInWithPhone, icon: "phone.fill", textColor: .white, iconColor: .white, backgroundColor: .accentColor,action:{
                        InputError = signInScreenViewModel.isValid(phoneNumber)
                        if InputError.isEmpty
                        {
                            signInScreenViewModel.navigateToSecondView = true
                        }
                    })
                    .padding()
                    .fullScreenCover(isPresented: $signInScreenViewModel.navigateToSecondView) {
                        MainScreen()
                    }
                    
                    HStack{
                        Divider()
                            .frame(width: UIScreen.main.bounds.width / 2.5, height: Constants.kdividerHeight)
                            .background(.gray)
                        //.padding(.horizontal,Constants.kbigSpace * 2)
                        
                        Text(Strings.kor)
                            .fontWeight(.semibold)
                            .font(.footnote)
                            .foregroundColor(.black)
                        
                        Divider()
                            .frame(width: UIScreen.main.bounds.width / 2.5, height: Constants.kdividerHeight)
                            .background(.gray)
                    }
                    
                    
                    
                    
                    CustomButton(text: Strings.ksignInWithGoogle, icon: "google", textColor: .black, iconColor: nil, backgroundColor: .white, action: {
                        signInScreenViewModel.signInWithGoogle()
                    })
                    .padding()
                    
                    
                    SignInWithAppleButton{ (request) in
                        signInScreenViewModel.nonce = randomNonceString()
                        request.requestedScopes = [.email,.fullName]
                        signInScreenViewModel.nonce = sha256(signInScreenViewModel.nonce)
                    }onCompletion: { (result) in
                        signInScreenViewModel.onCompletionSignInWithApple(result: result)
                    }
                    .signInWithAppleButtonStyle(.black)
                    .frame(width: UIScreen.main.bounds.width - Constants.kbigSpace * 2  , height: Constants.kbuttonHeight)
                    .cornerRadius(Constants.kcornerRadius)
                    .shadow(radius: Constants.kshadowRadius)
                    
                    
                    Spacer()
                    
                }
                
            }
        }
        
    }
    
    
}

struct SignInScreen_Preview: PreviewProvider {
    
    static var previews: some View {
        SignInScreen()
    }
}
