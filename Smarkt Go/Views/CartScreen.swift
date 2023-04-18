//
//  CartScreen.swift
//  Smarkt Go
//
//  Created by Zied Dahmani on 8/4/2023.
//

import SwiftUI

struct CartScreen: View {
    @ObservedObject var cartScreenViewModel = CartScreenViewModel()
    @EnvironmentObject var signInScreenViewModel: SignInScreenViewModel
    @EnvironmentObject var supermarketViewModel: SupermarketsScreenViewModel
    @State private var showBottomSheet = false

    
    var body: some View {
        NavigationView{
            VStack(alignment: .leading){
                if cartScreenViewModel.order != nil {
                    if true {
                        HStack{
                            Image(systemName: "mappin")
                                .foregroundColor(.black)
                            Text(cartScreenViewModel.order!.items[0].supermarketName)
                                .foregroundColor(.black)
                                .font(.headline)
                        }
                        .padding(.top,Constants.kbigSpace)
                        .padding(.horizontal,Constants.ksmallSpace)
                        
                        ScrollView(showsIndicators: false) {
                            VStack(alignment: .leading){
                                if let token = signInScreenViewModel.user?.token {
                                    ForEach(cartScreenViewModel.order!.items) { item in
                                            ItemCard(item:item,fromCartScreen:true,removeItem: {
                                                cartScreenViewModel.removeItem(item:item,token: token)
                                            })
                                            .padding(.top,Constants.ksmallSpace)
                                    }
                                }
                            }
                            HStack(alignment: .top){
                                VStack{
                                    Text(Strings.ktotal)
                                        .foregroundColor(.black)
                                        .font(.headline)
                                        .fontWeight(.bold)
                                    Text(String(format: "%.3f", cartScreenViewModel.getTotal()))
                                        .foregroundColor(.black)
                                        .font(.subheadline)
                                }
                                Spacer()
                                Image(systemName: "dollarsign")
                                    .foregroundColor(.white)
                                    .font(.system(size: Constants.kiconSize))
                                    .frame(width: Constants.kbigSpace*2, height: Constants.kbigSpace*2)
                                    .background(Color.green)
                                    .cornerRadius(Constants.kcornerRadius)
                                    .shadow(radius: Constants.kshadowRadius)
                                    .onTapGesture {
                                        showBottomSheet = true
                                    }
                                
                            }
                            .padding()
                        }
                        .padding(.vertical,Constants.ksmallSpace)
                    }
                    
                }
                else if cartScreenViewModel.statusCode == 400{
                    VStack(alignment: .center) {
                        Image("empty_cart")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: UIScreen.main.bounds.width - 80, height:UIScreen.main.bounds.height / 4)
                        
                        Text(Strings.kemptyCart)
                            .fontWeight(.semibold)
                            .font(.subheadline)
                            .foregroundColor(Color.gray)
                            .padding(.top, Constants.ksmallSpace)
                    }
                }
            }
            .navigationTitle(Strings.kcart)
        }
        .onAppear {
            if let token = signInScreenViewModel.user?.token {
                cartScreenViewModel.getOrder(token: token)
            }
        }
        .sheet(isPresented: $showBottomSheet) {
            PaymentSheetView(total: cartScreenViewModel.getTotal(),cartScreenViewModel: cartScreenViewModel)
            }
    }
}


struct CartScreen_Previews: PreviewProvider {
    static var previews: some View {
        CartScreen()
    }
}
