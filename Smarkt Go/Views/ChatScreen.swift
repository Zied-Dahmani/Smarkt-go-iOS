//
//  UserCell.swift
//  Smarkt Go
//
//  Created by user235448 on 4/25/23.
//

import SwiftUI

struct ChatScreen: View {
    @EnvironmentObject var signInScreenViewModel: SignInScreenViewModel
    @State private var isPresented = false
    
    var body: some View {
        VStack {
            ScrollView(.horizontal) {
                HStack(spacing: 10) {
                    ForEach(signInScreenViewModel.Users) { user in
                        UserCell(user: user)
                            .onTapGesture {
                                isPresented = true
                            }
                            .sheet(isPresented: $isPresented) {
                                ChatView(user: user, isPresented: $isPresented)
                            }
                    }
                }
                .onAppear {
                    signInScreenViewModel.getAllUsers()
                }
            }
            .padding(.horizontal)
            Spacer()
        }
        .padding(.top)
    }
}

struct ChatView: View {
    let user: User
    @Binding var isPresented: Bool
    
    @State private var messageText = ""
    
    var body: some View {
        NavigationView {
            VStack {
                ScrollView {
                    // chat here
                }
                HStack {
                    TextField("Enter message here", text: $messageText)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    Button(action: {
                        // send
                    }) {
                        Image(systemName: "paperplane")
                            .foregroundColor(.blue)
                    }
                }
                .padding()
            }
            .navigationBarTitle(user.fullName)
            .navigationBarItems(trailing:
                Button("Cancel") {
                    isPresented = false
                }
            )
        }
    }
}

struct ChatScreen_Previews: PreviewProvider {
    static var previews: some View {
        ChatScreen()
    }
}

