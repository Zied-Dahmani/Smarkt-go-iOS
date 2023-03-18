//
//  ProfileScreen.swift
//  Smarkt Go
//
//  Created by Zied Dahmani on 14/1/2023.
//

import SwiftUI

struct ProfileScreen: View {
    @EnvironmentObject var signInScreenViewModel: SignInScreenViewModel
    
    @State var user : User?
    
    var body: some View {
        
        NavigationView{
            if user != nil {
                VStack{
                    
                    AsyncImage(url: URL(string: self.user!.getImage()),content: { image in
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
                        Text(self.user!.fullName)
                            .font(.title2)
                        if self.user!.isSignedWithPhone() {
                            Image(systemName: "pencil")
                                .resizable()
                                .frame(width: 16, height: 16)
                                .foregroundColor(.accentColor)
                                .onTapGesture{
                                    signInScreenViewModel.signOut()
                                }
                        }
                    }
                    
                    
                    HStack{
                        Image(systemName: "dollarsign.circle.fill")
                        Text(String(self.user!.wallet))
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                    .padding(.bottom,20)
                    
                    List {
                        NavigationLink(destination: SettingsScreen()){
                            Text("Wallet")
                        }
                        NavigationLink(destination: SettingsScreen()) {
                            Text("Settings")
                        }
                    }
                    
                    
                }
                .navigationTitle("Profile")
            }
        }
        .onReceive(signInScreenViewModel.$user) { newValue in
            if newValue != nil {
                user = newValue
            }
        }
        
    }
    
}

struct ProfileScreen_Previews: PreviewProvider {
    static var previews: some View {
        ProfileScreen()
    }
}
