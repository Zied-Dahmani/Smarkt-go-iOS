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
    let images: [String]
    let description: String
    let address: String
    let location: [Float]
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case name, images, description, address, location
    }
    
//    func getImage() -> String {
//        return Constants.kbaseUrl + self.image
//    }
    
}
