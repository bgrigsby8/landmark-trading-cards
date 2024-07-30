//
//  LocationDeniedView.swift
//  landmark-trading-cards
//
//  Created by Brad Grigsby on 7/30/24.
//

import SwiftUI

struct LocationDeniedView: View {
    var body: some View {
        ContentUnavailableView(label: {
            Label("Location Services", systemImage: "star")
        }, description: {
            Text("""
1. Tap the button below and go to "Privacy and Security"
2. Tap on "Location Services"
3. Locate the "LandMarked" app and tap on it
4. Change the settings to "While Using the App"
""")
            .multilineTextAlignment(/*@START_MENU_TOKEN@*/.leading/*@END_MENU_TOKEN@*/)
        }, actions: {
            Button(action: {
                UIApplication.shared.open(
                    URL(string: UIApplication.openSettingsURLString)!
                )
            }) {
                Text("Open Settings")
            }
            .buttonStyle(.borderedProminent)
        })
    }
}

#Preview {
    LocationDeniedView()
}
