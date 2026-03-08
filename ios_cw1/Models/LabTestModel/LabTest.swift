//
//  LabTest.swift
//  ios_cw1
//
//  Created by Yulani Alwis on 2026-03-07.
//
import Foundation

enum TestCategory: String, CaseIterable, Identifiable, Codable {
    case all = "All"
    case blood = "Blood Tests"
    case urine = "Urine"
    case radiology = "Radiology"
    case pharmacy = "Pharmacy"
    
    var id: String { rawValue }
}

struct LabTest: Identifiable {
    let id = UUID()
    let name: String
    let description: String
    let price: Double
    let category: TestCategory
}
