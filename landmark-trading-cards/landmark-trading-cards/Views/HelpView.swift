//
//  HelpView.swift
//  landmark-trading-cards
//
//  Created by Brad Grigsby on 8/9/24.
//

import SwiftUI

struct HelpView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    
    var body: some View {
        Text("FAQ's")
            .font(.title)
            .fontWeight(.bold)
            .padding(.vertical, 10.0)
        
        DisclosureGroup("Can I unlock the landmark during the night time?") {
            Text("Unfortunately, no. Our image classification models have been trained to recognize the landmarks during the day")
                
        }
        .padding(.horizontal, 15.0)
        
        DisclosureGroup("How can I verify my email?") {
            Text("You should have received a verification email when you signed up, or you can ")
            Button(action: {
                sendVerificationEmail()
            }, label: {
                Text("Send Verification Email")
            })
        }
        .padding(.horizontal, 15.0)
        
        Spacer()
        
    }
    
    
    
    func sendVerificationEmail() {
        guard let user = authViewModel.userSession else { return }
        user.sendEmailVerification { error in
            if let error = error {
                print("DEBUG: Failed to send email verification with error \(error.localizedDescription)")
            } else {
                print("Verification email sent.")
            }
        }
    }
}

#Preview {
    HelpView()
        .environmentObject(AuthViewModel())
}
