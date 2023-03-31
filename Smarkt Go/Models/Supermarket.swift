//
//  Supermarket.swift
//  Smarkt Go
//
//  Created by Zied Dahmani on 17/3/2023.
//

import Foundation

struct Supermarket: Codable , Identifiable {
    let id = UUID()
    let name: String
    let image: String
    let description: String
    
    func getImage() -> String {
        return Constants.kbaseUrl + self.image
    }
    
}
