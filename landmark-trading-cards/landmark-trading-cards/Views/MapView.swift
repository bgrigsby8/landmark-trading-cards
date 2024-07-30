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
    
    var body: some View {
        VStack {
            switch locationDataManager.locationManager.authorizationStatus {
            case .authorizedWhenInUse:
                Map(position: $cameraPosition) {
                    UserAnnotation()
                    // Use this code below to display custom user location
//                    UserAnnotation {
//                        Image(systemName: "star")
//                            .imageScale(.large)
//                            .foregroundStyle(.blue)
//                    }
                }
                .mapControls {
                    MapUserLocationButton()
                }
                .onAppear {
                    updateMapRegion()
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
                    latitudeDelta: 0.15,
                    longitudeDelta: 0.15
                )
            )
            withAnimation {
                cameraPosition = .region(userRegion)
            }
        }
    }
}

#Preview {
    MapView()
}

