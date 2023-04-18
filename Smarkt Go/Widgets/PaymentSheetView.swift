//
//  PaymentSheetView.swift
//  Smarkt Go
//
//  Created by Zied Dahmani on 9/4/2023.
//

import SwiftUI

struct PaymentSheetView: View {
    
//    let user:User
    let total:Float
    @State private var showAlert = false
    @State private var title = ""
    @State private var message = ""
    @Environment(\.presentationMode) var presentationMode
    let cartScreenViewModel:CartScreenViewModel
    @EnvironmentObject var signInScreenViewModel: SignInScreenViewModel
    @EnvironmentObject var supermarketViewModel: SupermarketsScreenViewModel



    
    var body: some View {
        VStack(alignment: .leading){
            Image("wallet")
                .resizable()
                .frame(width: UIScreen.main.bounds.width - 40, height:UIScreen.main.bounds.height / 2.5)
                .aspectRatio(contentMode: .fit)
            
            Text(Strings.kconfirmPayment)
                .font(.system(size: 26, weight: .bold, design: .default))
                .foregroundColor(.black)
            
            HStack{
                Text(Strings.kwallet+": ")
                    .font(.subheadline)
                    .foregroundColor(.black)
                Text(String(format: "%.3f", signInScreenViewModel.user!.wallet))
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            HStack{
                Text(Strings.ktotal+": ")
                    .font(.subheadline)
                    .foregroundColor(.black)
                Text(String(format: "%.3f", total))
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            
            CustomButton(text: Strings.kpay, icon: "dollarsign", textColor: .white, iconColor: .white, backgroundColor: .accentColor,action:{
                if signInScreenViewModel.user!.wallet >= total {
                    cartScreenViewModel.pay(token: signInScreenViewModel.user!.token, total: total) { success in
                        if success {
                            title = Strings.ksuccess
                            message = Strings.kwalletUpToDate
                            showAlert = true
                            signInScreenViewModel.user?.wallet -= total
//                            supermarketViewModel.getBestSellers()
                            
                        } else {
                            title = Strings.kfailure
                            message = Strings.kpaymentFailed
                            showAlert = true
                        }
                    }
                }
                else{
                    title = Strings.kfailure
                    message = Strings.knotEnoughMoney
                    showAlert = true
                }
            }
            )
            .padding(.top,Constants.ksmallSpace)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.white)
        .padding(.horizontal,Constants.kbigSpace)
        .alert(isPresented: $showAlert) {
            Alert(title: Text(title), message: Text(message), dismissButton: .default(Text("OK"),action: {
                presentationMode.wrappedValue.dismiss()
            }))
        }
    }
    
}


struct PaymentSheetView_Previews: PreviewProvider {
    static var previews: some View {
        MainScreen()
    }
}
