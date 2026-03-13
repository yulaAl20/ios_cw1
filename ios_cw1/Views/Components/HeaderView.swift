//
//  HeaderView.swift
//  ios_cw1
//
//  Created by Yulani Alwis on 2026-03-03.
//

import SwiftUI

struct HeaderView: View {

    var title: String? = nil
    var searchPlaceholder: String = "Search"

    @State private var showProfile  = false
    @State private var showSettings = false

    var body: some View {
        VStack(spacing: 10) {
            HStack(spacing: 12) {
                // Profile avatar button
                Button(action: { showProfile = true }) {
                    ZStack {
                        Circle()
                            .fill(Color.white.opacity(0.25))
                            .frame(width: 44, height: 44)
                        Image(systemName: "person.circle")
                            .font(.system(size: 24))
                            .foregroundColor(.black.opacity(0.6))
                    }
                }
                .accessibilityLabel("My Profile")
                .accessibilityHint("Opens your profile page")
                .sheet(isPresented: $showProfile) {
                    NavigationStack { ProfileView() }
                }

                Spacer()

                if let title = title {
                    Text(title)
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(.black)
                }

                Spacer()

                HStack(spacing: 8) {
                    // Bell icon
                    ZStack {
                        Circle()
                            .fill(Color.white.opacity(0.25))
                            .frame(width: 36, height: 36)
                        Image(systemName: "bell")
                            .font(.system(size: 18))
                            .foregroundColor(.black.opacity(0.6))
                    }
                    .accessibilityLabel("Notifications")

                    // Accessibility settings gear
                    Button(action: { showSettings = true }) {
                        ZStack {
                            Circle()
                                .fill(Color.white.opacity(0.25))
                                .frame(width: 36, height: 36)
                            Image(systemName: "accessibility")
                                .font(.system(size: 18))
                                .foregroundColor(.black.opacity(0.6))
                        }
                    }
                    .accessibilityLabel("Accessibility Settings")
                    .accessibilityHint("Opens accessibility options including wheelchair mode, color blind mode, and more")
                    .sheet(isPresented: $showSettings) {
                        NavigationStack { SettingsView() }
                    }
                }
            }

            // Search bar
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.black)
                Text(searchPlaceholder)
                    .foregroundColor(.black.opacity(0.6))
                Spacer()
                Image(systemName: "mic.fill")
                    .foregroundColor(.black.opacity(0.6))
            }
            .padding(10)
            .background(Color(.systemGray6))
            .cornerRadius(20)
        }
        .foregroundColor(.black)
    }
}

#Preview {
    HeaderView()
        .padding()
        .environmentObject(AccessibilityViewModel())
}
