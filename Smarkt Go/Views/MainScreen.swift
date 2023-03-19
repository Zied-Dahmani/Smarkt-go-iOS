import SwiftUI

struct MainScreen: View {
    
    
    var body: some View {
        TabView {
            HomeScreen()
                .tabItem {
                    Image(systemName: "house.fill")
                    Text(Strings.khome)
                }
            
            Text("")
                .tabItem {
                    Image(systemName: "basket.fill")
                    Text(Strings.kcart)
                }
            
            Text("")
                .tabItem {
                    Image(systemName: "message.fill")
                    Text(Strings.kchat)
                }
            
            Text("")
                .tabItem {
                    Image(systemName: "heart.fill")
                    Text(Strings.kfavourites)
                }
            
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


