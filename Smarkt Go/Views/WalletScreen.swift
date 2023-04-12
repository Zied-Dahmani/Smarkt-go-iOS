//
//  WalletScreen.swift
//  Smarkt Go
//
//  Created by user235448 on 3/29/23.
//

import SwiftUI

struct WalletScreen: View {
    @EnvironmentObject var signInScreenViewModel: SignInScreenViewModel
    @ObservedObject var walletViewModel = WalletViewModel()
    @State private var Code = ""
    @State private var message = ""
    @State var user : User?
    @State private var InputError = ""

    var body: some View {
        
        VStack(alignment: .leading) {
            Image("wallet")
                .resizable()
                .frame(width: UIScreen.main.bounds.width - 40, height:UIScreen.main.bounds.height / 2.5)
                .aspectRatio(contentMode: .fit)
            
            Text(Strings.kenterCode)
                .fontWeight(.semibold)
                .font(.title)
                .foregroundColor(.black)
                .padding(.horizontal,Constants.kbigSpace)

            Text(Strings.kCode)
                .font(.subheadline)
                .foregroundColor(.gray)
                .padding(.horizontal,Constants.kbigSpace)

            
            CustomTextField(text: Strings.kverificationCode, keyboardType: .numberPad, textValue: $Code)
                .padding(.horizontal,Constants.kbigSpace)

            
            if !InputError.isEmpty {
                Text(InputError)
                    .fontWeight(.semibold)
                    .font(.footnote)
                    .foregroundColor(.red)
                    .frame(maxWidth: .infinity,alignment: .leading)
                    .padding(.horizontal,Constants.kbigSpace)
                
            }
            CustomButton(text: Strings.kverifyWallet, icon: "", textColor: .white, iconColor: .white, backgroundColor: .accentColor, action: {
             
                InputError = signInScreenViewModel.isCodeValid(Code)
                if InputError.isEmpty {
                    signInScreenViewModel.redeemTicket(id: self.user!.id, code: Int(Code)!, wallet: self.user!.wallet) { result in
                        switch result {
                        case 0:
                            message = "Ticket already used"
                            InputError = ""
                            Code = ""
                        case 1:
                            message = "Code redeemed successfully"
                            InputError = ""
                            Code = ""
                        case 2:
                            message = "Invalid code"
                            InputError = ""
                            Code = ""
                        case 3:
                            message = "Ticket not found"
                            InputError = ""
                            Code = ""
                            
                        default:
                            message = "Server error"
                            InputError = ""
                            Code = ""
                        }
                    }
                }
            })
            .padding(.top,Constants.ksmallSpace)
            .padding(.horizontal,Constants.kbigSpace)

            if !message.isEmpty {
                Text(message)
                    .fontWeight(.semibold)
                    .font(.footnote)
                    .foregroundColor(message.contains("successfully") ? .green : .red)
                    .frame(maxWidth: .infinity,alignment: .leading)
                    .padding(.horizontal,Constants.kbigSpace)
                
            
                 
            }
            Spacer()
            
            
        }
        
        .onReceive(signInScreenViewModel.$user) { newValue in
            if newValue != nil {
                user = newValue
            }
            
        }
    }
}
