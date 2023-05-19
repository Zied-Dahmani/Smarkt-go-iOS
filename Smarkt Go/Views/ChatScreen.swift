//
//  ChatScreen.swift
//  Smarkt Go
//
//  Created by user235448 on 4/26/23.
//

import SwiftUI
import SocketIO

struct ChatScreen: View {
    @EnvironmentObject var signInScreenViewModel: SignInScreenViewModel
    @EnvironmentObject var supermarketsScreenViewModel:SupermarketsScreenViewModel

    @State var messageText: String = ""
    @State private var status = 0
    let socketIOManager = SocketIOManager()

    var body: some View {
        
        VStack {
            ScrollView{
                ForEach(supermarketsScreenViewModel.chat, id: \.id) { message in
                    ChatCell( chat: message)
                }
            }
            Spacer()
            if status == 1 {
                           HStack {
                               TextField("Type a message...", text: $messageText)
                                   .textFieldStyle(RoundedBorderTextFieldStyle())
                               Button(action: {
                                   sendmsg()
                                /*   supermarketsScreenViewModel.sendMessage(senderId: signInScreenViewModel.user!._id, content: messageText)
                                   self.socketIOManager.socket.emit("send",signInScreenViewModel.user!._id)
                                   supermarketsScreenViewModel.getChat(userId: signInScreenViewModel.user!._id){ statusCode in
                                       print(statusCode)
                                       if statusCode == 1 {
                                           print("Chat: \(supermarketsScreenViewModel.chat)")
                                       } else if statusCode == 0 {
                                           print("User not authorized to access messages")
                                       } else if statusCode == 2 {
                                           print("No active order found")
                                       } else {
                                           print("Server error")
                                       }
                                   }
                                   messageText = ""*/
                               }) {
                                   Image(systemName: "paperplane.fill")
                                       .foregroundColor(Color.blue)
                                       .font(.system(size: 24))
                               }
                               Button(action: {
                                         // Refresh the chat
                                         supermarketsScreenViewModel.getChat(userId: signInScreenViewModel.user!._id){ statusCode in
                                             print(statusCode)
                                             if statusCode == 1 {
                                                 print("Chat: \(supermarketsScreenViewModel.chat)")
                                             } else if statusCode == 0 {
                                                 print("User not authorized to access messages")
                                             } else if statusCode == 2 {
                                                 print("No active order found")
                                             } else {
                                                 print("Server error")
                                             }
                                         }
                                     }) {
                                         // Use the refresh icon for the refresh button
                                         Image(systemName: "arrow.clockwise")
                                             .foregroundColor(Color.blue)
                                             .font(.system(size: 24))
                                     }
                                 
                           }
                       } else {
                           VStack(alignment: .center) {
                               Image("empty_cart")
                                   .resizable()
                                   .aspectRatio(contentMode: .fit)
                                   .frame(width: UIScreen.main.bounds.width - 40, height:UIScreen.main.bounds.height / 3)
                               
                               Text(Strings.knoChat)
                                   .fontWeight(.semibold)
                                   .font(.subheadline)
                                   .foregroundColor(Color.gray)
                                   .padding(.top, Constants.ksmallSpace)
                           }
                       }
            
                   }
        .navigationBarItems(trailing: Button(action: {
        }) {
            
            Image(systemName: "person.2.fill")
                .foregroundColor(Color.blue)
                .font(.system(size: 24))
        })
        .navigationBarTitle(Text("Chat"), displayMode: .inline)
        .onAppear(){
            supermarketsScreenViewModel.getChat(userId: signInScreenViewModel.user!._id){ statusCode in
                status = statusCode
                print(statusCode)
                if statusCode == 1 {
                   
                    print("Chat: \(supermarketsScreenViewModel.chat)")
                } else if statusCode == 0 {
                    print("User not authorized to access messages")
                } else if statusCode == 2 {
                    print("No active order found")
                } else {
                    print("Server error")
                }
            }
            socketIOManager.start(
                               onConnect: {
                                   socketIOManager.config(id: signInScreenViewModel.user!._id)
                               },
                               onReady: {
                                   supermarketsScreenViewModel.refresh(s: socketIOManager.socket, id: signInScreenViewModel.user!._id)
                                   
                               }
                           )
        }
        .onChange(of: supermarketsScreenViewModel.chat) { newValue in
            supermarketsScreenViewModel.chat = newValue
    print("change")
            supermarketsScreenViewModel.getChat(userId: signInScreenViewModel.user!._id){ statusCode in
                status = statusCode
                print(statusCode)
                if statusCode == 1 {
                   
                    print("Chat: \(supermarketsScreenViewModel.chat)")
                } else if statusCode == 0 {
                    print("User not authorized to access messages")
                } else if statusCode == 2 {
                    print("No active order found")
                } else {
                    print("Server error")
                }
            }
    }.onDisappear {
        self.socketIOManager.socket.disconnect()
    }
        .padding(.top,Constants.khugeSpace)
    }
        
    func sendmsg()  {
        supermarketsScreenViewModel.sendMessage(senderId: signInScreenViewModel.user!._id, content: messageText)
        supermarketsScreenViewModel.getChat(userId: signInScreenViewModel.user!._id){ statusCode in
            print(statusCode)
            if statusCode == 1 {
                print("Chat: \(supermarketsScreenViewModel.chat)")
            } else if statusCode == 0 {
                print("User not authorized to access messages")
            } else if statusCode == 2 {
                print("No active order found")
            } else {
                print("Server error")
            }
        }
        self.socketIOManager.socket.emit("send",signInScreenViewModel.user!._id)
        
        messageText = ""
    }
}


