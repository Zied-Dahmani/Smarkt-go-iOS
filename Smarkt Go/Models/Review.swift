//
//  Review.swift
//  Smarkt Go
//
//  Created by user235448 on 4/23/23.
//

import Foundation

struct Review : Codable,Identifiable  {
    let id = UUID()
    var title: String
    var description: String
    var username: String
    var rating: Float
  
}
