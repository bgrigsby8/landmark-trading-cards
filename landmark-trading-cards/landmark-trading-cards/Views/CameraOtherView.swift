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

    func makeUIViewController(context: Context) -> CameraViewController {
        let controller = CameraViewController(recognizedLandmarks: $recognizedLandmarks)
        return controller
    }
    
    func updateUIViewController(_ uiViewController: CameraViewController, context: Context) {}
}

#Preview {
    CameraOtherView(recognizedLandmarks: .constant("test"))
}

