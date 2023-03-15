//
//  SignInScreenViewModel.swift
//  Smarkt Go
//
//  Created by Zied Dahmani on 15/3/2023.
//

import SwiftUI

import Foundation
import Combine

class SignInScreenViewModel: ObservableObject {
    //@Published var user: User = User()
    
    func isValid(_ text: String) -> String {
        if text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        {
            return "Please type your phone number!"
        }
        else if text.count != 8
        {
            return "Please type a valid phone number!"
        }
        else
        {
            return ""
        }
    }
}




