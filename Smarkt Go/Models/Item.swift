//
//  Item.swift
//  Smarkt Go
//
//  Created by Zied Dahmani on 5/4/2023.
//

import Foundation

class Item : Codable,Identifiable,Equatable {
    var id: String
    var name: String
    var image: String
    var description: String
    var price: Float
    var category:String
    var supermarketId: String
    var supermarketName: String
    var quantity: Int?
    var sales: Int?

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case name, image, description, price, category, supermarketId, supermarketName, quantity,sales
    }
    
    static func ==(lhs: Item, rhs: Item) -> Bool {
           return lhs.id == rhs.id
    }
}
