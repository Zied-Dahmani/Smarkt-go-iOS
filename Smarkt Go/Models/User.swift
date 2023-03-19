//
//  User.swift
//  Smarkt Go
//
//  Created by Zied Dahmani on 17/3/2023.
//

import Foundation

struct User : Codable {
    var token: String
    var provider: String
    var id: String
    var fullName: String
    var image: String
    var wallet: Float
    
    
    func getImage() -> String {
        return provider == "google" ?  self.image: Constants.kbaseUrl+self.image
    }
    
    func isSignedInWithGoogle() -> Bool {
        return provider == "google"
    }
}
