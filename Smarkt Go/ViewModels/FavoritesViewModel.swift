//
//  FavoritesViewModel.swift
//  Smarkt Go
//
//  Created by user235448 on 3/31/23.
//
import SwiftUI

class FavoritesViewModel: ObservableObject {
    @Published var favorites = [Supermarket]()
    @Published var userLoggedIn: String? {
        didSet {
            if let userLoggedIn = userLoggedIn {
                getFavorites(id: userLoggedIn) { [weak self] supermarkets in
                    guard let self = self else { return }
                    DispatchQueue.main.async {
                        self.favorites = supermarkets
                    }
                }
            }
        }
    }

    init() {
        userLoggedIn = UserDefaults.standard.string(forKey: "userLoggedIn")
    }

    func getFavorites(id: String, completion: @escaping ([Supermarket]) -> Void) {
        let url = URL(string: Constants.kbaseUrl + Constants.kfavorites)!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        let parameters: [String: Any] = [
            "id": id
        ]

        request.httpBody = try? JSONSerialization.data(withJSONObject: parameters)

        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else { return }

            do {
                let supermarkets = try JSONDecoder().decode([Supermarket].self, from: data)
                DispatchQueue.main.async {
                    completion(supermarkets)
                }
            } catch {
                print("Error decoding JSON: \(error.localizedDescription)")
            }
        }.resume()
    }
}



