//
//  LocationManager.swift
//  Smarkt Go
//
//  Created by Zied Dahmani on 8/4/2023.
//

import Foundation
import CoreLocation

class LocationManager: NSObject, CLLocationManagerDelegate {
    let manager = CLLocationManager()
    var coordinate : CLLocationCoordinate2D?

    override init() {
        super.init()
        manager.delegate = self
        manager.requestWhenInUseAuthorization()
        manager.requestLocation()
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        // This method will be called when the location is updated
        if let location = locations.first {
            // Do something with the user's location
            coordinate = location.coordinate
            print("Latitude: \(location.coordinate.latitude), Longitude: \(location.coordinate.longitude)")
        }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        // Handle any errors here
        print("Failed to get user's location: \(error.localizedDescription)")
    }
}
