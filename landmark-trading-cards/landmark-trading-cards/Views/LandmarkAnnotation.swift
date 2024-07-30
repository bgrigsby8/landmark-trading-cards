//
//  LandmarkAnnotation.swift
//  landmark-trading-cards
//
//  Created by Brad Grigsby on 7/29/24.
//

import SwiftUI
import CoreLocation
import MapKit

struct LandmarkAnnotation: View {
    let landmark: Landmark

    var body: some View {
        VStack {
            Image(landmark.collapsedImageName)
                .resizable()
                .frame(width: 50, height: 50)
            Text(landmark.name)
        }
    }
}

//struct MapView: View {
//    // ...
//
//    var body: some View {
//        Map(coordinateRegion: .constant(MKCoordinateRegion(
//            center: CLLocationCoordinate2D(latitude: 40.7128, longitude: 74.0060),
//            span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
//        )))
//        .annotationItems(landmarks) { landmark in
//            MapAnnotation(coordinate: landmark.location) {
//                LandmarkAnnotation(landmark: landmark)
//            }
//        }
//    }
//}
