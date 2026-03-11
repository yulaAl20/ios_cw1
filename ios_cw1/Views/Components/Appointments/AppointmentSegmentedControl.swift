//
//  AppointmentsView.swift
//  ios_cw1
//
//  Created by COBSCCOMP242P-74 on 2026-03-11.
//

//
//  AppointmentSegmentedControl.swift
//  ios_cw1
//

import SwiftUI

struct AppointmentSegmentedControl: View {
    @Binding var selectedTab: String
    let tabs = ["Upcoming", "Ongoing", "Completed"]

    @Namespace private var animation

    var body: some View {
        HStack(spacing: 0) {
            ForEach(tabs, id: \.self) { tab in
                Button(action: {
                    withAnimation(.spring(response: 0.4, dampingFraction: 0.75, blendDuration: 0)) {
                        selectedTab = tab
                    }
                }) {
                    ZStack {
                        // Sliding glass pill
                        if selectedTab == tab {
                            RoundedRectangle(cornerRadius: 11)
                                .fill(.regularMaterial)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 11)
                                        .fill(
                                            LinearGradient(
                                                colors: [
                                                    Color.white.opacity(0.55),
                                                    Color.white.opacity(0.15)
                                                ],
                                                startPoint: .topLeading,
                                                endPoint: .bottomTrailing
                                            )
                                        )
                                )
                                .overlay(
                                    RoundedRectangle(cornerRadius: 11)
                                        .stroke(
                                            LinearGradient(
                                                colors: [
                                                    Color.white.opacity(0.8),
                                                    Color.white.opacity(0.2)
                                                ],
                                                startPoint: .topLeading,
                                                endPoint: .bottomTrailing
                                            ),
                                            lineWidth: 1
                                        )
                                )
                                .shadow(color: Color.black.opacity(0.10), radius: 8, x: 0, y: 4)
                                .shadow(color: Color.white.opacity(0.6), radius: 2, x: 0, y: -1)
                                .matchedGeometryEffect(id: "pill", in: animation)
                        }

                        // Label
                        Text(tab)
                            .font(.system(size: 13.5, weight: selectedTab == tab ? .semibold : .medium))
                            .foregroundStyle(
                                selectedTab == tab
                                    ? AnyShapeStyle(Color.primary)
                                    : AnyShapeStyle(Color.secondary.opacity(0.8))
                            )
                            .padding(.vertical, 9)
                            .frame(maxWidth: .infinity)
                    }
                }
                .buttonStyle(.plain)
            }
        }
        .padding(4)
        .background(
            ZStack {
                RoundedRectangle(cornerRadius: 15)
                    .fill(.ultraThinMaterial)

                RoundedRectangle(cornerRadius: 15)
                    .fill(
                        LinearGradient(
                            colors: [
                                Color.white.opacity(0.18),
                                Color.white.opacity(0.04)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )

                RoundedRectangle(cornerRadius: 15)
                    .stroke(
                        LinearGradient(
                            colors: [
                                Color.white.opacity(0.55),
                                Color.white.opacity(0.1),
                                Color.clear
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: 1
                    )
            }
        )
    }
}

#Preview {
    struct PreviewWrapper: View {
        @State private var selected = "Upcoming"
        var body: some View {
            ZStack {
                LinearGradient(
                    colors: [
                        Color(red: 0.55, green: 0.78, blue: 1.0),
                        Color(red: 0.38, green: 0.58, blue: 0.95),
                        Color(red: 0.25, green: 0.40, blue: 0.82)
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()

                Circle()
                    .fill(Color.white.opacity(0.3))
                    .frame(width: 180, height: 180)
                    .offset(x: -80, y: -60)
                Circle()
                    .fill(Color.blue.opacity(0.4))
                    .frame(width: 120, height: 120)
                    .offset(x: 100, y: 40)

                VStack(spacing: 32) {
                    AppointmentSegmentedControl(selectedTab: $selected)
                        .padding(.horizontal, 20)
                    Text("Selected: \(selected)")
                        .font(.system(size: 15, weight: .medium))
                        .foregroundColor(.white)
                }
            }
        }
    }
    return PreviewWrapper()
}
