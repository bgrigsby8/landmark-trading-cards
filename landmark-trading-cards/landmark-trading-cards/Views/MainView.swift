//
//  ContentView.swift
//  landmark-trading-cards
//
//  Created by Brad Grigsby on 5/19/24.
//

import SwiftUI

struct MainView: View {
    @State private var selectedLandmarkId: Int?
    @State private var isExpandedViewPresented = false
    
    let landmark: Landmark
    let columns = [
        GridItem(.adaptive(minimum: 150))
    ]
    
    
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
                MapView()
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
            
        }
    }
}

#Preview {
    MainView(landmark: landmarks[0])
}
