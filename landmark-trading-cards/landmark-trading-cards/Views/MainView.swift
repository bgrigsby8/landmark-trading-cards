//
//  ContentView.swift
//  landmark-trading-cards
//
//  Created by Brad Grigsby on 5/19/24.
//

import SwiftUI

struct MainView: View {
    let landmark: Landmark
    let columns = [
        GridItem(.adaptive(minimum: 150))
    ]
    
    var body: some View {
        NavigationStack {
            ScrollView(.vertical) {
                LazyVGrid(columns: columns, content: {
                    ForEach(landmarks, id: \.self) { landmark in
                        TradingCardView(landmark: landmark)
                    }
                    .padding()
                })
            }
            .navigationTitle("New York")
        }
    }
}

#Preview {
    MainView(landmark: landmarks[0])
}
