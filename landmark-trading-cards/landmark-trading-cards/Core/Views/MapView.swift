//
//  MapView.swift
//  landmark-trading-cards
//
//  Created by Brad Grigsby on 7/29/24.
//

import SwiftUI
import MapKit

struct MapView: View {
    @EnvironmentObject var locationDataManager: LocationDataManager
    @State private var userLocation: CLLocationCoordinate2D?
    @State private var cameraPosition: MapCameraPosition = .userLocation(fallback: .automatic)
    @Binding var showCameraView: Bool
    @Binding var isLandmarkNearby: Bool
        
    var body: some View {
        VStack {
            switch locationDataManager.authorizationStatus {
            case .authorizedWhenInUse:
                Map(position: $cameraPosition) {
                    ForEach(landmarks) { landmark in
                        MapCircle(center: CLLocationCoordinate2D(latitude: landmark.latitude, longitude: landmark.longitude), radius: CLLocationDistance(integerLiteral: 50))
                            .stroke(Color.blue, lineWidth: 2)
                            .tag(landmark.name)
                    }
                    UserAnnotation()
                }
                .mapControls {
                    MapUserLocationButton()
                }
                .onAppear {
                    print("Map view appeared")
                    updateMapRegion()
                    locationDataManager.startMonitoringRegions(for: landmarks)
                }
                .alert(isPresented: $locationDataManager.showingAlert) {
                    Alert(
                        title: Text("Landmark Nearby!"),
                        message: Text("Switch to camera mode and snap a pic to unlock the nearby landmark"),
                        primaryButton: .default(Text("Go to Camera")) {
                            showCameraView = true
                        },
                        secondaryButton: .cancel()
                    )
                }
                .onChange(of: locationDataManager.isInGeographicalZone) { isInZone in
                    isLandmarkNearby = isInZone
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
    MapView(showCameraView: .constant(false), isLandmarkNearby: .constant(false))
        .environmentObject(LocationDataManager())
}





