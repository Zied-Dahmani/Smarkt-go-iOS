//
//  UserCell.swift
//  Smarkt Go
//
//  Created by user235448 on 4/21/23.
//

import SwiftUI

struct UserCell: View {
    let user: UserInfo
    var onTapPlus: (() -> Void)?

    var body: some View {
        HStack {
            Image(user.getImage())
                .resizable()
                .scaledToFit()
                .frame(width: 100, height: 100)
                .clipShape(Circle())
            Text(user.fullName)
            Spacer()
            Button(action: {
                self.onTapPlus?()

                // Add your action here
            }, label: {
                Image(systemName: "plus.circle")
                    .font(.system(size: 20))
                    .foregroundColor(.blue)
            })
        }
        .padding(.horizontal)
    }
}


struct UserCell_Previews: PreviewProvider {
    static var previews: some View {
        let user = UserInfo(id: "id", fullName: "slouma", image: "image")

        UserCell(user: user)

    }
}
