import SwiftUI

struct MainScreen: View {
    @StateObject var viewModel = SupermarketsScreenViewModel()
    
    
    var body: some View {
        TabView {
            HomeScreen()
                .tabItem {
                    Image(systemName: "house.fill")
                    Text(Strings.khome)
                }
                .environmentObject(viewModel)
            
            
            CartScreen()
                .tabItem {
                    Image(systemName: "basket.fill")
                    Text(Strings.kcart)
                }
                .environmentObject(viewModel)
            
            Text("")
                .tabItem {
                    Image(systemName: "message.fill")
                    Text(Strings.kchat)
                }
            
            FavoritesScreen()
                .tabItem {
                    Image(systemName: "heart.fill")
                    Text(Strings.kfavourites)
                }
                .environmentObject(viewModel)
            ProfileScreen()
                .tabItem {
                    Image(systemName: "person.fill")
                    Text(Strings.kprofile)
                }
        }
        
    }
}

struct MainScreen_Previews: PreviewProvider {
    static var previews: some View {
        MainScreen()
    }
}


