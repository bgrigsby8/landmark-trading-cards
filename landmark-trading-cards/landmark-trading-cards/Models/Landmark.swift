//
//  Landmark.swift
//  landmark-trading-cards
//
//  Created by Brad Grigsby on 5/21/24.
//
import Foundation
import SwiftUI

struct Landmark: Hashable, Codable, Identifiable {
    var id: Int
    var name: String
    var identifier: String
    var location: String
    var unlocked: Bool
    var collapsedImageName: String
    var expandedImageName: String
    var description: String
    var rarity: Rarity
    var latitude: Double
    var longitude: Double 
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
