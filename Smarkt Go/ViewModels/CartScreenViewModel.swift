//
//  CartScreenViewModel.swift
//  Smarkt Go
//
//  Created by Zied Dahmani on 8/4/2023.
//

import SwiftUI

class CartScreenViewModel: ObservableObject {
    @Published var order:Order?
    @Published var statusCode = 0
    
    func getOrder(token:String) {
        
        guard let url = URL(string: Constants.kbaseUrl+"order/get") else {
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue(token, forHTTPHeaderField: "jwt")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                return
            }
            
            
            do {
                let decodedOrder = try JSONDecoder().decode(Order.self, from: data)
                DispatchQueue.main.async {
                    self.order = decodedOrder
                }
            } catch {
                DispatchQueue.main.async {
                        self.statusCode = 400
                }
                print(error.localizedDescription)
            }
        }.resume()
    }
    
    func getTotal() -> Float {
        var sum: Float = 0.0
        if let order = order {
            for item in order.items {
                sum += item.price
            }
        }
        return sum
    }
    
    func removeItem(item: Item,token:String) {
        if order?.items.count == 1
        {
            deleteOrder(token: token)
        }
        else{
            let url = URL(string: Constants.kbaseUrl + "order/removeItem")!
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.setValue(token, forHTTPHeaderField: "jwt")
            
            var data: [String: Any] = [:]
            for (index, element) in order!.items.enumerated() {
                if element == item {
                    data =  ["itemIndex": index]
                    
                }
            }
            let jsonData = try? JSONSerialization.data(withJSONObject: data)
            request.httpBody = jsonData
            let session = URLSession.shared
            
            let task = session.dataTask(with: request) { data, response, error in
                if let error = error {
                    print("Error: \(error.localizedDescription)")
                    return
                }
                
                guard let httpResponse = response as? HTTPURLResponse,
                      [200].contains(httpResponse.statusCode)
                else {
                    print("Invalid response")
                    return
                }
                
                DispatchQueue.main.async {
                    self.order?.items.removeAll(where: { $0.id == item.id })
                }
                
                
            }
            
            task.resume()
        }
        
    }
    
    
    func deleteOrder(token: String)
    {
        let url = URL(string: Constants.kbaseUrl + "order/delete")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(token, forHTTPHeaderField: "jwt")
        
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse,
                  [200].contains(httpResponse.statusCode)
            else {
                print("Invalid response")
                return
            }
            
            DispatchQueue.main.async {
                self.order = nil
                self.statusCode = 400
            }
            
        }
        
        task.resume()
    }
    
    func addToCart(token:String, supermarketId:String, item:Item, completion: @escaping (Int?) -> Void) {
        let url = URL(string: Constants.kbaseUrl + "order/addToCart")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        // Add the token to the header
        request.setValue(token, forHTTPHeaderField: "jwt")
        
        let jsonEncoder = JSONEncoder()
        let jsData = try? jsonEncoder.encode(item)
        let itemJson = try? JSONSerialization.jsonObject(with: jsData!, options: []) as? [String: Any]
        let data = ["supermarketId": supermarketId, "item": itemJson!] as [String: Any]
        
        let jsonData = try? JSONSerialization.data(withJSONObject: data)
        request.httpBody = jsonData
        let session = URLSession.shared
        
        let task = session.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
                completion(nil)
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse,
                  [200, 201, 400].contains(httpResponse.statusCode)
            else {
                print("Invalid response")
                completion(nil)
                return
            }
            
            completion(httpResponse.statusCode)
        }
        
        task.resume()
    }
    
    func pay(token: String, total: Float, completion: @escaping (Bool) -> Void) {
        let url = URL(string: Constants.kbaseUrl + "user/updateWallet")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(token, forHTTPHeaderField: "jwt")
            
        var data = ["total":total]
        let jsonData = try? JSONSerialization.data(withJSONObject: data)
        request.httpBody = jsonData
        let session = URLSession.shared
            
        let task = session.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
                completion(false)
                return
            }
                
            guard let httpResponse = response as? HTTPURLResponse,
                [200].contains(httpResponse.statusCode)
            else {
                print("Invalid response")
                completion(false)
                return
            }
                
            DispatchQueue.main.async {
                
                self.deleteOrder(token: token)
                completion(true)
            }
        }
        task.resume()
    }

    
}


