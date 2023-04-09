//
//  HomeScreen.swift
//  Smarkt Go
//
//  Created by Zied Dahmani on 16/3/2023.
//

import SwiftUI

struct HomeScreen: View {
    //@State private var searchText: String = ""
    @EnvironmentObject var supermarketsScreenViewModel:SupermarketsScreenViewModel
    @State private var isPresented = false
    @State private var selectedSupermarket: Supermarket?
    
    var body: some View {
        NavigationView{
            
            VStack{
                Color.white.opacity(0) // placeholder view
                Spacer()
                HStack{
                    Text(Strings.knearbySupermarkets)
                        .font(.headline)
                        .fontWeight(.bold)
                    Spacer()
                    Text(Strings.kviewAll)
                        .font(.callout)
                        .foregroundColor(.accentColor)
                        .onTapGesture {
                            
                        }
                }.padding()
                if let supermarkets = supermarketsScreenViewModel.supermarkets {
                    if supermarkets.isEmpty
                    {
                        VStack(alignment: .center) {
                            Image("empty_cart")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: UIScreen.main.bounds.width - 80, height:UIScreen.main.bounds.height / 6)
                            
                            Text(Strings.knoFavorites)
                                .font(.subheadline)
                                .foregroundColor(Color.gray)
                        }
                    }
                    else {
                        ScrollView(showsIndicators: false) {
                            VStack {
                                ForEach(supermarkets) { supermarket in
                                    NavigationLink(destination: SupermarketScreen(supermarket: supermarket)
                                    ) {
                                        SupermarketCard(image: supermarket.images[0], title: supermarket.name, subtitle: supermarket.address)
                                    }
                                }
                            }
                            .padding(.vertical,Constants.ksmallSpace)
                        }
                        
                    }
                }
                
            }
            .navigationTitle(Strings.khome)
        }
        //        .fullScreenCover(isPresented: $isPresented) {
        //            if let selectedSupermarket = selectedSupermarket {
        //                SupermarketScreen(supermarket: selectedSupermarket)
        //            }
        //
        //        }
        
    }
}


extension UIApplication {
    func dismissKeyboard() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

struct HomeScreen_Previews: PreviewProvider {
    static var previews: some View {
        HomeScreen()
    }
}
