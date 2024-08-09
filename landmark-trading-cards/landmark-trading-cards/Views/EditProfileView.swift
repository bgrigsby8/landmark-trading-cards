//
//  EditProfileView.swift
//  landmark-trading-cards
//
//  Created by Brad Grigsby on 8/9/24.
//

import SwiftUI

struct EditProfileView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @State private var fullname: String
    @State private var email: String
    
    init(user: User) {
        _fullname = State(initialValue: user.fullname)
        _email = State(initialValue: user.email)
    }
    
    var body: some View {
        Form {
            Section(header: Text("Name")) {
                TextField("Full Name", text: $fullname)
            }
            Section(header: Text("Email")) {
                TextField("Email", text: $email)
                    .autocapitalization(.none)
            }
            Button(action: {
                Task {
                    await authViewModel.updateUser(fullname: fullname, email: email)
                }
            }, label: {
                Text("Save Changes")
            })
        }
    }
}

#Preview {
    EditProfileView(user: User.MOCK_USER)
        .environmentObject(AuthViewModel())
}
