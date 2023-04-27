//
//  UserCell.swift
//  Smarkt Go
//
//  Created by user235448 on 4/25/23.
//

import SwiftUI

struct UserCell: View {
    let user: User
    
    var body: some View {
        VStack {
            Image(user.image)
                .resizable()
                .scaledToFit()
                .frame(width: 100, height: 100)
                .clipShape(Circle())
            Text(user.fullName)
        }
        .padding(.horizontal)
    }
}

struct UserCell_Previews: PreviewProvider {
    static var previews: some View {
     HomeScreen()

    }
}
