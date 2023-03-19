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
                    .frame(width: Constants.kbuttonHeight * 2.8, height:Constants.kbuttonHeight * 2.8)
                    .cornerRadius(Constants.kcornerRadius * 10)
                    .overlay(
                        Circle()
                            .stroke(Color.white,lineWidth: Constants.kdividerHeight * 2)
                            .frame(width: Constants.kbuttonHeight * 2.8, height: Constants.kbuttonHeight * 2.8)
                    )
                    .shadow(radius: Constants.kshadowRadius * 2)
                    .padding(.bottom,Constants.ksmallSpace)
                    
                    HStack{
                        Text(self.user!.fullName)
                            .font(.title2)
                        if !self.user!.isSignedInWithGoogle() {
                            Image(systemName: "pencil")
                                .resizable()
                                .frame(width: Constants.kiconSize / 1.3, height: Constants.kiconSize / 1.3)
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
                    .padding(.bottom,Constants.kbigSpace)
                    
                    List {
                        NavigationLink(destination: SettingsScreen()){
                            Text(Strings.kwallet)
                        }
                        NavigationLink(destination: SettingsScreen()) {
                            Text(Strings.ksettings)
                        }
                    }
                    
                    
                }
                .navigationTitle(Strings.kprofile)
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
