//
//  AccessibilityViewModel.swift
//  ios_cw1
//
//  Created by Yulani Alwis on 2026-03-13.
//

import SwiftUI
import Combine

enum ColorBlindMode: String, CaseIterable, Identifiable {
    case none         = "None"
    case deuteranopia = "Deuteranopia (Red-Green)"
    case protanopia   = "Protanopia (Red-Green, Alt)"
    case tritanopia   = "Tritanopia (Blue-Yellow)"

    var id: String { rawValue }
}

class AccessibilityViewModel: ObservableObject {

    @AppStorage("a11y_highContrast")   var isHighContrastEnabled:    Bool = false
    @AppStorage("a11y_reduceMotion")   var isReduceMotionEnabled:    Bool = false
    @AppStorage("a11y_wheelchair")     var isWheelchairModeEnabled:  Bool = false
    @AppStorage("a11y_deaf")          var isDeafModeEnabled:         Bool = false
    @AppStorage("a11y_largerText")     var isLargerTextEnabled:      Bool = false
    @AppStorage("a11y_colorBlindRaw")  private var colorBlindRaw:    String = ColorBlindMode.none.rawValue

    var colorBlindMode: ColorBlindMode {
        get { ColorBlindMode(rawValue: colorBlindRaw) ?? .none }
        set {
            objectWillChange.send()
            colorBlindRaw = newValue.rawValue
        }
    }

    var isColorBlindModeActive: Bool { colorBlindMode != .none }

    var minimumTapTarget: CGFloat { isWheelchairModeEnabled || isLargerTextEnabled ? 56 : 44 }

    var primaryBodySize: CGFloat    { isLargerTextEnabled ? 18 : 16 }
    var primaryCaptionSize: CGFloat { isLargerTextEnabled ? 14 : 11 }
    var primaryHeadlineSize: CGFloat { isLargerTextEnabled ? 20 : 17 }

    func shouldAnimate(systemReduced: Bool) -> Bool {
        !isReduceMotionEnabled && !systemReduced
    }

    func accessibleColor(normal: Color, highContrast: Color) -> Color {
        isHighContrastEnabled ? highContrast : normal
    }

    func busyLevelLabel(for level: Double) -> String {
        switch level {
        case ..<0.4:  return "Low"
        case 0.4..<0.7: return "Moderate"
        default:      return "Busy"
        }
    }

    func busyLevelColor(for level: Double) -> Color {
        if isColorBlindModeActive {
            switch colorBlindMode {
            case .tritanopia:
                switch level {
                case ..<0.4:  return Color(hex: "E69F00")
                case 0.4..<0.7: return Color(hex: "CC79A7")
                default:      return Color(hex: "000000")
                }
            default:
                switch level {
                case ..<0.4:  return Color(hex: "0072B2")
                case 0.4..<0.7: return Color(hex: "E69F00")
                default:      return Color(hex: "000000")
                }
            }
        }
        switch level {
        case ..<0.4:  return .green
        case 0.4..<0.7: return .orange
        default:      return .red
        }
    }
}
