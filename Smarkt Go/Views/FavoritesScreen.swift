//
//  FavoritesView.swift
//  Smarkt Go
//
//  Created by user235448 on 3/31/23.
//

import SwiftUI

struct FavoritesScreen: View {
    @StateObject var favoritesViewModel = FavoritesViewModel()
    
    var body: some View {
        NavigationView {
            if favoritesViewModel.favorites.isEmpty {
                VStack(alignment: .center) {
                    Image("nofavorites")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: UIScreen.main.bounds.width - 40, height:UIScreen.main.bounds.height / 3)
                    
                    Text(Strings.knoFavorites)
                        .fontWeight(.semibold)
                        .font(.subheadline)
                        .foregroundColor(Color.gray)
                        .padding(.top, Constants.ksmallSpace)
                }
            } else {
                ScrollView (showsIndicators: false){
                    VStack  {
                        ForEach(favoritesViewModel.favorites) { favorite in
                            NavigationLink(destination: SupermarketScreen(supermarket: favorite)
                            )
                            {
                                FavoriteItem(imageName: Constants.kbaseUrl+favorite.images[0], text1: favorite.name, text2: favorite.description)
                                    .padding(.vertical, 10)
                            }
                        }
                    }
                }
                
                
            }
        }
    }
}


struct FavoritesScreen_Previews: PreviewProvider {
    static var previews: some View {
        FavoritesScreen()
    }
}
