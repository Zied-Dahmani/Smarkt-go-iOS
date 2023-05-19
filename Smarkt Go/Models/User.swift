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
    var _id: String
    
    
    func getImage() -> String {
        return provider == "google" ?  self.image: Constants.kbaseUrl+self.image
    }
    
    func isSignedInWithGoogle() -> Bool {
        return provider == "google"
    }
}
struct UserInfo : Codable,Identifiable {
    var id: String
    var provider: String?
    var fullName: String
    var image: String
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case provider, fullName, image
    }
 
   func getImage() -> String {
        return provider == "google" ?  self.image: Constants.kbaseUrl+self.image
    }
    
    func isSignedInWithGoogle() -> Bool {
        return provider == "google"
    }
}
struct ChatInfo : Codable,Identifiable ,Equatable{
    var id: String
    var provider: String?
    var fullName: String
    var image: String
    var content: String
    var createdAt: String
    var formattedCreatedAt: String {
           let dateFormatter = DateFormatter()
           dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
           if let date = dateFormatter.date(from: createdAt) {
               dateFormatter.dateFormat = "MMM dd, yyyy HH:mm:ss"
               return dateFormatter.string(from: date)
           } else {
               return createdAt
           }
       }
   
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case provider, fullName, image,content,createdAt
    }
 
   func getImage() -> String {
        return provider == "google" ?  self.image: Constants.kbaseUrl+self.image
    }
    
    func isSignedInWithGoogle() -> Bool {
        return provider == "google"
    }
}
