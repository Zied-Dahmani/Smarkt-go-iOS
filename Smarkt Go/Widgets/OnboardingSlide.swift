//
//  OnboardingSlide.swift
//  Smarkt Go
//
//  Created by Zied Dahmani on 15/3/2023.
//

import SwiftUI

struct OnboardingSlide: View {
    
    let image:String
    let title:String
    let subTitle:String
    let skipAction: () -> Void
    let backAction: () -> Void
    let index : Int
    
    var body: some View {
        VStack(spacing: Constants.kbigSpace)
        {
            HStack{
                if index == 1 {
                    Text(Strings.kwelcome)
                        .font(.title)
                        .fontWeight(.semibold)
                }
                else {
                    Button(action: {
                        withAnimation(.easeInOut)
                        {
                            self.backAction()
                        }
                    }, label: {
                        Image(systemName: "chevron.left")
                    })
                }
                Spacer()
                
                Button(action: {
                    self.skipAction()
                }, label: {
                    Text(Strings.kskip)
                        .fontWeight(.semibold)
                })
                
            }.padding(.bottom,Constants.khugeSpace * 2)
            
            
            Image(image)
                .resizable()
                .aspectRatio(contentMode: .fit)
            
            
            Text(title)
                .font(.title2)
                .fontWeight(.bold)
                .padding(.top)
            
            
            Text(subTitle)
                .font(.footnote)
                .fontWeight(.semibold)
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
            
            Spacer(minLength: 0)
            
        }.padding(.horizontal,Constants.kbigSpace)
        
    }
}

struct OnboardingSlide_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingSlide(image: "empty_cart", title: "Empty cart", subTitle: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.", skipAction: { },backAction: {}, index: 2)
    }
}
