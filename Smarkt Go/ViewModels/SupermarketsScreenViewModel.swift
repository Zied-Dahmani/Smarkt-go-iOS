//
//  SupermarketsScreenViewModel.swift
//  Smarkt Go
//
//  Created by Zied Dahmani on 1/4/2023.
//

import Foundation
import SwiftUI
import CoreLocation

class SupermarketsScreenViewModel: NSObject, ObservableObject, CLLocationManagerDelegate {
    @Published var nearbySupermarkets : [Supermarket]?
    @Published var supermarkets : [Supermarket] = []
    @Published var bestSellers : [Item] = []
    @Published var ufavorites : [String]?
    
    @Published var itemCategories = ["Drinks", "Fruits"].enumerated().map { (index, value) in
        return Category(id: index, name: value)
    }
    @Published var items = [Item]()
    
    @Published var locationManager = CLLocationManager()
    @Published var userLoggedIn: String? {
        didSet {
            if let userLoggedIn = userLoggedIn {
                print("User logged in with ID: \(userLoggedIn)")
            }
        }
    }
    
    
    override init() {
        super.init()
//        locationManager.delegate = self
//        locationManager.requestWhenInUseAuthorization()
//        locationManager.startUpdatingLocation()
        //nearbySupermarkets = []
        getAllSupermarkets()
        getBestSellers()
        userLoggedIn = UserDefaults.standard.string(forKey: "userLoggedIn")
        
    }
    func isFavorite(supermarketId:String) {
        guard let url = URL(string: Constants.kbaseUrl+Constants.kFavoriteList) else {
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let data = ["supermarketId":supermarketId]
        
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
                        print("the data is :")
                        
                        print(data)
                        let decoder = JSONDecoder()
                        self.ufavorites = try decoder.decode([String].self, from: data)
                        print(self.ufavorites!)
                    } catch {
                        print("Error decoding JSON: \(error.localizedDescription)")
                    }
                }
            }
        }
        
        task.resume()
    }
    func addToFavorites(supermarketID :  String, userId: String)
    {
        if ufavorites == nil {
            ufavorites = []
        }
        ufavorites?.append(userId)
        addOrRemoveFavorite(supermarketId: supermarketID, favorites: ufavorites!)
        
        
    }
    func removeFromFavorites(supermarketID: String, userId: String) {
        ufavorites?.removeAll(where: { $0 == userId })
        addOrRemoveFavorite(supermarketId: supermarketID, favorites: ufavorites!)
        
    }
    
    func addOrRemoveFavorite(supermarketId: String, favorites: [String]) {
        guard let url = URL(string: Constants.kbaseUrl+Constants.kaddRemove) else {
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let parameters: [String: Any] = [
            "supermarketId": supermarketId,
            "favorites": favorites
        ]
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: [])
        } catch let error {
            print(error.localizedDescription)
            return
        }
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            
            guard let data = data, error == nil else {
                print(error?.localizedDescription ?? "Unknown error")
                return
            }
            
            if let response = try? JSONDecoder().decode(String.self, from: data) {
                DispatchQueue.main.async {
                    let decoder = JSONDecoder()
                    if let favorites = try? decoder.decode([String].self, from: Data(response.utf8)) {
                        self.ufavorites = favorites
                        print("favorites after add or delete")
                        print(self.ufavorites)
                    } else {
                        print("Invalid response")
                    }
                }
                
            }
        }
        .resume()
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            getNearbySupermarkets(coordinate: location.coordinate)
            print("Latitude: \(location.coordinate.latitude), Longitude: \(location.coordinate.longitude)")
        }
    }
    
    
    func getNearbySupermarkets(coordinate: CLLocationCoordinate2D)
    {
        let url = URL(string: Constants.kbaseUrl + "supermarket/")!
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let data = ["currentLocation":[coordinate.latitude,coordinate.longitude]]
        
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
                        self.nearbySupermarkets = try decoder.decode([Supermarket].self, from: data)
                    } catch {
                        print("Error decoding JSON: \(error.localizedDescription)")
                    }
                }
            }
        }
        
        task.resume()
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
                    self.nearbySupermarkets = decodedUsers
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
    
    func launchGoogleMaps(supermarket : Supermarket)
    {
        let latitude = "\(supermarket.location[0])"
        let longitude = "\(supermarket.location[1])"
        
        let urlString = "comgooglemaps-x-callback://?center=\(latitude),\(longitude)&zoom=14&x-success=myapp://?resume=true&x-source=MyApp"
        
        if let url = URL(string: urlString) {
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                print("Google Maps not installed")
            }
        }
    }
    
    
    func getBestSellers()
    {
        guard let url = URL(string: Constants.kbaseUrl+"item/") else {
            return
        }
        URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data else {
                return
            }
            
            do {
                let decodedUsers = try JSONDecoder().decode([Item].self, from: data)
                DispatchQueue.main.async {
                    self.bestSellers = decodedUsers
                }
            } catch {
                print(error.localizedDescription)
            }
        }.resume()
    }
    
    
}



