//
//  ProfileView.swift
//  landmark-trading-cards
//
//  Created by Brad Grigsby on 5/19/24.
//

import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @State private var selectedImage: UIImage? = nil
    @State private var profileImage: Image? = nil
    @State private var isImagePickerPresented = false
    
    var body: some View {
        NavigationView {
            if let user = authViewModel.currentUser {
                List {
                    Section {
                        HStack {
                            if let profileImage = profileImage {
                                profileImage
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 72, height: 72)
                                    .clipShape(Circle())
                                    .onTapGesture {
                                        isImagePickerPresented.toggle()
                                    }
                            } else {
                                Text(user.initials)
                                    .font(.title)
                                    .fontWeight(.semibold)
                                    .foregroundStyle(.white)
                                    .frame(width: 72, height: 72)
                                    .background(Color(.systemGray3))
                                    .clipShape(Circle())
                                    .onTapGesture {
                                        isImagePickerPresented.toggle()
                                    }
                            }
                            
                            VStack(alignment: .leading, spacing: 4) {
                                Text(user.fullname)
                                    .font(.subheadline)
                                    .fontWeight(.semibold)
                                    .padding(.top, 4)
                                
                                Text(user.email)
                                    .font(.footnote)
                                    .tint(Color(.gray))
                                    .foregroundStyle(.gray)
                            }
                        }
                    }
                    
                    Section("Activity Summary") {
                        Text("Landmarks Identified: \(authViewModel.currentUser?.fullname ?? "0")")
                        Text("Cards Collected: \(authViewModel.currentUser?.id ?? "0")")
                        Text("Last Visited: \(authViewModel.currentUser?.email ?? "N/A")")
                    }
                    
                    Section("General") {
                        HStack {
                            SettingsRowView(imageName: "gear", title: "Version", tintColor: Color(.systemGray))
                            
                            Spacer()
                            
                            Text("1.0.0")
                                .font(.subheadline)
                                .foregroundStyle(.gray)
                        }
                    }
                    
                    Section("Account") {
                        Button {
                            authViewModel.signOut()
                        } label: {
                            SettingsRowView(imageName: "arrow.left.circle.fill", title: "Sign Out", tintColor: .red)
                        }
                        
                        Button {
                            print("Delete account...")
                        } label: {
                            SettingsRowView(imageName: "xmark.circle.fill", title: "Delete Account", tintColor: .red)
                        }
                    }
                    
                    Section("Edit Profile") {
                        NavigationLink(destination: EditProfileView(user: authViewModel.currentUser ?? User.MOCK_USER)) {
                            SettingsRowView(imageName: "circle", title: "Edit Profile", tintColor: .blue)
                        }
                    }
                    
                    Section("Support") {
                        NavigationLink(destination: HelpView()) {
                            SettingsRowView(imageName: "questionmark.circle.fill", title: "Help & Support", tintColor: .blue)
                        }
                    }
                }
                .sheet(isPresented: $isImagePickerPresented) {
                    //                ImagePicker(selectedImage: $selectedImage, image: $profileImage)
                }
            } else {
                Text("No user data available. Contact LandMarked")
                Button {
                    authViewModel.signOut()
                } label: {
                    Text("SIGN OUT")
                }
            }
        }
    }
}

#Preview {
    ProfileView()
        .environmentObject(AuthViewModel())
}
