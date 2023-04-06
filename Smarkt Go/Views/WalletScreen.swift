//
//  WalletScreen.swift
//  Smarkt Go
//
//  Created by user235448 on 3/29/23.
//

import SwiftUI

struct WalletScreen: View {
    @State private var Code = ""
    
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
            
            Text(Strings.kCode)
                .font(.subheadline)
                .foregroundColor(.gray)
            
            CustomTextField(text: Strings.kverificationCode, keyboardType: .numberPad, textValue: $Code)
            
            
            CustomButton(text: Strings.kverifyWallet, icon: "", textColor: .white, iconColor: .white, backgroundColor: .accentColor,action:{
            }
            )
            .padding(.top,Constants.ksmallSpace)
            
            Spacer()
            
        }
        
    }
}

struct WalletScreen_Previews: PreviewProvider {
    static var previews: some View {
        WalletScreen()
    }
}
