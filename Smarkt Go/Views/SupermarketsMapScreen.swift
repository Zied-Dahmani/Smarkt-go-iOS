//
//  SupermarketsMapScreen.swift
//  Smarkt Go
//
//  Created by Zied Dahmani on 9/4/2023.
//

import SwiftUI
import MapKit

struct SupermarketsMapScreen: View {
    
    @State var selectedSupermarket: Supermarket?
    @State private var navigateToSecondView = false
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            ZStack(alignment: .bottom){
                MapView(function: { supermarket in
                    selectedSupermarket = supermarket
                })
                .edgesIgnoringSafeArea(.all)
                if selectedSupermarket != nil {
                    SupermarketCard(image: (selectedSupermarket?.images[0])!, title: selectedSupermarket!.name, subtitle: selectedSupermarket!.address)
                        .padding()
                        .onTapGesture {
                            navigateToSecondView = true
                        }
                }
            }
            .fullScreenCover(isPresented: $navigateToSecondView) {
                SupermarketScreen(supermarket: selectedSupermarket!)
            }
            .navigationBarBackButtonHidden(true)
            .navigationBarItems(leading: Button(action: {
                presentationMode.wrappedValue.dismiss()
            }) {
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
            })
        }
    }
}



struct SupermarketsMapScreen_Previews: PreviewProvider {
    static var previews: some View {
        SupermarketsMapScreen()
    }
}
