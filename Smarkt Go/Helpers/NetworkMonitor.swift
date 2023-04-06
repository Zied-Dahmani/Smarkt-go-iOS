//
//  NetworkMonitor.swift
//  Smarkt Go
//
//  Created by Zied Dahmani on 19/3/2023.
//

import Foundation
import Network

final class NetworkMonitor: ObservableObject {
    
    let monitor = NWPathMonitor()
    let queue = DispatchQueue(label: "Monitor")
    
    @Published var isConnected = ""
    
    init()
    {
        monitor.pathUpdateHandler = { [weak self] path in
            DispatchQueue.main.async {
                self?.isConnected = path.status == .satisfied ? "true" : "false"
            }
        }
        monitor.start(queue: queue)
    }
}
