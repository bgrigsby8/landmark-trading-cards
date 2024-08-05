//
//  TradingCardView.swift
//  landmark-trading-cards
//
//  Created by Brad Grigsby on 5/21/24.
//

import SwiftUI

struct TradingCardView: View {
    let landmark: Landmark
    
    var body: some View {
        VStack {
            ZStack {
                Image(landmark.collapsedImageName)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 200, height: 230)
            }
            .frame(width: 175, height: 200)
        }
        .shadow(radius: 5)
        .padding()
    }
}

#Preview {
    TradingCardView(landmark: landmarks[0])
}
