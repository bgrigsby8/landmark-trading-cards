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
    @Published var inLandmark = ""


    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        startMonitoringRegions(for: landmarks)
        locationManager.startUpdatingLocation()
        
        // Check current location against monitored regions on startup
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { // Add a slight delay to ensure location is updated
            self.checkCurrentLocation()
        }
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
            inLandmark = circularRegion.identifier
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        if let circularRegion = region as? CLCircularRegion {
            print("Exited region: \(circularRegion.identifier)")
            isInGeographicalZone = false
            inLandmark = ""
        }
    }
    
    func startMonitoringRegions(for landmarks: [Landmark]) {
        locationManager.monitoredRegions.forEach { region in
            locationManager.stopMonitoring(for: region)
        }
        for landmark in landmarks {
            let region = CLCircularRegion(center: CLLocationCoordinate2D(latitude: landmark.latitude, longitude: landmark.longitude), radius: 25, identifier: landmark.identifier)
            print("\(region.identifier)")
            region.notifyOnEntry = true
            region.notifyOnExit = true
            locationManager.startMonitoring(for: region)
        }
    }
    
    private func checkCurrentLocation() {
        guard let currentLocation = locationManager.location else { return }
        
        for region in locationManager.monitoredRegions {
            if let circularRegion = region as? CLCircularRegion, circularRegion.contains(currentLocation.coordinate) {
                print("Already in region: \(circularRegion.identifier)")
                triggerHapticFeedback()
                showingAlert = true
                isInGeographicalZone = true
                inLandmark = circularRegion.identifier
                break
            }
        }
    }
    
    private func triggerHapticFeedback() {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
    }
}

