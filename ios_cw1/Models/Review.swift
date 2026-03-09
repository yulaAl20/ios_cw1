//
//  DoctorHeader.swift
//  ios_cw1
//
//  Created by COBSCCOMP242P-74 on 2026-03-04.
//

import Foundation

struct Review: Identifiable {
    let id = UUID()
    let author: String
    let date: String
    let rating: Double
    let comment: String
}
