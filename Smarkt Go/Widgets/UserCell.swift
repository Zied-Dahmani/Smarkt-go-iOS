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
    @State private var isSent = false
    var body: some View {
        HStack {
            Image(user.getImage())
                .resizable()
                .scaledToFit()
                .frame(width: 100, height: 100)
                .clipShape(Circle())
            Text(user.fullName)
            Spacer()
            if isSent { // Check the state variable to show the sent text
                            Text("Sent")
                                .font(.system(size: 20))
                                .foregroundColor(.blue)
                        } else {
                            Button(action: {
                                self.onTapPlus?()
                                self.isSent = true // Set the state variable to true
                            }, label: {
                                Image(systemName: "plus.circle")
                                    .font(.system(size: 20))
                                    .foregroundColor(.blue)
                            })
                        }
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
