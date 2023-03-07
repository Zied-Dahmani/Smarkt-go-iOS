//
//  MainScreen.swift
//  Smarkt Go
//
//  Created by Zied Dahmani on 14/1/2023.
//

import SwiftUI

struct MainScreen: View {
    var body: some View {
        
        TabView {
            
            Text("")
                .tabItem {
                    Image(systemName: "house.fill")
                    Text("Home")
                }
            
            Text("")
                .tabItem {
                    Image(systemName: "basket.fill")
                    Text("Cart")
                }
            
            Text("")
                .tabItem {
                    Image(systemName: "message.fill")
                    Text("Chat")
                }
            
            Text("")
                .tabItem {
                    Image(systemName: "heart.fill")
                    Text("Favourites")
                }
            
            ProfileScreen()
                .tabItem {
                    Image(systemName: "person.fill")
                    Text("Profile")
                }
            
        }
    }
}

struct MainScreen_Previews: PreviewProvider {
    static var previews: some View {
        MainScreen()
    }
}
