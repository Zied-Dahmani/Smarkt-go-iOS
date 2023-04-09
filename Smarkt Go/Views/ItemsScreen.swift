//
//  ItemsScreen.swift
//  Smarkt Go
//
//  Created by Zied Dahmani on 5/4/2023.
//

import SwiftUI

struct ItemsScreen: View {
    @EnvironmentObject var supermarketsScreenViewModel:SupermarketsScreenViewModel
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        VStack(alignment: .leading) {
            Image(systemName: "chevron.left")
                .foregroundColor(.accentColor)
                .imageScale(.large)
                .padding()
                .onTapGesture {
                    presentationMode.wrappedValue.dismiss()
                }
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
}


struct ItemsScreen_Previews: PreviewProvider {
    static var previews: some View {
        ItemsScreen()
    }
}
