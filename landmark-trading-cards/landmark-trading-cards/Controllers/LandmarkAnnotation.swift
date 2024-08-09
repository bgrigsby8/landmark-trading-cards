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
                .font(.caption)
        }
    }
}
