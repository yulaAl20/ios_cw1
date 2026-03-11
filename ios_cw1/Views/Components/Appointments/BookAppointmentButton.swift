//
//  Untitled.swift
//  ios_cw1
//
//  Created by COBSCCOMP242P-74 on 2026-03-11.
//

import SwiftUI

struct BookAppointmentButton: View {
    var body: some View {
        NavigationLink(destination: Text("Book New Appointment Screen")) {
            HStack(spacing: 8) {
                Image(systemName: "plus.circle.fill")
                    .font(.system(size: 18))
                Text("Book New Appointment")
                    .font(.system(size: 16, weight: .semibold))
            }
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 15)
            .background(
                LinearGradient(
                    colors: [Color(red: 0.18, green: 0.40, blue: 0.85),
                             Color(red: 0.12, green: 0.30, blue: 0.72)],
                    startPoint: .leading,
                    endPoint: .trailing
                )
            )
            .cornerRadius(14)
            .shadow(color: Color(red: 0.15, green: 0.35, blue: 0.75).opacity(0.35),
                    radius: 8, x: 0, y: 4)
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    BookAppointmentButton()
        .padding()
}
