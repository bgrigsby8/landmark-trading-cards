//
//  ContentView.swift
//  landmark-trading-cards
//
//  Created by Brad Grigsby on 5/19/24.
//

import SwiftUI

struct MainView: View {
    @StateObject var locationDataManager = LocationDataManager()
    @State private var selectedIndex: Int?
    @State private var showCameraView = false
    @State private var isLandmarkNearby = false
    @EnvironmentObject var viewModel: AuthViewModel
    
    var body: some View {
        if $viewModel.userSession != nil {
            TabView(selection: $selectedIndex) {
                NavigationStack {
                    TradingCardsView(isLandmarkNearby: $isLandmarkNearby, landmark: landmarks[0])
                }
                .tabItem {
                    Text("Cards")
                    Image(systemName: "house.fill")
                        .renderingMode(.template)
                }
                .tag(0)
                
                NavigationStack {
                    MapView(showCameraView: $showCameraView, isLandmarkNearby: $isLandmarkNearby)
                }
                .tabItem {
                    Label("Map", systemImage: "map.fill")
                }
                .tag(1)
                
                NavigationStack {
                    ProfileView()
                }
                .tabItem {
                    Text("Profile")
                    Image(systemName: "person.fill")
                }
                .tag(2)
            }
            .environmentObject(locationDataManager)
            .sheet(isPresented: $showCameraView) {
                CameraView(locationDataManager: LocationDataManager())
            }
        } else {
            LoginView()
        }
    }
}

#Preview {
    MainView()
        .environmentObject(AuthViewModel())
}


