//
//  LocationManager.swift
//  RoadBuddies
//
//  Created by Reece Nicholls on 04/10/2022.
//

import Foundation
import CoreLocation
import MapKit

// https://www.youtube.com/watch?v=poSmKJ_spts

class LocationManager: NSObject, ObservableObject {
    // request location, monitor changes, status, etc.
    private let manager = CLLocationManager()
    // Users location. Used for If not allowed, present auth view, else dismiss the auth view.
    @Published var userLocation: CLLocation?
    // user current region
    // NOTE: Used to have @Published... however was throwing a warning about publishing changes from within view updates not allowed.
    var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 51.509865, longitude: -0.118092),
        span: MKCoordinateSpan(latitudeDelta: 0.0075, longitudeDelta: 0.0075)
    )
    // access location manager from anywhere in the app.
    static let shared = LocationManager()
    
    override init() {
        super.init()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.startUpdatingLocation()
    }
    
    func requestLocation() {
        manager.requestWhenInUseAuthorization()
    }
}

extension LocationManager: CLLocationManagerDelegate {
    // when permissions are allowed, this will be called.
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
            case .notDetermined:
                print("DEBUG: Not determined")
            case .restricted:
                print("DEBUG: Restricted")
            case .denied:
                print("DEBUG: Denied")
            case .authorizedAlways:
                print("DEBUG: Auth always")
            case .authorizedWhenInUse:
                print("DEBUG: Auth when in use")
            @unknown default:
                break
        }
    }
    
    // When we recieve the users location. Update the userLocation property.
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        
        self.userLocation = location
        self.region = MKCoordinateRegion(
//            center: userLocation!.coordinate,
            center: CLLocationCoordinate2D(latitude: userLocation!.coordinate.latitude+0.0005, longitude: userLocation!.coordinate.longitude),
            span: MKCoordinateSpan(latitudeDelta: 0.0075, longitudeDelta: 0.0075)
        )
    }
}
