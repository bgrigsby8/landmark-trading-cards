//
//  LocationDataManager.swift
//  landmark-trading-cards
//
//  Created by Brad Grigsby on 7/29/24.
//

import Foundation
import CoreLocation

class LocationDataManager : NSObject, CLLocationManagerDelegate, ObservableObject {
    @Published var locationManager = CLLocationManager()
    @Published var authorizationStatus: CLAuthorizationStatus?
    @Published var alertMessage: String?
    @Published var showingAlert = false
    
    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
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
    
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        if let circularRegion  = region as? CLCircularRegion {
            print("Entered region: \(circularRegion.identifier)")
            showingAlert = true
            // Handle region entry
        }
    }
    
    func startMonitoringRegions(for landmarks: [Landmark]) {
        for landmark in landmarks {
            let region = CLCircularRegion(center: CLLocationCoordinate2D(latitude: landmark.latitude, longitude: landmark.longitude), radius: 50, identifier: landmark.name)
            region.notifyOnEntry = true
        }
    }

}
