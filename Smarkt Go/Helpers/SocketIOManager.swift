//
//  SocketIOManager.swift
//  Smarkt Go
//
//  Created by user235448 on 5/17/23.
//

import Foundation
import SocketIO

class SocketIOManager {
    let socket: SocketIOClient
    let manager: SocketManager

    init() {
        manager = SocketManager(socketURL: URL(string: Constants.kbaseUrl)!, config: [.log(true), .compress])
        socket = manager.defaultSocket
    }

    func start(onConnect: @escaping () -> Void, onReady: @escaping () -> Void) {
        socket.on("connect") { _, _ in
            print("Socket.IO connected")
            onConnect()
            onReady()
        }
        
        socket.connect()
    }
                        
           
       
    func config(id:String) {
        socket.emit("storeClientInfo",id)
            print("+++Socket.IO connected2")
        }
    
}
