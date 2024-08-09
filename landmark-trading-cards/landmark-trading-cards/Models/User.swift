//
//  User.swift
//  landmark-trading-cards
//
//  Created by Brad Grigsby on 8/3/24.
//

import Foundation

struct User: Identifiable, Codable {
    let id: String
    var fullname: String
    var email: String
    
    var initials: String {
        let formatter = PersonNameComponentsFormatter()
        if let components = formatter.personNameComponents(from: fullname) {
            formatter.style = .abbreviated
            return formatter.string(from: components)
        }
        
        return ""
    }
    
//    static var MOCK_USER = User(id: NSUUID().uuidString, fullname: "Brad Grigsby", email: "test@email.com")
}

extension User {
    static var MOCK_USER = User(id: NSUUID().uuidString, fullname: "Brad Grigsby", email: "test@email.com")
}
