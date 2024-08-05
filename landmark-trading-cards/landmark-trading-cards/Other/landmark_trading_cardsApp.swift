//
//  landmark_trading_cardsApp.swift
//  landmark-trading-cards
//
//  Created by Brad Grigsby on 5/19/24.
//

import Firebase
import FirebaseCore
import SwiftUI

@main
struct landmark_trading_cardsApp: App {
    @StateObject var viewModel = AuthViewModel()
    
    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            NavigationView {
                MainView()
                    .environmentObject(viewModel)
            }
        }
    }
}
