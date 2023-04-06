//
//  ProfileScreen.swift
//  Smarkt Go
//
//  Created by Zied Dahmani on 14/1/2023.
//

import SwiftUI
import PhotosUI
import ImagePickerModule


struct ProfileScreen: View {
    @EnvironmentObject var signInScreenViewModel: SignInScreenViewModel
    @State var user : User?
    @State var isEditModeOn = false
    @State var editedName = ""
    @State var isPicker = false
    @State var selectedImage : UIImage?
    @State var isShowingImagePicker = false
    
    
    var body: some View {
        
        NavigationView{
            if user != nil {
                VStack{
                    if let image = selectedImage {
                        Image(uiImage: image)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
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
                                if !self.user!.isSignedInWithGoogle() {
                                    isShowingImagePicker = true
                                }
                            }
                    } else {
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
                            if !self.user!.isSignedInWithGoogle() {
                                isShowingImagePicker = true
                            }
                        }
                    }
                    
                    HStack{
                        if isEditModeOn {
                            TextField("Enter your name", text: $editedName)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .frame(width: UIScreen.main.bounds.width / 1.5)
                                .padding(Constants.ksmallSpace)
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
        
        .sheet(isPresented: $isShowingImagePicker) {
//            ImagePicker(sourceType: selectedImage, onImagePicked: isShowingImagePicker)
//                            .onDisappear {
//                                if let image = selectedImage {
//                                    signInScreenViewModel.uploadImage(id: user!.id, image: image)
//
//                                }
//
//                            }
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
