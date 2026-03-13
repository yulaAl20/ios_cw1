//
//  SettingsView.swift
//  ios_cw1
//
//  Created by COBSCCOMP242P-74 on 2026-03-07.
//

import SwiftUI

struct SettingsView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var accessibilityVM: AccessibilityViewModel

    var body: some View {
        VStack(spacing: 0) {
            // Header
            HStack {
                Button(action: { dismiss() }) {
                    Image(systemName: "chevron.left")
                        .font(.title2)
                        .foregroundColor(.primary)
                }
                .accessibilityLabel("Back")
                .accessibilityHint("Returns to previous screen")
                Spacer()
                Text("Accessibility Settings")
                    .font(.headline)
                    .fontWeight(.semibold)
                Spacer()
                Color.clear.frame(width: 44, height: 44)
            }
            .padding(.horizontal, 24)
            .padding(.top, 16)
            .padding(.bottom, 8)

            ScrollView {
                VStack(spacing: 28) {

                    // Vision
                    SettingsSection(
                        icon: "eye.fill",
                        iconColor: .blue,
                        title: "Vision"
                    ) {
                        SettingsToggleRow(
                            title: "High Contrast",
                            subtitle: "Increases contrast on backgrounds and text for better readability",
                            systemImage: "circle.lefthalf.filled",
                            isOn: $accessibilityVM.isHighContrastEnabled
                        )

                        Divider().padding(.leading, 48)

                        SettingsToggleRow(
                            title: "Larger Text",
                            subtitle: "Increases text size throughout the app",
                            systemImage: "textformat.size",
                            isOn: $accessibilityVM.isLargerTextEnabled
                        )

                        Divider().padding(.leading, 48)

                        VStack(alignment: .leading, spacing: 10) {
                            HStack(spacing: 12) {
                                Image(systemName: "paintpalette.fill")
                                    .font(.system(size: 18))
                                    .foregroundColor(.purple)
                                    .frame(width: 28)

                                VStack(alignment: .leading, spacing: 2) {
                                    Text("Color Blind Mode")
                                        .font(.system(size: 16, weight: .medium))
                                    Text("Adjusts chart and indicator colors to be distinguishable without relying on red-green differences")
                                        .font(.caption)
                                        .foregroundColor(.gray)
                                }
                            }

                            Picker("Color Blind Mode", selection: Binding(
                                get: { accessibilityVM.colorBlindMode },
                                set: { accessibilityVM.colorBlindMode = $0 }
                            )) {
                                ForEach(ColorBlindMode.allCases) { mode in
                                    Text(mode.rawValue).tag(mode)
                                }
                            }
                            .pickerStyle(.menu)
                            .padding(.leading, 40)
                            .accessibilityLabel("Color blind mode selector")
                            .accessibilityHint("Choose the type of color vision difference to accommodate")
                        }
                    }

                    //  Motion
                    SettingsSection(
                        icon: "hand.raised.fill",
                        iconColor: .orange,
                        title: "Motion & Animation"
                    ) {
                        SettingsToggleRow(
                            title: "Reduce Motion",
                            subtitle: "Disables pulsing animations and transitions that may cause discomfort",
                            systemImage: "circle.dotted",
                            isOn: $accessibilityVM.isReduceMotionEnabled
                        )
                    }

                    //  Mobility
                    SettingsSection(
                        icon: "figure.roll",
                        iconColor: .green,
                        title: "Mobility & Motor"
                    ) {
                        SettingsToggleRow(
                            title: "Wheelchair Mode",
                            subtitle: "Navigation routes will prefer elevators, ramps, and step-free paths",
                            systemImage: "figure.roll",
                            isOn: $accessibilityVM.isWheelchairModeEnabled
                        )

                        Divider().padding(.leading, 48)

                        // Informational row about VoiceOver / Switch Control
                        HStack(spacing: 12) {
                            Image(systemName: "switch.2")
                                .font(.system(size: 18))
                                .foregroundColor(.teal)
                                .frame(width: 28)
                            VStack(alignment: .leading, spacing: 2) {
                                Text("Switch Control & VoiceOver")
                                    .font(.system(size: 16, weight: .medium))
                                Text("All interactive elements have accessibility labels and hints compatible with VoiceOver and Switch Control")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                                Button("Open iOS Accessibility Settings") {
                                    if let url = URL(string: UIApplication.openSettingsURLString) {
                                        UIApplication.shared.open(url)
                                    }
                                }
                                .font(.caption)
                                .foregroundColor(.blue)
                                .padding(.top, 4)
                            }
                        }
                    }

                    // Hearing
                    SettingsSection(
                        icon: "ear.trianglebadge.exclamationmark",
                        iconColor: .red,
                        title: "Hearing"
                    ) {
                        SettingsToggleRow(
                            title: "Deaf / Hard of Hearing Mode",
                            subtitle: "Queue alerts and appointment updates are shown as visual banners in addition to sound",
                            systemImage: "bell.badge.fill",
                            isOn: $accessibilityVM.isDeafModeEnabled
                        )

                        if accessibilityVM.isDeafModeEnabled {
                            HStack(spacing: 10) {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundColor(.green)
                                Text("Visual alerts are active. On-screen banners will appear for all important updates.")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                            }
                            .padding(.horizontal, 16)
                            .padding(.bottom, 8)
                            .transition(.opacity)
                        }
                    }

                    // Preview indicator
                    if accessibilityVM.isHighContrastEnabled || accessibilityVM.isLargerTextEnabled {
                        HStack(spacing: 8) {
                            Image(systemName: "info.circle.fill")
                                .foregroundColor(.blue)
                            Text("Changes take effect immediately across the app.")
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                        .padding(.horizontal, 24)
                        .padding(.bottom, 12)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 16)
            }
        }
        .navigationBarHidden(true)
        .animation(.easeInOut(duration: 0.2), value: accessibilityVM.isDeafModeEnabled)
    }
}

// Reusable Section Container
struct SettingsSection<Content: View>: View {
    let icon: String
    let iconColor: Color
    let title: String
    @ViewBuilder var content: Content

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack(spacing: 8) {
                Image(systemName: icon)
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(iconColor)
                Text(title.uppercased())
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundColor(.gray)
            }
            .padding(.horizontal, 4)
            .padding(.bottom, 8)
            .accessibilityAddTraits(.isHeader)

            VStack(spacing: 0) {
                content
            }
            .background(Color(.systemBackground))
            .cornerRadius(14)
            .shadow(color: .black.opacity(0.06), radius: 6, x: 0, y: 2)
        }
    }
}

// Reusable Toggle Row
struct SettingsToggleRow: View {
    let title: String
    let subtitle: String
    let systemImage: String
    @Binding var isOn: Bool

    var body: some View {
        Toggle(isOn: $isOn) {
            HStack(spacing: 12) {
                Image(systemName: systemImage)
                    .font(.system(size: 18))
                    .foregroundColor(.accentColor)
                    .frame(width: 28)

                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .font(.system(size: 16, weight: .medium))
                    Text(subtitle)
                        .font(.caption)
                        .foregroundColor(.gray)
                }
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .accessibilityLabel(title)
        .accessibilityHint(subtitle)
        .accessibilityValue(isOn ? "On" : "Off")
    }
}

#Preview {
    NavigationStack {
        SettingsView()
            .environmentObject(AccessibilityViewModel())
    }
}
