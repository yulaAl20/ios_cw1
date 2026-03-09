//
//  Doctor.swift
//  ios_cw1
//
//  Created by COBSCCOMP242P-74 on 2026-03-04.
//

import Foundation

struct Doctor: Identifiable {
    let id = UUID()
    let firstName: String
    let lastName: String
    let degree: String
    let specialty: String
    let rating: Double
    let imageName: String?
    let availableTime: String
    let specialtyType: SpecialtyType
    let experience: String
    let patients: String
    let reviews: String
    let fee: Double
    let timeSlots: [String]
    let bio: String
    let availability: String

    var fullName: String {
        "\(firstName) \(lastName)"
    }
}

enum SpecialtyType: String, CaseIterable {
    case all = "All Specialists"
    case general = "General"
    case cardiology = "Cardiology"
    case gynecologist = "Gynecologist"
    case dentist = "Dentist"
    case dermatologist = "Dermatologist"
    case pediatrician = "Pediatrician"
}
