//
//  ItemCard.swift
//  Smarkt Go
//
//  Created by Zied Dahmani on 5/4/2023.
//

import SwiftUI
import URLImage
import Kingfisher

struct ItemCard: View {
    @State private var showingQuantityPicker = false
    var item: Item
    @EnvironmentObject var signInScreenViewModel:SignInScreenViewModel
    let fromCartScreen: Bool
    let removeItem: () -> Void


    var body: some View {
        VStack(alignment: .leading){
            HStack(alignment: .top){
                KFImage(URL(string: item.image))
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: Constants.kbigSpace * 3, height: Constants.kbigSpace * 3)
                
                .background(Color.white)
                .cornerRadius(Constants.kcornerRadius)
                .shadow(radius: Constants.kshadowRadius)
                VStack(alignment: .leading){
                    Text(item.name)
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundColor(.black)
                    HStack{
                        Image(systemName: "dollarsign")
                            .foregroundColor(.gray)
                            .font(.system(size: Constants.kiconSize / 1.5))
                        Text(String(format: "%.3f", item.price))
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                    
                }
                Spacer()
                
                if fromCartScreen {
                    Image(systemName: "minus")
                        .foregroundColor(.white)
                        .font(.system(size: Constants.kiconSize))
                        .frame(width: Constants.kbigSpace*2, height: Constants.kbigSpace*2)
                        .background(Color.red)
                        .cornerRadius(Constants.kcornerRadius)
                        .shadow(radius: Constants.kshadowRadius)
                        .onTapGesture {
                            removeItem()
                        }
                }
                else {
                    Image(systemName: "plus")
                        .foregroundColor(.white)
                        .font(.system(size: Constants.kiconSize))
                        .frame(width: Constants.kbigSpace*2, height: Constants.kbigSpace*2)
                        .background(Color.green)
                        .cornerRadius(Constants.kcornerRadius)
                        .shadow(radius: Constants.kshadowRadius)
                        .onTapGesture {
                            showingQuantityPicker = true
                        }
                        .sheet(isPresented: $showingQuantityPicker) {
                            QuantityPicker(token:signInScreenViewModel.user!.token,item: item)
                        }
                }
                
                
            }
            Text(item.description)
                .font(.footnote)
                .foregroundColor(.gray)
            Divider()
        }
        .padding(.horizontal)
    }
    
}


struct ItemCard_Previews: PreviewProvider {
    static var previews: some View {
            HomeScreen()
        }
}
