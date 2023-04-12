//
//  SupermarketCard.swift
//  Smarkt Go
//
//  Created by Zied Dahmani on 1/4/2023.
//

import SwiftUI
import URLImage

struct SupermarketCard: View {
    var image: String
    var title: String
    var subtitle: String
    
    var body: some View {
        ZStack(alignment: .bottomLeading) {
            URLImage(URL(string: Constants.kbaseUrl+"img/"+image)!) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: UIScreen.main.bounds.width - Constants.kbigSpace, height: UIScreen.main.bounds.height / 4)
            }
            
            VStack(alignment: .leading){
                Text(title)
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .shadow(color: .black, radius: Constants.kshadowRadius, x: 0, y: 2)
                Text(subtitle)
                    .font(.subheadline)
                    .foregroundColor(.white)
                    .shadow(color: .black, radius: Constants.kshadowRadius * 0.5, x: 0, y: 2)
            }
            .padding()
        }
        .background(.gray)
        .cornerRadius(Constants.kcornerRadius)
        .shadow(radius: Constants.kshadowRadius)
        .padding(.horizontal,Constants.kbigSpace)
        
    }
    
}


struct SupermarketCard_Previews: PreviewProvider {
    static var previews: some View {
        SupermarketCard(image: "1", title: "Supermarket 1", subtitle: "lorem")
    }
}
