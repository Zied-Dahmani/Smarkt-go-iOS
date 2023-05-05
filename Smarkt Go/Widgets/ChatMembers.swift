//
//  ChatMembers.swift
//  Smarkt Go
//
//  Created by user235448 on 4/29/23.
//

import SwiftUI

struct ChatMembers: View {
    @EnvironmentObject var signInScreenViewModel: SignInScreenViewModel
    @State private var showOrderImage = false

    var body: some View {
        VStack {
            if showOrderImage {              
                VStack(alignment: .center) {
                    Image("empty_cart")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: UIScreen.main.bounds.width - 40, height:UIScreen.main.bounds.height / 3)
                    
                    Text(Strings.knoChatMembers)
                        .fontWeight(.semibold)
                        .font(.subheadline)
                        .foregroundColor(Color.gray)
                        .padding(.top, Constants.ksmallSpace)
                }
                
                
            } else {
                ScrollView (showsIndicators: false){
                    VStack  {
                        ForEach(signInScreenViewModel.aUsers, id: \.id) { user in
                            UserCell(user: user)
                            {
                                signInScreenViewModel.addUser(userId: user.id)
                                print("Plus button tapped for user: \(user.fullName)")
                            }
                        }

                        }
                        
                    }
                }}
        .onAppear() {
            signInScreenViewModel.getNonMembers() { statusCode, users in
                if statusCode == 200 {
                    guard let users = users else { return }
                    print("Users: \(users)")
                    signInScreenViewModel.aUsers = users
                    self.showOrderImage = false
                } else if statusCode == 403 {
                    print("No data found")
                    self.showOrderImage = true
                } else {
                    print("Server error")
                    self.showOrderImage = false
                }
            }
        }
    }
}

struct ChatMembers_Previews: PreviewProvider {
    static var previews: some View {
        ChatMembers()
    }
}
