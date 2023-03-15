//
//  CustomTextField.swift
//  Smarkt Go
//
//  Created by Zied Dahmani on 15/3/2023.
//

import SwiftUI

struct CustomTextField: View {
    let text: String
    let keyboardType: UIKeyboardType
    @Binding var textValue: String
    
    var body: some View {
        TextField(text, text: $textValue)
            .keyboardType(keyboardType)
            .padding(.horizontal,Constants.kbigSpace)
            .padding(.vertical,Constants.ksmallSpace)
            .frame(width: UIScreen.main.bounds.width - Constants.kbigSpace * 2  , height: Constants.kbuttonHeight)
            .overlay(
                RoundedRectangle(cornerRadius: Constants.kcornerRadius)
                    .strokeBorder(Color.accentColor, lineWidth: Constants.kdividerHeight)
            )
        
        
    }
    
    
    
}

struct CustomTextField_Previews: PreviewProvider {
    
    static var previews: some View {
        CustomTextField(text: Strings.kphoneNumber, keyboardType: .numberPad,textValue: .constant(""))
    }
}
