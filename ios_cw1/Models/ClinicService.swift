//
//  ClinicService.swift
//  ios_cw1
//
//  Created by Yulani Alwis on 2026-03-04.
//

import SwiftUI

struct ClinicService: Identifiable, Hashable, Sendable {
    let id: UUID
    let icon: String
    let title: String
    let subtitle: String
    let iconColorRed: Double
    let iconColorGreen: Double
    let iconColorBlue: Double
    let bgColorRed: Double
    let bgColorGreen: Double
    let bgColorBlue: Double
    
    var iconColor: Color {
        Color(red: iconColorRed, green: iconColorGreen, blue: iconColorBlue)
    }
    
    var iconBackground: Color {
        Color(red: bgColorRed, green: bgColorGreen, blue: bgColorBlue)
    }
    
    init(
        id: UUID = UUID(),
        icon: String,
        title: String,
        subtitle: String,
        iconColorRed: Double,
        iconColorGreen: Double,
        iconColorBlue: Double,
        bgColorRed: Double,
        bgColorGreen: Double,
        bgColorBlue: Double
    ) {
        self.id = id
        self.icon = icon
        self.title = title
        self.subtitle = subtitle
        self.iconColorRed = iconColorRed
        self.iconColorGreen = iconColorGreen
        self.iconColorBlue = iconColorBlue
        self.bgColorRed = bgColorRed
        self.bgColorGreen = bgColorGreen
        self.bgColorBlue = bgColorBlue
    }
}
