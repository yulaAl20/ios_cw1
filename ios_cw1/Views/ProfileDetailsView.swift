//
//  ProfileDetailsView.swift
//  ios_cw1
//
//  Created by COBSCCOMP242P-74 on 2026-03-07.
//

import SwiftUI

struct ProfileDetailsView: View {
    @Environment(\.dismiss) var dismiss
    
    @AppStorage("userName") private var storedName: String = ""
    @AppStorage("userEmail") private var storedEmail: String = ""
    @AppStorage("userDOB") private var storedDOB: TimeInterval = Date().timeIntervalSince1970
    @AppStorage("userPhoneNumber") private var phoneNumber = "+94 77 123 4567"
    
    @State private var name: String = ""
    @State private var email: String = ""
    @State private var dateOfBirth: Date = Date()
    
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
                Text("Profile Details")
                    .font(.headline)
                    .fontWeight(.semibold)
                Spacer()
                Button("Save") {
                    // Save to AppStorage
                    storedName = name
                    storedEmail = email
                    storedDOB = dateOfBirth.timeIntervalSince1970
                    dismiss()
                }
                .font(.body)
                .fontWeight(.medium)
                .foregroundColor(.blue)
            }
            .padding(.horizontal, 24)
            .padding(.top, 16)
            .padding(.bottom, 8)
            
            ScrollView {
                VStack(spacing: 20) {
                    // Avatar
                    ZStack(alignment: .bottomTrailing) {
                        Circle()
                            .fill(Color.blue.opacity(0.15))
                            .frame(width: 100, height: 100)
                            .overlay(
                                Image(systemName: "person.circle.fill")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 100, height: 100)
                                    .foregroundColor(.blue)
                            )
                        
                        Button(action: {}) {
                            Image(systemName: "pencil.circle.fill")
                                .font(.title2)
                                .foregroundColor(.blue)
                                .background(Color.white.clipShape(Circle()))
                        }
                    }
                    .padding(.top, 20)
                    
                    // Form fields
                    VStack(spacing: 16) {
                        InputField(label: "Full Name", text: $name)
                        InputField(label: "Email", text: $email)
                            .keyboardType(.emailAddress)
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Phone Number")
                                .font(.caption)
                                .foregroundColor(.gray)
                            Text(phoneNumber)
                                .padding()
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .background(Color(.systemGray5))
                                .cornerRadius(12)
                                .font(.body)
                                .foregroundColor(.gray)
                        }
                        
                        DatePicker("Date of Birth", selection: $dateOfBirth, displayedComponents: .date)
                            .padding()
                            .background(Color(.systemGray6))
                            .cornerRadius(12)
                    }
                    .padding(.horizontal, 24)
                    
                    Spacer(minLength: 40)
                }
            }
        }
        .navigationBarHidden(true)
        .onAppear {
            name = storedName
            email = storedEmail
            dateOfBirth = Date(timeIntervalSince1970: storedDOB)
        }
    }
}

struct InputField: View {
    let label: String
    @Binding var text: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(label)
                .font(.caption)
                .foregroundColor(.gray)
            TextField(label, text: $text)
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(12)
                .font(.body)
        }
    }
}

#Preview {
    NavigationStack {
        ProfileDetailsView()
    }
}
