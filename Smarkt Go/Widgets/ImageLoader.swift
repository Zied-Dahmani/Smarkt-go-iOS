//
//  ImageLoader.swift
//  Smarkt Go
//
//  Created by Zied Dahmani on 2/4/2023.
//

import Foundation
import Combine
import UIKit

class ImageLoader: ObservableObject {
    @Published var image: UIImage?
    
    func loadImage(with url: URL) {
        let cache = URLCache.shared
        let request = URLRequest(url: url)
        
        // Check the cache first
        if let cachedResponse = cache.cachedResponse(for: request),
           let cachedImage = UIImage(data: cachedResponse.data) {
            image = cachedImage
            return
        }
        
        // Download the image if not in the cache
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil,
                  let httpResponse = response as? HTTPURLResponse,
                  httpResponse.statusCode == 200,
                  let loadedImage = UIImage(data: data) else {
                return
            }
            
            // Cache the image
            let cachedResponse = CachedURLResponse(response: httpResponse, data: data)
            cache.storeCachedResponse(cachedResponse, for: request)
            
            DispatchQueue.main.async {
                self.image = loadedImage
            }
        }.resume()
    }
}

