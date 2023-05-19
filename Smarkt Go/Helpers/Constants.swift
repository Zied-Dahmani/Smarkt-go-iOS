//
//  Constants.swift
//  Smarkt Go
//
//  Created by Zied Dahmani on 15/3/2023.
//

import Foundation


struct Constants {
    static let kcornerRadius = 10.0
    static let kbuttonHeight = 46.0
    static let kshadowRadius = 5.0
    static let kdividerHeight = 2.0
    
    //SPACE
    static let khugeSpace = 30.0
    static let kbigSpace = 20.0
    static let ksmallSpace = 10.0
    
    
    static let kiconSize = 20.0
    
    
   // static let kbaseUrl = "https://smarkt-go-584j.onrender.com/"
    static let kbaseUrl = "https://feb0-102-157-41-255.eu.ngrok.io/"
//    static let kbaseUrl = "http://localhost:9090/"
    static let kfavorites = "supermarket/getFavorites"
    static let ksignUp = "user/signUp"
    static let ksignIn = "user/signIn"
    static let ksignOut = "user/signOut"
    static let kupdate = "user/update"
    static let kAllUsers = "user/getAllUsers"
    static let knonMembers = "order/getNonMembers"
    static let kgetChat = "order/chat"
    static let ksendChat = "order/send"
    static let kaddUser = "order/addUser"
    static let kdeleteMyAccount = "user/deleteMyAccount"
    static let kupdatePic = "user/updatePic"
    static let kredeemCode = "ticket/redeem"
    static let kFavoriteList = "supermarket/isFavorite"
    static let kaddRemove = "supermarket/addremovefavorite"
    static let kReviews = "review/"
    static let kaddReview = "review/create"
    
    
    
}
