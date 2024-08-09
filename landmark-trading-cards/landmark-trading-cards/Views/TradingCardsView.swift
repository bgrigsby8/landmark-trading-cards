//
//  TradingCardsView.swift
//  landmark-trading-cards
//
//  Created by Brad Grigsby on 7/29/24.
//

import SwiftUI

struct TradingCardsView: View {
    @EnvironmentObject var locationDataManager: LocationDataManager
    @State private var selectedLandmarkId: Int? = nil
    @State private var isExpandedViewPresented = false
    @State private var animateCameraIcon = false
    @State private var showCameraView = false
    @State private var selectedCity: String = "Select City"
    @Binding var isLandmarkNearby: Bool
    
    let landmark: Landmark
    let columns = [
        GridItem(.adaptive(minimum: 150))
    ]
    
    var uniqueCities: [String] {
        let cities = landmarks.map { $0.location }
        return Array(Set(cities))
    }
    
    var filteredLandmarks: [Landmark] {
        if selectedCity == "Select City" {
            return landmarks
        } else {
            return landmarks.filter { $0.location == selectedCity }
        }
    }
    
    var body: some View {
        ZStack {
            NavigationStack {
                VStack {
                    HStack {
                        Menu {
                            ForEach(uniqueCities, id:\.self) { city in
                                Button(action: {
                                    selectedCity = city
                                }) {
                                    Text(city)
                                }
                            }
                        } label: {
                            Text(selectedCity)
                                .font(.largeTitle)
                                .bold()
                                .foregroundStyle(.black)
                        }
                        Spacer()
                        if locationDataManager.isInGeographicalZone {
                            NavigationLink(destination: CameraView(locationDataManager: LocationDataManager())) {
                                Image(systemName: "camera.fill")
                                    .resizable()
                                    .foregroundColor(.blue)
                                    .frame(width: 30, height: 30)
                                    .opacity(animateCameraIcon ? 1.0 : 0.3)
                                    .scaleEffect(animateCameraIcon ? 1.2: 1.0)
                            }
                            .onAppear {
                                withAnimation(Animation.easeInOut(duration: 1.0).repeatForever()) {
                                    animateCameraIcon.toggle()
                                }
                            }
                        } else {
                            Image(systemName: "camera")
                                .resizable()
                                .foregroundColor(.gray)
                                .frame(width: 30, height: 30)
                        }
                    }
                    .padding(.horizontal, 25.0)
                    .padding(.top)
                    
                    ScrollView(.vertical) {
                        LazyVGrid(columns: columns, content: {
                            ForEach(filteredLandmarks) { landmark in
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
                }
                .navigationTitle("")
                .navigationBarTitleDisplayMode(.inline)
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
        .sheet(isPresented: $showCameraView) {
            CameraView(locationDataManager: LocationDataManager())
        }
    }
}

#Preview {
    TradingCardsView(isLandmarkNearby: .constant(false), landmark: landmarks[0])
        .environmentObject(LocationDataManager())
}





