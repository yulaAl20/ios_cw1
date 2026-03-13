//
//  PeakTimeIndicator.swift
//  ios_cw1
//
//  Created by COBSCCOMP242P-74 on 2026-03-04.
//

import SwiftUI

struct PeakTimeIndicator: View {
    @EnvironmentObject var accessibilityVM: AccessibilityViewModel

    let busyLevels: [Double] = [0.3, 0.5, 0.85, 0.95, 0.9, 0.7, 0.45, 0.25, 0.2]
    let times = ["10", "11", "12", "1", "2", "3", "4", "5", "6"]

    private let maxBarHeight: CGFloat = 70
    private let barWidth:     CGFloat = 3

    private var fullAccessibilityDescription: String {
        let busyTimes = zip(times, busyLevels)
            .filter { $0.1 >= 0.7 }
            .map { "\($0.0) o'clock" }
        let quietTimes = zip(times, busyLevels)
            .filter { $0.1 < 0.4 }
            .map { "\($0.0) o'clock" }
        let busyStr  = busyTimes.isEmpty  ? "none" : busyTimes.joined(separator: ", ")
        let quietStr = quietTimes.isEmpty ? "none" : quietTimes.joined(separator: ", ")
        return "Peak hours chart for today. Busy times: \(busyStr). Quiet times: \(quietStr)."
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("Peak Hours Today")
                .font(.headline)
                .fontWeight(.semibold)
                .padding(.horizontal, 20)
                .padding(.top, 16)
                .padding(.bottom, 12)
                .accessibilityAddTraits(.isHeader)

            VStack(spacing: 12) {
                HStack(alignment: .bottom, spacing: 0) {
                    ForEach(0..<times.count, id: \.self) { i in
                        VStack(spacing: 4) {
                            // Colorblind pattern symbol above bar
                            if accessibilityVM.isColorBlindModeActive || accessibilityVM.isHighContrastEnabled {
                                Text(patternSymbol(for: busyLevels[i]))
                                    .font(.system(size: 8))
                                    .foregroundColor(.primary)
                            }

                            Spacer(minLength: 0)

                            RoundedRectangle(cornerRadius: 1.5)
                                .fill(accessibilityVM.busyLevelColor(for: busyLevels[i]))
                                .frame(width: barWidth)
                                .frame(height: CGFloat(busyLevels[i]) * maxBarHeight)

                            Text(times[i])
                                .font(.system(size: 10, weight: .medium, design: .monospaced))
                                .foregroundColor(.gray)
                                .frame(width: 24, alignment: .center)
                        }
                        .frame(maxWidth: .infinity, maxHeight: maxBarHeight + (accessibilityVM.isColorBlindModeActive ? 48 : 34))
                    }
                }
                .padding(.horizontal, 12)

                // Legend — always includes text, not just color
                HStack(spacing: 16) {
                    legendItem(color: accessibilityVM.busyLevelColor(for: 0.2),
                               symbol: patternSymbol(for: 0.2),
                               label: "Low")
                    legendItem(color: accessibilityVM.busyLevelColor(for: 0.55),
                               symbol: patternSymbol(for: 0.55),
                               label: "Moderate")
                    legendItem(color: accessibilityVM.busyLevelColor(for: 0.9),
                               symbol: patternSymbol(for: 0.9),
                               label: "Busy")
                }
                .padding(.horizontal, 16)
                .padding(.bottom, 12)
            }
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color(.systemBackground))
                    .shadow(color: .black.opacity(0.08), radius: 8, x: 0, y: 2)
            )
            .padding(.horizontal, 20)
        }
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(fullAccessibilityDescription)
    }

    private func legendItem(color: Color, symbol: String, label: String) -> some View {
        HStack(spacing: 4) {
            if accessibilityVM.isColorBlindModeActive || accessibilityVM.isHighContrastEnabled {
                Text(symbol)
                    .font(.system(size: 10))
            } else {
                RoundedRectangle(cornerRadius: 2)
                    .fill(color)
                    .frame(width: 10, height: 10)
            }
            Text(label)
                .font(.caption2)
                .foregroundColor(.gray)
        }
    }

    private func patternSymbol(for level: Double) -> String {
        switch level {
        case ..<0.4:    return "▁"
        case 0.4..<0.7: return "▄"
        default:        return "█"
        }
    }
}

#Preview {
    PeakTimeIndicator()
        .padding(.vertical)
        .background(Color(.systemGroupedBackground))
        .environmentObject(AccessibilityViewModel())
}
