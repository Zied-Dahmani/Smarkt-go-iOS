//
//  SupermarketScreen.swift
//  Smarkt Go
//
//  Created by Zied Dahmani on 2/4/2023.
//

import SwiftUI
import Kingfisher

struct SupermarketScreen: View {
    @Environment(\.presentationMode) var presentationMode
    let supermarket: Supermarket
    @EnvironmentObject var supermarketsScreenViewModel:SupermarketsScreenViewModel
    @State private var isPresented = false
    @State private var itemCategory = ""
    
    var body: some View {
        VStack(alignment: .leading){
            ZStack(alignment: .topLeading) {
                TabView {
                    ForEach(supermarket.images, id: \.self) { image in
                        KFImage(URL(string: Constants.kbaseUrl+"img/"+image))
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: UIScreen.main.bounds.width - Constants.kbigSpace, height: UIScreen.main.bounds.height / 4)
                        
                    }
                }
                .tabViewStyle(PageTabViewStyle())
                .onAppear {
                    setupAppearance()
                    supermarketsScreenViewModel.isFavorite(supermarketId: supermarket.id)

                }
                
                HStack{
                    ZStack {
                        Rectangle()
                            .fill(Color.accentColor)
                            .cornerRadius(Constants.kcornerRadius)
                        Image(systemName: "chevron.left")
                            .foregroundColor(.white)
                            .imageScale(.large)
                            .onTapGesture {
                                presentationMode.wrappedValue.dismiss()
                            }
                    }
                    .frame(width: Constants.kiconSize * 2.25, height: Constants.kiconSize * 2.25)
                    Spacer()
                    ZStack {
                        Rectangle()
                            .fill(Color.accentColor)
                            .cornerRadius(Constants.kcornerRadius)
                        if let favorites = supermarketsScreenViewModel.ufavorites, let userLoggedIn = supermarketsScreenViewModel.userLoggedIn {
                            Image(systemName: favorites.contains(userLoggedIn) ? "heart.fill" : "heart")
                                .foregroundColor(.white)
                                .imageScale(.large)
                                .onTapGesture {
                                    if favorites.contains(userLoggedIn) {
                                        print("found")
                                           supermarketsScreenViewModel.removeFromFavorites(supermarketID: supermarket.id,userId: userLoggedIn)
                                    } else {
                                        print("not found")
                                            supermarketsScreenViewModel.addToFavorites(supermarketID: supermarket.id,userId: userLoggedIn)
                                    }
                                }
                        } else {
                        
                        }

                    }
                    .frame(width: Constants.kiconSize * 2.25, height: Constants.kiconSize * 2.25)
                    
                }
                .padding(.horizontal,Constants.kbigSpace)
                .padding(.top,Constants.ksmallSpace)
                
                
            }
            .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height / 4)
            
            HStack{
                VStack(alignment: .leading){
                    Text(supermarket.name)
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.black)
                    HStack{
                        Image(systemName: "mappin")
                            .foregroundColor(.black)
                        Text(supermarket.address)
                            .font(.subheadline)
                            .foregroundColor(.black)
                    }
                }
                Spacer()
                Image(systemName: "map")
                    .foregroundColor(.accentColor)
                    .onTapGesture {
                        supermarketsScreenViewModel.launchGoogleMaps(supermarket: supermarket)
                        
                    }
            }
            .padding(Constants.kbigSpace)
            Text(Strings.kdescription)
                .font(.headline)
                .fontWeight(.bold)
                .foregroundColor(.black)
                .padding(.horizontal,Constants.kbigSpace)
            Text(supermarket.description)
                .font(.subheadline)
                .foregroundColor(.gray)
                .padding(.horizontal,Constants.kbigSpace)
            
            Text(Strings.kcategories)
                .font(.headline)
                .fontWeight(.bold)
                .foregroundColor(.black)
                .padding(.top,Constants.ksmallSpace)
                .padding(.leading,Constants.kbigSpace)
            VStack {
                ForEach(supermarketsScreenViewModel.itemCategories) { itemCategory in
                    
                    ItemCategoryCard(category: itemCategory.name)
                        .onTapGesture {
                            isPresented = true
                            self.itemCategory = itemCategory.name
                        }
                }
            }
            .padding(.horizontal,Constants.kbigSpace)
            Spacer()
        }
        .navigationBarHidden(true)
        .fullScreenCover(isPresented: $isPresented) {
            ItemsScreen().onAppear{
                self.supermarketsScreenViewModel.getAllBySupermarketIdAndCategory(supermarketId: supermarket.id, category: self.itemCategory)
            }
            
        }
    }
        
        func setupAppearance() {
            UIPageControl.appearance().currentPageIndicatorTintColor = UIColor(.accentColor)
            UIPageControl.appearance().pageIndicatorTintColor = UIColor.lightGray
            //        UIPageControl.appearance().backgroundColor = .gray.withAlphaComponent(0.2)
        }
        
    }
    
    struct SupermarketScreen_Previews: PreviewProvider {
        static var previews: some View {
            SupermarketScreen(supermarket: Supermarket(id: "id", name: "Mock Supermarket", images: ["mockImage"], favorites: ["mockImage"],description: "Mock Description",  address: "Mock Address", location: [35,10]))
        }
    }
