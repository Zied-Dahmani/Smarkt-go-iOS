//
//  Supermarket.swift
//  Smarkt Go
//
//  Created by Zied Dahmani on 17/3/2023.
//

import Foundation	

struct Supermarket: Codable,Identifiable {
    var id: String
    let name: String
    let image: String
    let description: String
    let address: String
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case name, image, description, address
    }
    
    func getImage() -> String {
        return Constants.kbaseUrl + self.image
    }
    
}
