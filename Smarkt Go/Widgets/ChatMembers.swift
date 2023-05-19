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
    @State private var searchText = ""

    var body: some View {
        VStack {
            // Add search bar
            HStack {
                TextField("Search", text: $searchText)
                    .padding(.horizontal, Constants.khugeSpace)
                Button(action: {
                    searchText = ""
                }) {
                    Text("Cancel")
                }
                .padding(.trailing, Constants.khugeSpace)
                .opacity(searchText.isEmpty ? 0 : 1)
            }
            
            if showOrderImage {
                VStack(alignment: .center) {
                    Image("empty_cart")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: UIScreen.main.bounds.width - 40, height: UIScreen.main.bounds.height / 3)
                    
                    Text(Strings.knoChatMembers)
                        .fontWeight(.semibold)
                        .font(.subheadline)
                        .foregroundColor(Color.gray)
                        .padding(.top, Constants.ksmallSpace)
                }
            } else {
                ScrollView(showsIndicators: false) {
                    VStack {
                        ForEach(filteredUsers, id: \.id) { user in
                            UserCell(user: user) {
                                signInScreenViewModel.addUser(userId: user.id)
                                print("Plus button tapped for user: \(user.fullName)")
                            }
                        }
                    }
                }
            }
        }
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
    
    // Computed property to filter users based on search text
    var filteredUsers: [UserInfo] {
        if searchText.isEmpty {
            return signInScreenViewModel.aUsers.filter { $0.id != signInScreenViewModel.user?._id }
        } else {
            return signInScreenViewModel.aUsers.filter { $0.id != signInScreenViewModel.user?._id && $0.fullName.localizedCaseInsensitiveContains(searchText) }
        }
    }
}


struct ChatMembers_Previews: PreviewProvider {
    static var previews: some View {
        ChatMembers()
    }
}
