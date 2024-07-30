//
//  MapView.swift
//  landmark-trading-cards
//
//  Created by Brad Grigsby on 7/29/24.
//

import SwiftUI
import MapKit

struct MapView: View {
    @StateObject var locationDataManager = LocationDataManager()
    @State private var userLocation: CLLocationCoordinate2D?
    @State private var cameraPosition: MapCameraPosition = .userLocation(fallback: .automatic)

    var landmarks: [Landmark]
    
    var body: some View {
        VStack {
            switch locationDataManager.locationManager.authorizationStatus {
            case .authorizedWhenInUse:
                Map(position: $cameraPosition) {
                    ForEach(landmarks) { landmark in
                        MapCircle(center: CLLocationCoordinate2D(latitude: landmark.latitude, longitude: landmark.longitude), radius: CLLocationDistance(integerLiteral: 50))
                    }
                    UserAnnotation()
                }
                .mapControls {
                    MapUserLocationButton()
                }
                .onAppear {
                    updateMapRegion()
                    locationDataManager.startMonitoringRegions(for: landmarks)
                }
                .alert(isPresented: $locationDataManager.showingAlert) {
                    Alert(title: Text("Landmark Nearby!"), message: Text("Switch to camera mode and snap a pic to unlock the nearby landmark"))
                }
            case .restricted, .denied:
                LocationDeniedView()
            case .notDetermined:
                Text("Finding your location...")
                ProgressView()
            default:
                ProgressView()
            }
        }
    }
    
    func updateMapRegion() {
        if let userLocation = locationDataManager.locationManager.location {
            let userRegion = MKCoordinateRegion(
                center: userLocation.coordinate,
                span: MKCoordinateSpan(
                    latitudeDelta: 0.01,
                    longitudeDelta: 0.01
                )
            )
            withAnimation {
                cameraPosition = .region(userRegion)
            }
        }
    }
}

#Preview {
    MapView(landmarks: landmarks)
}


