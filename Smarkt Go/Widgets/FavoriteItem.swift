//
//  FavoriteItem.swift
//  Smarkt Go
//
//  Created by user235448 on 3/31/23.
//

import SwiftUI
struct FavoriteItem: View {
    let shadowColor = Color(red: 33/255, green: 174/255, blue: 57/255)
    var imageName: String
    var text1: String
    var text2: String
    
    var body: some View {
        HStack {
            AsyncImage(url: URL(string: imageName), content: { image in
                image
                    .resizable()
                    .frame(width: 80, height: 80)
                    .clipShape(Circle())
                    .shadow(radius: 5)
                    .padding(.leading, 15)
                    .padding(.vertical, 10)
            }, placeholder: {
                ProgressView()
            })
            
            VStack(alignment: .leading, spacing: 15) {
                Text(text1)
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(.white)
                    .padding(.trailing,15)
                
                Text(text2)
                    .font(.system(size: 20, weight: .regular))
                    .foregroundColor(.white)
                    .padding(.trailing,15)
            }
            .padding(.leading,20)
            
            Spacer()
            
            
        }
        .padding(.leading, 20)
        .background(Color.accentColor)
        .cornerRadius(15)
        .shadow(color: shadowColor.opacity(0.8), radius: 10)
        .padding()
        .cornerRadius(20)
    }
}

