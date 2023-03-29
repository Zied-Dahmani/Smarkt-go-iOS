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
    
    
    @State private var showVerificationCode = false
    @State private var verificationCode = ""
    @State private var showOTP = false
    @State private var activee = true

    
    var body: some View {
        
        NavigationView {
            
            ZStack {
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
                
            
                    CustomButton(text: Strings.ksignInWithPhone, icon: "phone.fill", textColor: .white, iconColor: .white, backgroundColor: .accentColor, action: {
                       
                            showOTP = true

                        
                        
                        InputError = signInScreenViewModel.isValid(phoneNumber)
                        if InputError.isEmpty {
                            signInScreenViewModel.signInWithPhone(phoneNumber) { success in
                                if success {
                                    showOTP = true
                                }
                            }
                        }
                    }).padding()
                    
            
    
                    
                    NavigationLink(
                        destination: OTPScreen(),
                        isActive: $showOTP,
                        label: { EmptyView() }
                    )
              
                    
                    
                    HStack{
                        Divider()
                            .frame(width: UIScreen.main.bounds.width / 2.5, height: Constants.kdividerHeight)
                            .background(.gray)
                        
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
            .alert(isPresented: $signInScreenViewModel.showAlert) {
                        Alert(
                            title: Text(Strings.kerror),
                            message: Text(signInScreenViewModel.alertMessage),
                            dismissButton: .default(Text(Strings.kok))
                        )
                    }
        }
        
    }
    
    
}

struct SignInScreen_Preview: PreviewProvider {
    
    static var previews: some View {
        SignInScreen()
    }
}
