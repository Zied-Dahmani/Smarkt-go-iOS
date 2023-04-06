//
//  ItemCategoryCard.swift
//  Smarkt Go
//
//  Created by Zied Dahmani on 5/4/2023.
//

import SwiftUI
import URLImage

struct ItemCategoryCard: View {
    let category: String
    
    var body: some View {
        HStack{
            URLImage(URL(string: Constants.kbaseUrl+"img/"+category+".jpeg")!) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: Constants.kbigSpace * 3, height: Constants.kbigSpace * 3)                
            }
            .background(Color.white)
            .cornerRadius(Constants.kcornerRadius)
            .shadow(radius: Constants.kshadowRadius)
            
            Text(category)
                .font(.subheadline)
                .fontWeight(.bold)
                .foregroundColor(.black)
                .padding(.leading,Constants.ksmallSpace)
            Spacer()
            Image(systemName: "chevron.right")
                .foregroundColor(.accentColor)
        }
    }
}

struct ItemCategoryCard_Previews: PreviewProvider {
    static var previews: some View {
        ItemCategoryCard(category: "Fruits")
    }
}
