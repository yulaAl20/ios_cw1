//
//  HeaderView.swift
//  ios_cw1
//
//  Created by Yulani Alwis on 2026-03-03.
//

import SwiftUI

struct HeaderView: View {
    var body: some View {
        HStack(spacing: 12) {
            
            NavigationLink(destination: ProfileView()) {
                ZStack {
                    Circle()
                        .fill(Color.white.opacity(0.25))
                        .frame(width: 44, height: 44)
                    Image(systemName: "person.circle")
                        .font(.system(size: 24))
                        .foregroundColor(.black.opacity(0.6))
                }
            }
            
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.black)
                Text("Search")
                    .foregroundColor(.black.opacity(0.6))
                Spacer()
                Image(systemName: "mic.fill")
                    .foregroundColor(.black.opacity(0.6))
            }
            .padding(10)
            .background(Color(.systemGray6))
            .cornerRadius(20)
            
            ZStack {
                Circle()
                    .fill(Color.white.opacity(0.25))
                    .frame(width: 36, height: 36)
                Image(systemName: "bell")
                    .font(.system(size: 18))
                    .foregroundColor(.black.opacity(0.6))
            }
        }
        .foregroundColor(.black)
    }
}

#Preview {
    NavigationStack {
        HeaderView()
            .padding()
    }
}
