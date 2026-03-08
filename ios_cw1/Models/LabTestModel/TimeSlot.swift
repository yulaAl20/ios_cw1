//
//  TimeSlot.swift
//  ios_cw1
//
//  Created by Yulani Alwis on 2026-03-08.
//

import Foundation

struct TimeSlot: Identifiable, Equatable {
    let id = UUID()
    let startTime: String
    let endTime: String
    
    var displayText: String {
        "\(startTime) - \(endTime)"
    }
}
