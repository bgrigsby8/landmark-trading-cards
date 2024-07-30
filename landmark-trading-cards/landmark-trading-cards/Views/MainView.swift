//
//  ContentView.swift
//  landmark-trading-cards
//
//  Created by Brad Grigsby on 5/19/24.
//

import SwiftUI

struct MainView: View {
    @State private var selectedIndex: Int?
    
    var body: some View {
        TabView(selection: $selectedIndex) {
            NavigationStack() {
                TradingCardsView(landmark: landmarks[0])
            }
            .tabItem {
                Text("Cards")
                Image(systemName: "house.fill")
                    .renderingMode(.template)
            }
            .tag(0)
            
            NavigationStack() {
                MapView(landmarks: landmarks)
            }
            .tabItem {
                Label("Map", systemImage: "map.fill")
            }
            .tag(1)
            
            NavigationStack() {
                Text("Profile view")
                    .navigationTitle("Profile")
                
            }
            .tabItem {
                Text("Profile")
                Image(systemName: "person.fill")
                
            }
            .tag(2)
            
            NavigationStack() {
                Text("Camera view")
                    .navigationTitle("Camera")
            }
            .tabItem {
                Text("Camera")
                Image(systemName: "camera.fill")
            }
            
        }
    }
}

#Preview {
    MainView()
}
