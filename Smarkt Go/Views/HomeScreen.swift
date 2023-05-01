//
//  HomeScreen.swift
//  Smarkt Go
//
//  Created by Zied Dahmani on 16/3/2023.
//

import SwiftUI
import Kingfisher

struct HomeScreen: View {
    //@State private var searchText: String = ""
    @EnvironmentObject var supermarketsScreenViewModel:SupermarketsScreenViewModel
    @State private var isPresented = false
    @State private var selectedSupermarket: Supermarket?
    
    var body: some View {
        NavigationView{
            
            VStack{
                Text(Strings.kbestSellers)
                    .font(.headline)
                    .fontWeight(.bold)
                    .frame(maxWidth: .infinity, alignment: .leading)
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack { // Use HStack to horizontally layout the items
                        ForEach(supermarketsScreenViewModel.bestSellers) { item in
                            VStack {
                                KFImage(URL(string: item.image))
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: Constants.kbigSpace * 5, height: Constants.kbigSpace * 5)
                                    .background(Color.white)
                                    .cornerRadius(Constants.kcornerRadius)
                                    .shadow(radius: Constants.kshadowRadius)
                                
                                HStack{
                                    Image(systemName: "dollarsign")
                                        .foregroundColor(.black)
                                        .font(.system(size: Constants.kiconSize / 1.5))
                                    Text(String(format: "%.3f", item.price))
                                        .font(.subheadline)
                                        .foregroundColor(.black)
                                }

                            }
                            .padding(.vertical)
                        }
                    }
                    .padding(.horizontal,Constants.ksmallSpace)
                }
                HStack{
                    Text(Strings.knearbySupermarkets)
                        .font(.headline)
                        .fontWeight(.bold)
                    Spacer()
                    Text(Strings.kviewAll)
                        .font(.callout)
                        .foregroundColor(.accentColor)
                        .onTapGesture {
                            isPresented = true
                        }
                }
        
                if let nearbySupermarkets = supermarketsScreenViewModel.nearbySupermarkets {
                    if nearbySupermarkets.isEmpty
                    {
                        VStack(alignment: .center) {
                            Image("empty_cart")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: UIScreen.main.bounds.width - 40, height:UIScreen.main.bounds.height / 4)
                            
                            Text(Strings.knoNearbySupermarkets)
                                .font(.subheadline)
                                .foregroundColor(Color.gray)
                                .padding()
                        }
                    }
                    else {
                        ScrollView(showsIndicators: false) {
                            VStack {
                                ForEach(nearbySupermarkets) { supermarket in
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
                
                Spacer()
            }
            .padding()
            .navigationTitle(Strings.khome)
        }
        .fullScreenCover(isPresented: $isPresented) {
            SupermarketsMapScreen()
        }
        
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
