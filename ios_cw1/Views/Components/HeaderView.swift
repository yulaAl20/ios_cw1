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
    
    var body: some View {
        VStack(spacing: 10) {
            // Title row (profile icon, title text, bell icon)
            HStack(spacing: 12) {
                ZStack {
                    Circle()
                        .fill(Color.white.opacity(0.25))
                        .frame(width: 44, height: 44)
                    Image(systemName: "person.circle")
                        .font(.system(size: 24))
                        .foregroundColor(.black.opacity(0.6))
                }
                Spacer()
                if let title = title {
                    Text(title)
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(.black)
                }
                
                Spacer()
                
                ZStack {
                    Circle()
                        .fill(Color.white.opacity(0.25))
                        .frame(width: 36, height: 36)
                    Image(systemName: "bell")
                        .font(.system(size: 18))
                        .foregroundColor(.black.opacity(0.6))
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
}
