//
//  LocationDataManager.swift
//  landmark-trading-cards
//
//  Created by Brad Grigsby on 7/29/24.
//

import Foundation
import CoreLocation

class LocationDataManager : NSObject, CLLocationManagerDelegate, ObservableObject {
    var locationManager = CLLocationManager()
    @Published var authorizationStatus: CLAuthorizationStatus?
    
    override init() {
        super.init()
        locationManager.delegate = self
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .notDetermined: // Authorization not determined yet
            authorizationStatus = .notDetermined
            manager.requestWhenInUseAuthorization()
            break
        case .restricted, .denied: // Location services not available
            // Insert code here of what should happen when location services are not available
            authorizationStatus = .restricted
            break
        case .authorized, .authorizedWhenInUse, .authorizedAlways: // Location services are available
            // Insert code here of what should happen when location services are available
            authorizationStatus = .authorizedWhenInUse
            manager.requestLocation()
            break
        default:
            break
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        // Insert code to handle location updates
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("error: \(error.localizedDescription)")
    }

}
