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
                ScrollView(showsIndicators: false) {
                    VStack {
                        ForEach(supermarketsScreenViewModel.supermarkets) { supermarket in
                            NavigationLink(destination: SupermarketScreen(supermarket: supermarket)
                            ) {
                                SupermarketCard(image: supermarket.image, title: supermarket.name, subtitle: supermarket.address)
                            }
                        }
                    }
                    .padding(.vertical,Constants.ksmallSpace)
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
