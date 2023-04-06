//
//  ItemCard.swift
//  Smarkt Go
//
//  Created by Zied Dahmani on 5/4/2023.
//

import SwiftUI
import URLImage

struct ItemCard: View {
    var item: Item
    
    var body: some View {
        VStack(alignment: .leading){
            HStack(alignment: .top){
                URLImage(URL(string: item.image )!) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: Constants.kbigSpace * 3, height: Constants.kbigSpace * 3)
                    
                }
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
                        Text(String(item.price))
                            .font(.subheadline)
                            .foregroundColor(.gray)
                        
                        
                    }
                    
                }
                Spacer()
                
                Image(systemName: "plus")
                    .foregroundColor(.white)
                    .font(.system(size: Constants.kiconSize))
                    .frame(width: Constants.kbigSpace*2, height: Constants.kbigSpace*2)
                    .background(Color.green)
                    .cornerRadius(Constants.kcornerRadius)
                    .shadow(radius: Constants.kshadowRadius)
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
        ItemCard(item: Item(id: "String", name: "String", image: "https://courses.monoprix.tn/carthage/146350-large_default/concombre.jpg", description: "String", price: 10, category: "String", supermarketId: "", supermarketName: "String"))
    }
}
