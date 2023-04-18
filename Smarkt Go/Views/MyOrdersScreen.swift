//
//  MyOrdersScreen.swift
//  Smarkt Go
//
//  Created by Zied Dahmani on 18/4/2023.
//

import SwiftUI
import Kingfisher

struct MyOrdersScreen: View {
    
    @ObservedObject var cartScreenViewModel = CartScreenViewModel()
    @EnvironmentObject var signInScreenViewModel: SignInScreenViewModel
    
    var body: some View {
        VStack{
            if cartScreenViewModel.myOrders.isEmpty
            {
                VStack(alignment: .center) {
                    Image("empty_cart")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: UIScreen.main.bounds.width - 80, height:UIScreen.main.bounds.height / 4)
                    
                    Text(Strings.knoOrders)
                        .fontWeight(.semibold)
                        .font(.subheadline)
                        .foregroundColor(Color.gray)
                        .padding(.top, Constants.ksmallSpace)
                }
                
            }
            else {
                ScrollView(showsIndicators: false) {
                    VStack {
                        ForEach(cartScreenViewModel.myOrders) { myOrder in
                            VStack(alignment: .leading){
                                HStack{
                                    Image(systemName: "mappin")
                                        .foregroundColor(.black)
                                    Text(myOrder.items[0].supermarketName)
                                        .font(.subheadline)
                                        .foregroundColor(.black)
                                }
                                
                                ScrollView(.horizontal, showsIndicators: false) {
                                    HStack { // Use HStack to horizontally layout the items
                                        ForEach(myOrder.items) { item in
                                            VStack {
                                                KFImage(URL(string: item.image))
                                                    .resizable()
                                                    .aspectRatio(contentMode: .fill)
                                                    .frame(width: Constants.kbigSpace * 4, height: Constants.kbigSpace * 4)
                                                    .background(Color.white)
                                                    .cornerRadius(Constants.kcornerRadius)
                                                    .shadow(radius: Constants.kshadowRadius)
                                                
                                                Text("x"+String(item.quantity!))
                                                    .font(.subheadline)
                                                    .foregroundColor(.black)


                                            }
                                            .padding(.vertical,Constants.ksmallSpace)
                                        }
                                    }
                                    .padding(.horizontal)
                                }
                                
                            }
                            
                        }
                    }
                    .padding(Constants.ksmallSpace)
                }
                
            }
        }
        .onAppear{
            cartScreenViewModel.getMyOrders(token: signInScreenViewModel.user!.token)
        }
           
        
    }
}

struct MyOrdersScreen_Previews: PreviewProvider {
    static var previews: some View {
        MyOrdersScreen()
    }
}
