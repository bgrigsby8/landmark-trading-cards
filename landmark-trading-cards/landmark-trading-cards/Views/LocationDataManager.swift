//
//  LocationDataManager.swift
//  landmark-trading-cards
//
//  Created by Brad Grigsby on 7/29/24.
//

import Foundation
import CoreLocation
import SwiftUI
import UIKit

class LocationDataManager: NSObject, CLLocationManagerDelegate, ObservableObject {
    @Published var locationManager = CLLocationManager()
    @Published var authorizationStatus: CLAuthorizationStatus?
    @Published var alertMessage: String?
    @Published var showingAlert = false
    @Published var isInGeographicalZone = false
    @Published var landmarks: [Landmark] = []
    
    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .notDetermined:
            authorizationStatus = .notDetermined
            manager.requestWhenInUseAuthorization()
        case .restricted, .denied:
            authorizationStatus = .restricted
        case .authorizedWhenInUse, .authorizedAlways:
            authorizationStatus = .authorizedWhenInUse
            manager.startUpdatingLocation()
        default:
            break
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        // Handle location updates
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error: \(error.localizedDescription)")
    }
    
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        if let circularRegion = region as? CLCircularRegion {
            print("Entered region: \(circularRegion.identifier)")
            self.triggerHapticFeedback()
            showingAlert = true
            isInGeographicalZone = true
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        if let circularRegion = region as? CLCircularRegion {
            print("Exited region: \(circularRegion.identifier)")
            isInGeographicalZone = false
        }
    }
    
    func startMonitoringRegions(for landmarks: [Landmark]) {
        for landmark in landmarks {
            let region = CLCircularRegion(center: CLLocationCoordinate2D(latitude: landmark.latitude, longitude: landmark.longitude), radius: 50, identifier: landmark.name)
            region.notifyOnEntry = true
            region.notifyOnExit = true
            locationManager.startMonitoring(for: region)
        }
    }
    
    private func triggerHapticFeedback() {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
    }
}

