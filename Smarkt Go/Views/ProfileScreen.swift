//
//  ProfileScreen.swift
//  Smarkt Go
//
//  Created by Zied Dahmani on 14/1/2023.
//

import SwiftUI

struct ProfileScreen: View {
    @EnvironmentObject var signInScreenViewModel: SignInScreenViewModel

    var body: some View {
        
        NavigationView{
            VStack{
                
                AsyncImage(url: URL(string:"https://hws.dev/paul.jpg"),content: { image in
                    image.resizable()
                        .aspectRatio(contentMode: .fill)
                },
                placeholder: {
                    ProgressView()
                })
                .frame(width: 140, height:140)
                .cornerRadius(100)
                .overlay(
                    Circle()
                        .stroke(Color.white,lineWidth: 4)
                        .frame(width: 140, height: 140)
                )
                .shadow(radius: 10)
                .padding(.bottom,10)
                
                
                HStack{
 
//                   Text((signInScreenViewModel.currentUser?.id)!)
                    Text("Zied Dahmani")
                        .font(.title2)
                    Image(systemName: "pencil")
                        .resizable()
                        .frame(width: 16, height: 16)
                        .foregroundColor(.accentColor)
                        .onTapGesture{
                            signInScreenViewModel.signOut()
                        }
                }
                
                
                HStack{
                    Image(systemName: "dollarsign.circle.fill")
                    Text("9999")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                .padding(.bottom,20)
                
                
                List {
                    NavigationLink(destination: MainScreen()){
                        Text("Wallet")
                    }
                    NavigationLink(destination: MainScreen()) {
                        Text("Settings")
                    }
                }
                
                
            }
            .navigationTitle("Profile")
        }

    }
}

struct ProfileScreen_Previews: PreviewProvider {
    static var previews: some View {
        ProfileScreen()
    }
}
