//
//  PaymentModels.swift
//  ios_cw1
//
//  Created by Yulani Alwis on 2026-03-08.
//

import Foundation

enum PaymentMethod: String, CaseIterable {
    case applePay = "Apple Pay"
    case card     = "Credit/Debit Card"
    case counter  = "Pay at Counter"
}

struct SavedCard: Identifiable, Codable, Equatable {
    let id: UUID
    let lastFourDigits: String
    let cardType: String
    let expiryDate: String
    let cardholderName: String

    init(
        id: UUID = UUID(),
        lastFourDigits: String,
        cardType: String,
        expiryDate: String,
        cardholderName: String = ""
    ) {
        self.id             = id
        self.lastFourDigits = lastFourDigits
        self.cardType       = cardType
        self.expiryDate     = expiryDate
        self.cardholderName = cardholderName
    }

    var displayName: String {
        cardholderName.isEmpty ? "•••• \(lastFourDigits)" : cardholderName
    }
}
