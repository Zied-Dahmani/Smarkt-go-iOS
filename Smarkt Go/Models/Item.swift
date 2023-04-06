//
//  Item.swift
//  Smarkt Go
//
//  Created by Zied Dahmani on 5/4/2023.
//

import Foundation

struct Item : Codable,Identifiable {
    var id: String
    var name: String
    var image: String
    var description: String
    var price: Float
    var category:String
    var supermarketId: String
    var supermarketName: String
    var quantity: Int?

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case name, image, description, price, category, supermarketId, supermarketName, quantity
    }
}
