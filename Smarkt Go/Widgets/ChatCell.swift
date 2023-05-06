//
//  ChatCell.swift
//  Smarkt Go
//
//  Created by user235448 on 5/5/23.
//

import SwiftUI

struct ChatCell: View {
    let chat: ChatInfo

 
    
    var body: some View {
        HStack {
            AsyncImage(url: URL(string: chat.getImage()),content: { image in
                image.resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: Constants.kbuttonHeight , height:Constants.kbuttonHeight)
                    .clipShape(Circle())

            },
                       placeholder: {
                ProgressView()
            })
        
            VStack(alignment: .leading) {
                Text(chat.fullName)
                    .font(.headline)
                Text(chat.content)
                    .font(.subheadline)
                
                Text(chat.formattedCreatedAt)
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            Spacer()
        }
        .padding()
    }
}


struct ChatCell_Previews: PreviewProvider {
    static var previews: some View {
        HomeScreen()
    }
}
