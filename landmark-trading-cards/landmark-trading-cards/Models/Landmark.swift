//
//  Landmark.swift
//  landmark-trading-cards
//
//  Created by Brad Grigsby on 5/21/24.
//
import Foundation
import SwiftUI

struct Landmark: Hashable, Codable {
    var name: String
    var location: String
    var description: String
    var unlocked: Bool
    var rarity: Rarity
    var imageName: String
}

enum Rarity: String, Codable {
    case common, rare, epic, legendary
    
    var color: Color {
        switch self {
        case .common:
            return .gray
        case .rare:
            return .blue
        case .epic:
            return .purple
        case .legendary:
            return .orange
        }
    }
}
//    private var coordinates: Coordinates
//    var locationCoordinate: CLLocationCoordinate2D {
//        CLLocationCoordinate2D(
//            latitude: coordinates.latitude,
//            longitude: coordinates.longitude)
//    }
//
//    struct Coordinates: Hashable, Codable {
//        var latitude: Double
//        var longitude: Double
//    }
