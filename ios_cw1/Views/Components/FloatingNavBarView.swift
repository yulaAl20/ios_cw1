//
//  FloatingNavBarView.swift
//  ios_cw1
//
//  Created by Yulani Alwis on 2026-03-03.
//

import SwiftUI

struct FloatingNavBarView: View {

    @Binding var selectedTab: Int

    private let selectorSize: CGFloat = 54

    var body: some View {
        ZStack {
            // Glass capsule background
            Capsule()
                .fill(.ultraThinMaterial)
                .overlay(
                    Capsule()
                        .stroke(Color.white.opacity(0.18), lineWidth: 1)
                )
                .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 4)

            // Nav items
            HStack(spacing: 0) {
                ForEach(0..<4, id: \.self) { index in
                    navItem(icon: navIcon(for: index),
                            label: navLabel(for: index),
                            index: index)
                        .background(
                            GeometryReader { geo in
                                Color.clear
                                    .preference(
                                        key: NavBarPreferenceKey.self,
                                        value: [index: geo.frame(in: .named("navBar"))]
                                    )
                            }
                        )
                }
            }
            .frame(maxWidth: .infinity)
            .coordinateSpace(name: "navBar")
            .overlayPreferenceValue(NavBarPreferenceKey.self) { prefs in
                GeometryReader { geo in
                    if let frame = prefs[selectedTab] {
                        Circle()
                            .fill(Color.white.opacity(0.15))
                            .overlay(
                                Circle()
                                    .stroke(
                                        LinearGradient(
                                            colors: [
                                                Color.white.opacity(0.8),
                                                Color.white.opacity(0.3)
                                            ],
                                            startPoint: .top,
                                            endPoint: .bottom
                                        ),
                                        lineWidth: 2
                                    )
                            )
                            .shadow(color: Color.white.opacity(0.4), radius: 6, x: 0, y: 0)
                            .shadow(color: Color.black.opacity(0.05), radius: 3, x: 0, y: 1)
                            .frame(width: selectorSize, height: selectorSize)
                            .position(x: frame.midX, y: geo.size.height / 2)
                            .animation(
                                .interactiveSpring(response: 0.4, dampingFraction: 0.7, blendDuration: 0.2),
                                value: selectedTab
                            )
                            .allowsHitTesting(false)
                    }
                }
            }
        }
        .frame(height: 70)
        .padding(.horizontal, 16)
    }


    private func navIcon(for index: Int) -> String {
        switch index {
        case 0: return "house.fill"
        case 1: return "square.grid.2x2.fill"
        case 2: return "calendar"
        case 3: return "location.fill"
        default: return "circle"
        }
    }

    private func navLabel(for index: Int) -> String {
        switch index {
        case 0: return "Home"
        case 1: return "Services"
        case 2: return "Appointments"
        case 3: return "Navigation"
        default: return ""
        }
    }

    private func navItem(icon: String, label: String, index: Int) -> some View {
        let isSelected = selectedTab == index

        return Button {
            withAnimation(.interactiveSpring(response: 0.4, dampingFraction: 0.7)) {
                selectedTab = index
            }
        } label: {
            VStack(spacing: 4) {
                Image(systemName: icon)
                    .font(.system(size: 20, weight: .medium))
                    .foregroundColor(isSelected ? Color(#colorLiteral(red: 0.0, green: 0.48, blue: 0.78, alpha: 1)) : .gray)
                    .scaleEffect(isSelected ? 1.1 : 1.0)
                    .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isSelected)
                Text(label)
                    .font(.system(size: 9, weight: isSelected ? .semibold : .regular))
                    .foregroundColor(isSelected ? Color(#colorLiteral(red: 0.0, green: 0.48, blue: 0.78, alpha: 1)) : .gray)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 8)
        }
    }
}

// MARK: - Preference Key

struct NavBarPreferenceKey: PreferenceKey {
    static var defaultValue: [Int: CGRect] = [:]
    static func reduce(value: inout [Int: CGRect], nextValue: () -> [Int: CGRect]) {
        value.merge(nextValue(), uniquingKeysWith: { $1 })
    }
}

#Preview {
    FloatingNavBarView(selectedTab: .constant(0))
}
