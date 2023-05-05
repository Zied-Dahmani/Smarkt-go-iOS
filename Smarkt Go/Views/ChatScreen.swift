//
//  ChatScreen.swift
//  Smarkt Go
//
//  Created by user235448 on 4/26/23.
//

import SwiftUI

struct ChatScreen: View {
    @EnvironmentObject var signInScreenViewModel: SignInScreenViewModel

    @State var messageText: String = ""

    var body: some View {
        VStack {
            ScrollView{
                ForEach(signInScreenViewModel.chat, id: \.id) { message in
                    ChatCell( chat: message)
                }
            }
            // List of messages here
            Spacer()
            HStack {
                TextField("Type a message...", text: $messageText)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                Button(action: {
                    signInScreenViewModel.sendMessage(senderId: signInScreenViewModel.user!._id, content: messageText)
                    signInScreenViewModel.getChat(userId: signInScreenViewModel.user!._id){ statusCode in
                        print(statusCode)
                        if statusCode == 1 {
                            // success
                            // access the chat info from signInScreenViewModel.chat
                            print("Chat: \(signInScreenViewModel.chat)")
                        } else if statusCode == 0 {
                            print("User not authorized to access messages")
                        } else if statusCode == 2 {
                            print("No active order found")
                        } else {
                            print("Server error")
                        }
                    }
                    messageText = ""

                    // Send message action here
                }) {
                    Image(systemName: "paperplane.fill")
                        .foregroundColor(Color.blue)
                        .font(.system(size: 24))
                }
            }
        }
        .navigationBarItems(trailing: Button(action: {
            // Users icon action here
        }) {
            Image(systemName: "person.2.fill")
                .foregroundColor(Color.blue)
                .font(.system(size: 24))
        })
        .navigationBarTitle(Text("Chat"), displayMode: .inline)
        .onAppear(){
            signInScreenViewModel.getChat(userId: signInScreenViewModel.user!._id){ statusCode in
                print(statusCode)
                if statusCode == 1 {
                    // success
                    // access the chat info from signInScreenViewModel.chat
                    print("Chat: \(signInScreenViewModel.chat)")
                } else if statusCode == 0 {
                    print("User not authorized to access messages")
                } else if statusCode == 2 {
                    print("No active order found")
                } else {
                    print("Server error")
                }
            }
        }
    }
        
}


struct ChatScreen_Previews: PreviewProvider {
    static var previews: some View {
        ChatScreen()
    }
}
