//
//  HeaderView.swift
//  ios_cw1
//
//  Created by Yulani Alwis on 2026-03-03.
//

import SwiftUI

struct HeaderView: View {
    
    var title: String? = nil
    // Optional parent-provided handler for profile taps. If set, HeaderView will call this instead of presenting its own sheet.
    var onProfileTapped: (() -> Void)? = nil
    @State private var showProfile = false
    @State private var showNotifications = false
    
    var body: some View {
        VStack(spacing: 10) {
            // Title row (profile icon, title text, bell icon)
            HStack(spacing: 12) {
                Button(action: {
                    if let handler = onProfileTapped {
                        handler()
                    } else {
                        showProfile = true
                    }
                }) {
                    ZStack {
                        Circle()
                            .fill(Color.white.opacity(0.25))
                            .frame(width: 44, height: 44)
                        Image(systemName: "person.circle")
                            .font(.system(size: 24))
                            .foregroundColor(.black.opacity(0.6))
                    }
                }
                .sheet(isPresented: $showProfile) {
                    NavigationStack {
                        ProfileView()
                    }
                }
                Spacer()
                if let title = title {
                    Text(title)
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(.black)
                }
                
                Spacer()
                
                Button {
                    showNotifications = true
                } label: {
                    ZStack {
                        Circle()
                            .fill(Color.white.opacity(0.25))
                            .frame(width: 36, height: 36)
                        Image(systemName: "bell")
                            .font(.system(size: 18))
                            .foregroundColor(.black.opacity(0.6))
                    }
                }
                .buttonStyle(.plain)
                .accessibilityLabel("Notifications")
                .sheet(isPresented: $showNotifications) {
                    NotificationsPageView()
                }
            }
        }
        .foregroundColor(.black)
    }
}
