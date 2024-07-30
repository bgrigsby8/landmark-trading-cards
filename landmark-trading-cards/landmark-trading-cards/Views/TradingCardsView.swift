//
//  TradingCardsView.swift
//  landmark-trading-cards
//
//  Created by Brad Grigsby on 7/29/24.
//

import SwiftUI

struct TradingCardsView: View {
    @State private var selectedLandmarkId: Int? = nil
    @State private var isExpandedViewPresented = false
    
    let landmark: Landmark
    let columns = [
        GridItem(.adaptive(minimum: 150))
    ]
    var body: some View {
        ZStack {
            NavigationStack {
                ScrollView(.vertical) {
                    LazyVGrid(columns: columns, content: {
                        ForEach(landmarks) { landmark in
                            Button(action: {
                                withAnimation {
                                    selectedLandmarkId = landmark.id
                                    isExpandedViewPresented = true
                                }
                            }) {
                                TradingCardView(landmark: landmark)
                            }
                        }
                    })
                    .padding()
                }
                .navigationTitle("New York")
            }
            if isExpandedViewPresented,
               let selectedLandmarkId = selectedLandmarkId,
               let selectedLandmark = landmarks.first(where: { $0.id == selectedLandmarkId }) {
                ExpandedLandmarkView(landmark: selectedLandmark)
                    .onTapGesture {
                        isExpandedViewPresented = false
                    }
            }
        }
    }
}

#Preview {
    TradingCardsView(landmark: landmarks[0])
}
