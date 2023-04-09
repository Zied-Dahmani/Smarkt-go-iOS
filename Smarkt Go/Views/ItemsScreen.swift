//
//  ItemsScreen.swift
//  Smarkt Go
//
//  Created by Zied Dahmani on 5/4/2023.
//

import SwiftUI

struct ItemsScreen: View {
    @EnvironmentObject var supermarketsScreenViewModel:SupermarketsScreenViewModel
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack{
                ForEach(supermarketsScreenViewModel.items) { item in
                    ItemCard(item: item,fromCartScreen: false,removeItem: {})
                }
            }
            .navigationViewStyle(.stack) // This sets the scroll view at the top
            .padding(.vertical,Constants.ksmallSpace)
        }
    }
}


struct ItemsScreen_Previews: PreviewProvider {
    static var previews: some View {
        ItemsScreen()
    }
}
