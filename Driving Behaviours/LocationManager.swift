//
//  LocationManager.swift
//  Driving Behaviours
//
//  Created by Reece Nicholls on 04/10/2022.
//

import Foundation
import CoreLocation

// https://www.youtube.com/watch?v=poSmKJ_spts

class LocationManager: NSObject, ObservableObject {
    // request location, monitor changes, status, etc.
    private let manager = CLLocationManager()
    // Users location. Used for If not allowed, present auth view, else dismiss the auth view.
    @Published var userLocation: CLLocation?
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
    }
}
