//
//  landmark_trading_cardsApp.swift
//  landmark-trading-cards
//
//  Created by Brad Grigsby on 5/19/24.
//

import FirebaseCore
import SwiftUI

@main
struct landmark_trading_cardsApp: App {
    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            MainView(landmark: landmarks[0])
        }
    }
}
