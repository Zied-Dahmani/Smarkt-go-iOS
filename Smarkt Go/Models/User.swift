//
//  User.swift
//  Smarkt Go
//
//  Created by Zied Dahmani on 17/3/2023.
//

import Foundation

struct User : Codable {
    var token: String
    var id: String
    var fullName: String
    var image: String
    var wallet: Float
    
    
    func getImage() -> String {
        return id.contains("+") ? Constants.kbaseUrl+self.image : self.image
    }
    
    func isSignedWithPhone() -> Bool {
        return id.contains("+")
    }
}
