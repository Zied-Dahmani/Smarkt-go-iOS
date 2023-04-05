//
//  ProfileScreen.swift
//  Smarkt Go
//
//  Created by Zied Dahmani on 14/1/2023.
//

import SwiftUI
import PhotosUI

struct ProfileScreen: View {
    @EnvironmentObject var signInScreenViewModel: SignInScreenViewModel
    @State var user : User?
    @State var isEditModeOn = false
    @State var editedName = ""
    @State var isPicker = false
    @State var selectedImage : UIImage?
    
    
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
                    .onTapGesture {
                        isPicker = true
                        if let user = user, let image = selectedImage {
                                        signInScreenViewModel.uploadImage(id: user.id, image: image)
                                    }
                    }
                    if selectedImage != nil {
                        
                        Image(uiImage: selectedImage!)
                            .resizable()
                            .frame(width:200,height: 200)
                    } else {
                        Text("No image selected")
                    }
                    
                    HStack{
                        if isEditModeOn {
                            TextField("Enter your name", text: $editedName)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .padding(.leading, Constants.kbigSpace)
                        } else {
                            Text(self.user!.fullName)
                                .font(.title2)
                            
                        }
                        if isEditModeOn {
                            Button("Save") {
                                user?.fullName = editedName
                                isEditModeOn = false
                                signInScreenViewModel.updateProfile(id: user!.id, fullName: editedName, wallet: user!.wallet.formatted()) { error in
                                    if let error = error {
                                        print("Error updating profile: \(error)")
                                    } else {
                                        print("updated")
                                    }
                                }
                            }.foregroundColor(.accentColor)
                        } else if !self.user!.isSignedInWithGoogle() {
                            Image(systemName: "pencil")
                                .resizable()
                                .frame(width: Constants.kiconSize / 1.3, height: Constants.kiconSize / 1.3)
                                .foregroundColor(.accentColor)
                                .onTapGesture{
                                    isEditModeOn = true
                                    editedName = user?.fullName ?? ""
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
                        NavigationLink(destination: WalletScreen()){
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
        }.sheet(isPresented: $isPicker , onDismiss: nil)
        {
            ImagePicker(selectedImage: $selectedImage, isPicker: $isPicker)
        }
        
    }
    
}

struct ProfileScreen_Previews: PreviewProvider {
    static var previews: some View {
        ProfileScreen()
    }
}
