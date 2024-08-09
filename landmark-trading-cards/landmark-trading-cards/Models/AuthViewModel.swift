//
//  AuthViewModel.swift
//  landmark-trading-cards
//
//  Created by Brad Grigsby on 8/3/24.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift

protocol AuthenticationFormProtocol {
    var formIsValid: Bool { get }
}

@MainActor
class AuthViewModel: ObservableObject {
    @Published var userSession: FirebaseAuth.User?
    @Published var currentUser: User?
    
    init() {
        self.userSession = Auth.auth().currentUser
        
        Task {
            await fetchUser()
        }
    }
    
    func signIn(withEmail email: String, password: String) async throws {
        do {
            let result = try await Auth.auth().signIn(withEmail: email, password: password)
            self.userSession = result.user
            await fetchUser()
        } catch {
            print("DEBUG: Failed to login with error \(error.localizedDescription)")
        }
    }
    
    func createUser(withEmail email: String, password: String, fullname: String) async throws {
        do {
            let result = try await Auth.auth().createUser(withEmail: email, password: password)
            self.userSession = result.user
            
            let user = User(id: result.user.uid, fullname: fullname, email: email)
            let encodedUser = try Firestore.Encoder().encode(user)
            try await Firestore.firestore().collection("users").document(user.id).setData(encodedUser)
            
            // Send email verification
            try await result.user.sendEmailVerification()
            
            await fetchUser()
        } catch {
            print("DEBUG: Failed to create user with error \(error.localizedDescription)")
        }
        
    }
    
    func updateUser(fullname: String? = nil, email: String? = nil) async {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        var data: [String: Any] = [:]
        
        if let fullname = fullname {
            data["fullname"] = fullname
            self.currentUser?.fullname = fullname
        }
        
        if let email = email {
            data["email"] = email
            do {
                try await Auth.auth().currentUser?.sendEmailVerification(beforeUpdatingEmail: email)
            } catch {
                print("DEBUG: Failed to update email with error: \(error.localizedDescription)")
            }
        }
        
        if !data.isEmpty {
            do {
                try await Firestore.firestore().collection("users").document(uid).updateData(data)
                await fetchUser()
            } catch {
                print("DEBUG: Failed to update user with error \(error.localizedDescription)")
            }
        }
    }
    
    func signOut() {
        do {
            try Auth.auth().signOut() // signs out user in backend
            self.userSession = nil // wipes out user session and takes back to login screen
            self.currentUser = nil // wipes out current user data model
        } catch {
            print("DEBUG: Failed to sign out with error \(error.localizedDescription)")
        }
    }
    
    func deleteAccount() {
        
    }
    
    func fetchUser() async {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        guard let snapshot = try? await Firestore.firestore().collection("users").document(uid).getDocument() else { return }
        self.currentUser = try? snapshot.data(as: User.self)
    }
}
