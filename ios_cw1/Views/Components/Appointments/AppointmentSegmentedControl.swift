//
//  AppointmentsView.swift
//  ios_cw1
//
//  Created by COBSCCOMP242P-74 on 2026-03-11.
//

import SwiftUI

struct AppointmentSegmentedControl: View {
    @Binding var selectedTab: String
    let tabs = ["Upcoming", "Ongoing", "Completed"]

    var body: some View {
        HStack(spacing: 0) {
            ForEach(tabs, id: \.self) { tab in
                Button(action: {
                    withAnimation(.easeInOut(duration: 0.2)) {
                        selectedTab = tab
                    }
                }) {
                    Text(tab)
                        .font(.system(size: 14, weight: selectedTab == tab ? .semibold : .regular))
                        .foregroundColor(selectedTab == tab ? .black : Color(.systemGray))
                        .padding(.vertical, 10)
                        .frame(maxWidth: .infinity)
                        .background(
                            ZStack {
                                if selectedTab == tab {
                                    RoundedRectangle(cornerRadius: 10)
                                        .fill(Color.white)
                                        .shadow(color: .black.opacity(0.12), radius: 4, x: 0, y: 2)
                                }
                            }
                        )
                }
                .buttonStyle(.plain)
            }
        }
        .padding(4)
        .background(Color(.systemGray6))
        .cornerRadius(13)
    }
}

#Preview {
    AppointmentSegmentedControl(selectedTab: .constant("Upcoming"))
        .padding()
}
