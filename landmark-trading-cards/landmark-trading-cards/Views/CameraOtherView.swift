//
//  CameraOtherView.swift
//  landmark-trading-cards
//
//  Created by Brad Grigsby on 7/31/24.
//

import AVFoundation
import SwiftUI

struct CameraOtherView: UIViewControllerRepresentable {
    @Binding var recognizedLandmarks: String
    var locationDataManager: LocationDataManager

    func makeUIViewController(context: Context) -> CameraViewController {
        let controller = CameraViewController(recognizedLandmarks: $recognizedLandmarks, locationDataManager: locationDataManager)
        return controller
    }
    
    func updateUIViewController(_ uiViewController: CameraViewController, context: Context) {}
}

#Preview {
    CameraOtherView(recognizedLandmarks: .constant("test"), locationDataManager: LocationDataManager())
}

