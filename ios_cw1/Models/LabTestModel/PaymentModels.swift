//
//  PaymentModels.swift
//  ios_cw1
//
//  Created by Yulani Alwis on 2026-03-08.
//

import Foundation

enum PaymentMethod: String, CaseIterable {
    case applePay = "Apple Pay"
    case card = "Credit/Debit Card"
    case counter = "Pay at Counter"
}

struct SavedCard: Identifiable {
    let id = UUID()
    let lastFourDigits: String
    let cardType: String // Visa, Mastercard, etc.
    let expiryDate: String
}
