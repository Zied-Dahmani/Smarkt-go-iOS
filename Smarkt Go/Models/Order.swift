//
//  Order.swift
//  Smarkt Go
//
//  Created by Zied Dahmani on 8/4/2023.
//

import Foundation


struct Order : Codable,Identifiable  {
    let id = UUID()
    var group: [String]
    var items: [Item]
    var isDelivered: Bool
}
