//
//  CustomButton.swift
//  Smarkt Go
//
//  Created by Zied Dahmani on 15/3/2023.
//

import SwiftUI

struct CustomButton: View {
    let text: String
    let icon: String
    let textColor : Color
    let iconColor : Color?
    let backgroundColor : Color
    let action: () -> Void

    var body: some View {
        Button(action: {
            self.action()
            
        }) {
            HStack {
                if icon != "google" {
                    Image(systemName: icon)
                        .foregroundColor(iconColor)
                }
                else {
                    Image(icon)
                        .resizable()
                    .aspectRatio(contentMode: .fit)                }
                Text(text)
                    .fontWeight(.semibold)
                    .foregroundColor(textColor)
            }
            .padding()
            .frame(width: UIScreen.main.bounds.width - Constants.kbigSpace * 2  , height: Constants.kbuttonHeight)
            .background(backgroundColor)
            .cornerRadius(Constants.kcornerRadius)
            .shadow(radius: Constants.kshadowRadius)
            
        }
        
    }
}

struct CustomButton_Previews: PreviewProvider {
    static var previews: some View {
        CustomButton(text: Strings.ksignInWithPhone, icon: "phone",textColor: .white, iconColor: .white,backgroundColor: .accentColor, action: {
            print("hello world")
        })
    }
}
