//
//  ExpandedLandmarkView.swift
//  landmark-trading-cards
//
//  Created by Brad Grigsby on 7/29/24.
//

import SwiftUI

struct ExpandedLandmarkView: View {
    let landmark: Landmark
    @State private var scale: CGFloat = 0.1

    var body: some View {
        ZStack {
            Color.gray.opacity(0.8)
                .ignoresSafeArea()
            Image(landmark.expandedImageName)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .scaleEffect(scale)
                .padding(.horizontal, 20)
                .onAppear {
                    withAnimation(.easeInOut(duration: 0.5)) {
                        scale = 1
                    }
                }
                .onDisappear {
                    scale = 0.1 // Reset the scale on dismiss
                }
        }
    }
}

#Preview {
    ExpandedLandmarkView(landmark: landmarks[0])
}
