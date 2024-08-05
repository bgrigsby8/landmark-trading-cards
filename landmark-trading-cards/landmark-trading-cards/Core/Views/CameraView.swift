//
//  CameraView.swift
//  landmark-trading-cards
//
//  Created by Brad Grigsby on 7/30/24.
//

import SwiftUI

struct CameraView: View {
    @State private var recognizedLandmarks = ""
    
    var body: some View {
        VStack {
            CameraOtherView(recognizedLandmarks: $recognizedLandmarks)
                .edgesIgnoringSafeArea(.all)
            
            Text("Recognized Landmarks: \(recognizedLandmarks)")
                .padding()
        }
        .onChange(of: recognizedLandmarks) {
            unlockTradingCard(for: recognizedLandmarks)
        }
    }
    
    func unlockTradingCard(for recognizedLandmarks: String) {
        // Implement the logic to unlock a trading card
        // based on the recognized landmark
        print("Unlock trading card for: \(recognizedLandmarks)")
    }
}

#Preview {
    CameraView()
}


