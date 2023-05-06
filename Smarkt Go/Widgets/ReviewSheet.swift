//
//  ReviewSheet.swift
//  Smarkt Go
//
//  Created by user235448 on 4/23/23.
//

import SwiftUI

struct ReviewSheet: View {
    @State private var starnum: Int = 0
    @State private var title = ""
    @State private var description = ""
    @State private var reviewTitle: String = ""
    @State private var reviewDescription: String = ""
    @State private var showAdd: Bool = false
    @EnvironmentObject var supermarketsScreenViewModel:SupermarketsScreenViewModel
    @State private var showAlert = false

    
    var body: some View {
        
        
        if supermarketsScreenViewModel.reviews.isEmpty {
            VStack(alignment: .center) {
                Image("review")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: UIScreen.main.bounds.width - 40, height:UIScreen.main.bounds.height / 3)
                
                Text(SupermarketScreen.supermarketname+Strings.knoReview)
                    .fontWeight(.semibold)
                    .font(.subheadline)
                    .foregroundColor(Color.gray)
                    .padding(.top, Constants.ksmallSpace)
            
            }
        } else {
            ScrollView (showsIndicators: false){
                ForEach(supermarketsScreenViewModel.reviews) { review in
                    ReviewCell(review: review)
                        .padding(.horizontal)
                }
            }
        }
            CustomButton(text:"Submit your review", icon: "", textColor: .white, iconColor: .white, backgroundColor: .accentColor, action: {
                                
                showAdd.toggle()

            })
            .sheet(isPresented: $showAdd) {
                VStack(alignment: .center, spacing: 16) {
                    Text("Submit your review")
                        .font(.headline)
                    
                    
                    VStack(alignment: .center, spacing: 8) {
                           Text("Title")
                               .font(.headline)
                           TextField("Enter title", text: $title)
                               .textFieldStyle(RoundedBorderTextFieldStyle())
                               .padding(.horizontal,Constants.ksmallSpace)
                       }
                       
                       VStack(alignment: .center, spacing: 8) {
                           Text("Description")
                               .font(.headline)
                               
                           TextField("Enter description", text: $description)
                               .textFieldStyle(RoundedBorderTextFieldStyle())
                               .lineLimit(nil)
                                .textContentType(.none)
                                .multilineTextAlignment(.leading)
                               .padding(.horizontal,Constants.ksmallSpace)

                       }
                    
                    
                    
                    VStack(alignment: .center, spacing: 16) {
                        Text("Rating")
                            .font(.headline)
                        
                        HStack {
                            ForEach(1...5, id: \.self) { index in
                                Image(systemName: index <= starnum ? "star.fill" : "star")
                                    .foregroundColor(.yellow)
                                    .onTapGesture {
                                        starnum = index
                                    }
                            }                               .padding(.horizontal,Constants.ksmallSpace)

                   
                    }
                    CustomButton(text:"Submit", icon: "", textColor: .white, iconColor: .white, backgroundColor: .accentColor, action: {
                        if title.isEmpty || description.isEmpty {
                            showAlert = true
                        } else {
                            supermarketsScreenViewModel.addReview(supermarketid: SupermarketScreen.supermarketid, userid: SupermarketScreen.userid, title: title, description: description,rating: starnum, username: SupermarketScreen.username)
                            supermarketsScreenViewModel.getSupermarketReviews(supermarketId: SupermarketScreen.supermarketid)
                            showAdd.toggle()
                        }
                    }).padding(.top,Constants.kbigSpace)
                    .alert(isPresented: $showAlert) {
                        Alert(title: Text("Error"), message: Text("Title and description cannot be empty"), dismissButton: .default(Text("OK")))
                    }
                        
                    }
                
                }.onAppear{
                    print(supermarketsScreenViewModel.reviews)
                    supermarketsScreenViewModel.getSupermarketReviews(supermarketId: SupermarketScreen.supermarketid)
                }
            
            
            
        }
    }
}
        
        
        


struct ReviewSheet_Previews: PreviewProvider {
    static var previews: some View {
        ReviewSheet()
    }
}
