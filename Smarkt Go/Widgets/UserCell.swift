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
            AsyncImage(url: URL(string: user.getImage()),content: { image in
                image.resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: Constants.kbuttonHeight , height:Constants.kbuttonHeight)
                    .clipShape(Circle())

            },
                       placeholder: {
                ProgressView()
            })
            Text(user.fullName)
            Spacer()
            if isSent {
                            Text("Sent")
                                .font(.system(size: 20))
                                .foregroundColor(.blue)
                        } else {
                            Button(action: {
                                self.onTapPlus?()
                                self.isSent = true 
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
