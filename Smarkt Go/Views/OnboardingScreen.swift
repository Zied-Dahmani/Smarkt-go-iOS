//
//  OnboardingScreen.swift
//  Smarkt Go
//
//  Created by Zied Dahmani on 15/3/2023.
//

import SwiftUI

struct OnboardingScreen: View {
    
    @State var currentPage = 1
    @State private var navigateToSecondView = false
    
    var body: some View {
        ZStack{
            
            if currentPage == 1
            {
                OnboardingSlide(image: "empty_cart", title: Strings.onboardingTitles[0], subTitle:Strings.onboardingSubtitles[0] , skipAction: { navigateToSecondView = true}, backAction: {currentPage -= 1 }, index: 1 )
                    .transition(.scale)
            }
            else if currentPage == 2
            {
                OnboardingSlide(image: "online_groceries", title: Strings.onboardingTitles[1] , subTitle: Strings.onboardingSubtitles[1],skipAction: { navigateToSecondView = true}, backAction: {currentPage -= 1 }, index: 2 )     .transition(.scale)
                
            }
            else if currentPage >= 3{
                OnboardingSlide(image: "shopping_app", title: Strings.onboardingTitles[2], subTitle:Strings.onboardingSubtitles[2] ,skipAction: { navigateToSecondView = true }, backAction: {currentPage -= 1 }, index: 3 )
                    .transition(.scale)
            }
            
            
            
            
        }.overlay(
            
            Button(action: {
                withAnimation(.easeInOut){
                    if currentPage <= 3 {
                        currentPage += 1
                    }
                    if currentPage == 4
                    {
                        navigateToSecondView = true
                    }
                }
            }, label: {
                Image(systemName: "chevron.right")
                    .font(.system(size:Constants.kiconSize,weight: .semibold))
                    .foregroundColor(.white)
                    .frame(width: Constants.kiconSize * 3, height: Constants.kiconSize * 3)
                    .background(Color.accentColor)
                    .clipShape(Circle())
                    .overlay(ZStack{
                        Circle()
                            .stroke(Color.black.opacity(0.04),lineWidth: Constants.kdividerHeight * 2)
                        
                        Circle()
                            .trim(from: 0, to: CGFloat(currentPage) / CGFloat(3) )
                            .stroke(Color.accentColor,lineWidth: Constants.kdividerHeight * 2)
                            .rotationEffect(.init(degrees: -90 ))
                    }.padding(-Constants.ksmallSpace))
                
            })
            .padding(.bottom,Constants.khugeSpace * 2)
            .fullScreenCover(isPresented: $navigateToSecondView) {
                SignInScreen(signInScreenViewModel: SignInScreenViewModel()
                )
            }
            
            ,alignment: .bottom
        )
    }
}

struct OnboardingScreen_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingScreen()
    }
}
