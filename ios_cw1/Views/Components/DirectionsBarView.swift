//
//  DirectionsBarView.swift
//  ios_cw1
//
//  Created by Yulani Alwis on 2026-03-03.
//

import SwiftUI

struct DirectionsBarView: View {

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: "paperplane.fill")
                .font(.system(size: 18))
                .foregroundColor(.white)
                .padding(10)
                .background(Color(#colorLiteral(red: 0.07, green: 0.39, blue: 0.64, alpha: 1)))
                .clipShape(Circle())

            VStack(alignment: .leading, spacing: 1) {
                Text("Need directions?")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.white)
                Text("Find your way inside the clinic")
                    .font(.system(size: 11))
                    .foregroundColor(.white.opacity(0.8))
            }

            Spacer()

            Image(systemName: "arrow.right")
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(.white.opacity(0.9))
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(Color.black.opacity(0.82))
        .cornerRadius(20)
        .shadow(radius: 8)
    }
}

#Preview {
    DirectionsBarView()
        .padding()
}
