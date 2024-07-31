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
    @State private var animateCameraIcon = false
    @State private var showCameraView = false
    @Binding var isLandmarkNearby: Bool
    
    let landmark: Landmark
    let columns = [
        GridItem(.adaptive(minimum: 150))
    ]
    
    var body: some View {
        ZStack {
            NavigationStack {
                VStack {
                    HStack {
                        Text("New York")
                            .font(.largeTitle)
                            .bold()
                        Spacer()
                        if isLandmarkNearby {
//                            Button(action: {
//                                print("Showing camera view")
//                                showCameraView = true
//                            }) {
//                                Image(systemName: "camera.fill")
//                                    .foregroundColor(.blue)
//                                    .opacity(animateCameraIcon ? 1.0 : 0.3)
//                                    .scaleEffect(animateCameraIcon ? 1.2 : 1.0)
//                            }
                            NavigationLink(destination: CameraView()) {
                                Image(systemName: "camera.fill")
                                    .foregroundColor(.blue)
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
                                .foregroundColor(.gray)
                        }
                    }
                    .padding([.horizontal, .top])
                    
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
            CameraView()
        }
    }
}

#Preview {
    TradingCardsView(isLandmarkNearby: .constant(true), landmark: landmarks[0])
}





