//
//  ReviewSheet.swift
//  Smarkt Go
//
//  Created by user235448 on 4/23/23.
//


import SwiftUI

struct ReviewCell: View {
 
    var review: Review

    var body: some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text(review.title)
                        .font(.headline)
                        .fontWeight(.bold)
                    Spacer()
                    HStack(spacing: 4) {
                        ForEach(1...5, id: \.self) { index in
                            Image(systemName: index <= Int(review.rating) ? "star.fill" : "star")
                                .foregroundColor(.yellow)
                        }
                    }
                }
            
                Text(review.description)
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            Spacer()
           
        }
        .padding()
        .background(Color.white)
        .cornerRadius(8)
        .shadow(radius: 4)
    }
}

struct ReviewCell_Previews: PreviewProvider {
    static var previews: some View {
        HomeScreen()
    }
}
