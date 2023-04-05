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
    
    
    var body: some View {
        VStack(alignment: .leading){
            ZStack(alignment: .topLeading) {
                KFImage(URL(string: Constants.kbaseUrl+"img/"+supermarket.image))
                           .resizable()
                           .aspectRatio(contentMode: .fill)
                           .frame(width: UIScreen.main.bounds.width - Constants.kbigSpace, height: UIScreen.main.bounds.height / 4)
                
                Image(systemName: "chevron.left")
                    .foregroundColor(.accentColor)
                    .imageScale(.large)
                    .onTapGesture {
                        presentationMode.wrappedValue.dismiss()
                    }
            }
            .padding()
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
                    NavigationLink(destination: ItemsScreen().onAppear{
                        self.supermarketsScreenViewModel.getAllBySupermarketIdAndCategory(supermarketId: supermarket.id, category: itemCategory.name)
                    }) {
                        ItemCategoryCard(category: itemCategory.name)
                    }
                }
            }
            .padding(.horizontal,Constants.kbigSpace)
            Spacer()
        }
        .navigationBarHidden(true)
        
        
    }
}

struct SupermarketScreen_Previews: PreviewProvider {
    static var previews: some View {
        SupermarketScreen(supermarket: Supermarket(id: "id", name: "Mock Supermarket", image: "mockImage", description: "Mock Description", address: "Mock Address"))
    }
}
