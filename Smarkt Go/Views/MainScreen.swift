import SwiftUI

struct MainScreen: View {
    @State private var searchText: String = ""
    
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
        .overlay(
            VStack(spacing: 0) {
                Spacer()
                    .padding(.top,130)
                Text("Discover")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.top, 40)
                
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.gray)
                    
                    TextField("Search", text: $searchText)
                        .foregroundColor(.black)
                    
                    if !searchText.isEmpty {
                        Button(action: {
                            searchText = ""
                            UIApplication.shared.dismissKeyboard()
                        }, label: {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundColor(.gray)
                                .padding()
                        })
                        .transition(.move(edge: .trailing))
                        .animation(.default)
                    }
                }
                .frame(width: 350,height:40)
                .background(Color(.systemGray6))
                .cornerRadius(10)
                .padding(.top, 10)
                .padding(.horizontal,10)
                
                HStack{
                    Text("Categories")
                        .font(.headline)
                        .fontWeight(.bold)
                        .padding(.top, 15)
                    Spacer()
                }
                Spacer()
                    .padding(.top,10)
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 10) {
                     
                        ForEach(0..<4) { index in
                            VStack {
                                Image("\(index)")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 160, height: 80)
                                    .clipShape(Circle())
                                
                                Text(["Drinks", "Meat", "Vegetables", "Fruits"][index])
                                    .font(.caption)
                                    .foregroundColor(.black)
                                    .multilineTextAlignment(.center)
                                    .lineLimit(2)
                                    .padding(.horizontal, 5)
                            }
                            .frame(width: 80,height: 110)
                            .background(Color(.systemGray6))
                            .cornerRadius(10)
                        }
                    }
                    .padding(.horizontal, 10)
                }
                
                HStack{
                    Text("Browse our supermarkets:")
                        .font(.headline)
                        .fontWeight(.bold)
                    Spacer()
                    Button {
                        // To the map
                    } label: {
                        Text("View All")
                            .underline()
                    }.padding(.trailing)
                }.padding(.top,15)
                
            }.padding(.leading,10)
            
            
            
            
            
           
            .frame(height: 100)
            , alignment: .top
        )
    }
}
extension UIApplication {
    func dismissKeyboard() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
struct MainScreen_Previews: PreviewProvider {
    static var previews: some View {
        MainScreen()
    }
}


