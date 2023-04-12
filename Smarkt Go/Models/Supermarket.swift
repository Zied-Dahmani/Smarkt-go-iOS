//  Supermarket.swift
//  Smarkt Go
//
//  Created by Zied Dahmani on 17/3/2023.
//

import Foundation

struct Supermarket: Codable, Identifiable {
    var id: String
    let name: String
    let images: [String]
    let favorites: [String]?
    let description: String
    let address: String
    let location: [Double]
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case name, images, favorites, description, address, location
    }
 
       
}
