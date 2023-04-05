//
//  SupermarketsScreenViewModel.swift
//  Smarkt Go
//
//  Created by Zied Dahmani on 1/4/2023.
//

import Foundation

struct ListItem: Identifiable {
    let id: Int
    let name: String
}

class SupermarketsScreenViewModel: ObservableObject {
    @Published var supermarkets = [Supermarket]()
    @Published var itemCategories = ["Drinks", "Fruits"].enumerated().map { (index, value) in
        return ListItem(id: index, name: value)
    }
    @Published var items = [Item]()
    
    
    init()
    {
        getAllSupermarkets()
    }
    
    func getAllSupermarkets() {
        guard let url = URL(string: Constants.kbaseUrl+"supermarket/") else {
            return
        }
        URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data else {
                return
            }
            
            do {
                let decodedUsers = try JSONDecoder().decode([Supermarket].self, from: data)
                DispatchQueue.main.async {
                    self.supermarkets = decodedUsers
                }
            } catch {
                print(error.localizedDescription)
            }
        }.resume()
    }
    
    
    func getAllBySupermarketIdAndCategory(supermarketId: String, category: String){

        let url = URL(string: Constants.kbaseUrl + "item/")!
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let data = ["supermarketId":supermarketId,"category": category]
        
        let jsonData = try? JSONSerialization.data(withJSONObject: data)
        request.httpBody = jsonData
        let session = URLSession.shared
        
        let task = session.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode)
            else {
                print("Invalid response")
                return
            }
            
            if let data = data {
                DispatchQueue.main.async {
                    do {
                        let decoder = JSONDecoder()
                        self.items = try decoder.decode([Item].self, from: data)
                    } catch {
                        print("Error decoding JSON: \(error.localizedDescription)")
                    }
                }
            }
        }
        
        task.resume()
        
    }
    
}



