//
//  MapView.swift
//  Smarkt Go
//
//  Created by Zied Dahmani on 9/4/2023.
//

import SwiftUI
import MapKit

struct MapView: UIViewRepresentable {
    @EnvironmentObject var supermarketsScreenViewModel:SupermarketsScreenViewModel
    
    @State var coordinate = CLLocationCoordinate2D(latitude: 36.86727744351486, longitude: 10.164694955038323)
    @State var annotations = [MKPointAnnotation]()
    let function: (Supermarket) -> Void

    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.delegate = context.coordinator
        let span = MKCoordinateSpan(latitudeDelta: 0.06, longitudeDelta: 1.06)
        let region = MKCoordinateRegion(center: coordinate, span: span)
        mapView.setRegion(region, animated: true)
        
        for supermarket in supermarketsScreenViewModel.supermarkets {
            let annotation = MKPointAnnotation()
            annotation.coordinate = CLLocationCoordinate2D(latitude: supermarket.location[0], longitude:supermarket.location[1])
            annotation.title = supermarket.name
            mapView.addAnnotation(annotation)
        }
        
        return mapView
    }
    
    func updateUIView(_ view: MKMapView, context: Context) {
        if let myLocation = supermarketsScreenViewModel.locationManager.location?.coordinate {
            DispatchQueue.main.async {
                self.coordinate = CLLocationCoordinate2D(latitude: myLocation.latitude, longitude: myLocation.longitude)
            }
        }
        let span = MKCoordinateSpan(latitudeDelta: 0.04, longitudeDelta: 0.04)
        let region = MKCoordinateRegion(center: coordinate, span: span)
        view.setRegion(region, animated: true)
        let pin = MKPointAnnotation()
        pin.coordinate = coordinate
        pin.title = "Me"
        view.addAnnotation(pin)
    }
    
    class Coordinator: NSObject, MKMapViewDelegate {
            var parent: MapView
            
            init(_ parent: MapView) {
                self.parent = parent
            }
            
            func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
                if let annotationTitle = view.annotation?.title {
                    parent.setSupermarket(supermarketName: annotationTitle!)
                  }
            }
        }
        
        func makeCoordinator() -> Coordinator {
            Coordinator(self)
        }
    
    
    func setSupermarket(supermarketName: String) {
        if let supermarket = supermarketsScreenViewModel.supermarkets.first(where: { $0.name == supermarketName }) {
            function(supermarket)
        }
    }
    
}

