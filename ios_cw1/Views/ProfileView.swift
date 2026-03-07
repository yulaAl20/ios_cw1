//
//  ProfileView.swift
//  ios_cw1
//
//  Created by COBSCCOMP242P-74 on 2026-03-07.
//

import SwiftUI

struct ProfileView: View {
    @Environment(\.dismiss) var dismiss
    @AppStorage("isLoggedIn") private var isLoggedIn = true
    
    @AppStorage("userName") private var userName: String = ""
    @AppStorage("userEmail") private var userEmail: String = ""
    @AppStorage("userDOB") private var userDOB: TimeInterval = Date().timeIntervalSince1970
    
    let patientID = "#482931"
    
    var body: some View {
        VStack(spacing: 0) {
            // Top bar
            HStack {
                Button(action: { dismiss() }) {
                    Image(systemName: "chevron.left")
                        .font(.title2)
                        .foregroundColor(.primary)
                }
                Spacer()
                Text("My Profile")
                    .font(.headline)
                    .fontWeight(.semibold)
                Spacer()
                NavigationLink(destination: ProfileDetailsView()) {
                    Text("Edit")
                        .font(.body)
                        .fontWeight(.medium)
                        .foregroundColor(.blue)
                }
            }
            .padding(.horizontal, 24)
            .padding(.top, 16)
            .padding(.bottom, 8)
            
            ScrollView {
                VStack(spacing: 24) {
                    // Avatar
                    ZStack {
                        Circle()
                            .fill(Color.blue.opacity(0.15))
                            .frame(width: 100, height: 100)
                        Image(systemName: "person.circle.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 100, height: 100)
                            .foregroundColor(.blue)
                    }
                    .padding(.top, 20)
                    
                    Text(userName.isEmpty ? "Your Name" : userName)
                        .font(.title2)
                        .fontWeight(.semibold)
                    
                    Text("Patient ID: \(patientID)")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                    
                    if !userEmail.isEmpty {
                        Text(userEmail)
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                    
                    // Menu items
                    VStack(spacing: 16) {
                        NavigationLink(destination: ProfileDetailsView()) {
                            ProfileMenuItem(icon: "person.text.page", title: "Profile Details")
                        }
                        NavigationLink(destination: SettingsView()) {
                            ProfileMenuItem(icon: "gear", title: "Settings")
                        }
                        NavigationLink(destination: NotificationsView()) {
                            ProfileMenuItem(icon: "bell", title: "Notifications")
                        }
                    }
                    .padding(.top, 20)
                    
                    Spacer(minLength: 40)
                }
                .padding(.horizontal, 24)
            }
            
            VStack {
                Button(action: {
                    isLoggedIn = false
                }) {
                    Text("Sign Out")
                        .font(.headline)
                        .foregroundColor(.red)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 18)
                        .background(Color(.systemGray6))
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                }
                .padding(.horizontal, 24)
                .padding(.vertical, 16)
                .background(Color(.systemBackground))
                .shadow(color: .black.opacity(0.1), radius: 12, y: -6)
            }
        }
        .navigationBarHidden(true)
    }
}

struct ProfileMenuItem: View {
    let icon: String
    let title: String
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .font(.body)
                .foregroundColor(.blue)
                .frame(width: 32)
            Text(title)
                .font(.body)
                .foregroundColor(.primary)
            Spacer()
            Image(systemName: "chevron.right")
                .font(.caption)
                .foregroundColor(.gray)
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
}

#Preview {
    NavigationStack {
        ProfileView()
    }
}
