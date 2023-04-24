//
//  OTPScreen.swift
//  Smarkt Go
//
//  Created by user235448 on 3/28/23.
//

import SwiftUI

struct OTPScreen: View {
    @EnvironmentObject var signInScreenViewModel:SignInScreenViewModel
    
    @State private var verificationCode = ""
    @State private var InputError = ""
    @State private var navigateToSecondView = false

    var body: some View {
        
        VStack(alignment: .center) {
            Image("otp")
                .resizable()
                .frame(width: UIScreen.main.bounds.width / 1.25  , height: UIScreen.main.bounds.height / 2.5)
                .aspectRatio(contentMode: .fit)
                .padding(.top,Constants.khugeSpace)
            
            Text(Strings.kenterOTP)
                .fontWeight(.semibold)
                .font(.title)
                .foregroundColor(.black)
                .padding(.top,Constants.ksmallSpace)
            
            Text(Strings.ksentOTP)
                .fontWeight(.semibold)
                .font(.subheadline)
                .foregroundColor(.gray)
            
            CustomTextField(text: Strings.kverificationCode, keyboardType: .numberPad, textValue: $verificationCode).padding(.top,Constants.kbigSpace)
            
            if !InputError.isEmpty {
                Text(InputError)
                    .fontWeight(.semibold)
                    .font(.footnote)
                    .foregroundColor(.red)
                    .frame(maxWidth: .infinity,alignment: .leading)
                    .padding(.horizontal,Constants.kbigSpace)
                
            }
            
            

            CustomButton(text: "Verify the code", icon: "", textColor: .white, iconColor: .white, backgroundColor: .accentColor,action:{
                InputError = signInScreenViewModel.isOTPValid(verificationCode)
                if InputError.isEmpty {
                    signInScreenViewModel.verifyCode(verificationCode)
                }
                
            }).padding(.top,Constants.kbigSpace)
            
            Spacer()
            
        }
        .onReceive(signInScreenViewModel.$userLoggedIn) { newValue in
            if !newValue!.isEmpty {
                navigateToSecondView = true
                
            }
        }
        .fullScreenCover(isPresented: $navigateToSecondView) {
            MainScreen()
            .environmentObject(signInScreenViewModel)

        }
    }}

struct OTPScreen_Previews: PreviewProvider {
    static var previews: some View {
        OTPScreen()
    }
}
