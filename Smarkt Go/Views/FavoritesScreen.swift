//
//  FavoritesView.swift
//  Smarkt Go
//
//  Created by user235448 on 3/31/23.
//

import SwiftUI

struct FavoritesScreen: View {
    @ObservedObject var favoritesViewModel = FavoritesViewModel()

    var body: some View {
        if favoritesViewModel.favorites.isEmpty {
            VStack(alignment: .center) {
                Image("nofavorites")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .padding(.top, Constants.khugeSpace)
                
                Text(Strings.knoFavorites)
                    .fontWeight(.semibold)
                    .font(.title)
                    .foregroundColor(.black)
                    .padding(.top, Constants.ksmallSpace)
            }
        }
        /*else {
            ScrollView {
                LazyVStack {
                    ForEach(favoritesViewModel.favorites) { favorite in
                        FavoriteItem(imageName: favorite.getImage(), text1: favorite.name, text2: favorite.description)
                            .padding(.vertical, 10)
                    }
                }
            }
        }*/
    }
}


struct FavoritesScreen_Previews: PreviewProvider {
    static var previews: some View {
        FavoritesScreen()
    }
}
