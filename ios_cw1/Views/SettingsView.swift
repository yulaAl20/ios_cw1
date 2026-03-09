//
//  SettingsView.swift
//  ios_cw1
//
//  Created by COBSCCOMP242P-74 on 2026-03-07.
//

import SwiftUI

struct SettingsView: View {
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Button(action: { dismiss() }) {
                    Image(systemName: "chevron.left")
                        .font(.title2)
                        .foregroundColor(.primary)
                }
                Spacer()
                Text("Settings")
                    .font(.headline)
                    .fontWeight(.semibold)
                Spacer()
                Color.clear.frame(width: 44, height: 44)
            }
            .padding(.horizontal, 24)
            .padding(.top, 16)
            .padding(.bottom, 8)
            
            // Placeholder content
            VStack {
                Text("Settings Screen")
                    .font(.largeTitle)
                    .foregroundColor(.gray)
            }
            .frame(maxHeight: .infinity)
        }
        .navigationBarHidden(true)
    }
}

#Preview {
    NavigationStack {
        SettingsView()
    }
}
