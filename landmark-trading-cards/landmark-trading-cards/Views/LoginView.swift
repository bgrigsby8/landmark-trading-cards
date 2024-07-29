//
//  LoginView.swift
//  landmark-trading-cards
//
//  Created by Brad Grigsby on 5/19/24.
//

import SwiftUI

struct LoginView: View {
    
    @State var email = ""
    @State var password = ""
    
    var body: some View {
        VStack {
            // Header
            ZStack {
                VStack {
                    Text("LandMarked")
                        .font(.system(size: 50))
                        .foregroundStyle(Color(red: 0.95, green: 0.5, blue: 0.8, opacity: 1.0))
                        .bold()
                    Text("App subtitle")
                        .font(.system(size: 30))
                }
            }
            Form {
                TextField("Email Address", text: $email)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                SecureField("Password", text: $password)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                Button {
                    // Attempt login
                } label: {
                    ZStack {
                        RoundedRectangle(cornerRadius: 10)
                            .foregroundStyle(.blue)
                        
                        Text("Log In")
                            .foregroundStyle(.white)
                            .bold()
                    }
                }
            }
            Spacer()
        }
    }
}

#Preview {
    LoginView()
}
