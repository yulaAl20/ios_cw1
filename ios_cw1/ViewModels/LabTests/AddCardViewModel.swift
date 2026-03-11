//
//  AddCardViewModel.swift
//  ios_cw1
//
//  Created by Yulani Alwis on 2026-03-08.
//

import Foundation
import SwiftUI
import Combine

class AddCardViewModel: ObservableObject {

    @Published var cardNumber: String      = ""
    @Published var cardholderName: String  = ""
    @Published var expiryDate: String      = ""
    @Published var cvv: String             = ""
    @Published var saveCard: Bool          = true
    @Published var isProcessing: Bool      = false

    var cardType: String {
        let trimmed = cardNumber.replacingOccurrences(of: " ", with: "")
        if trimmed.hasPrefix("4")                         { return "Visa"       }
        if trimmed.hasPrefix("5") || trimmed.hasPrefix("2") { return "Mastercard" }
        if trimmed.hasPrefix("3")                         { return "Amex"       }
        return "Card"
    }

    var cardTypeIcon: String {
        switch cardType {
        case "Visa":       return "v.circle.fill"
        case "Mastercard": return "m.circle.fill"
        case "Amex":       return "a.circle.fill"
        default:           return "creditcard.fill"
        }
    }

    var isFormValid: Bool {
        let cardClean = cardNumber.replacingOccurrences(of: " ", with: "")

        guard cardClean.count >= 15,
              !cardholderName.isEmpty,
              cardholderName.count >= 3,
              expiryDate.count == 5,
              cvv.count >= 3 else { return false }

        let components = expiryDate.split(separator: "/")
        guard components.count == 2,
              let month = Int(components[0]),
              let year  = Int(components[1]),
              month >= 1, month <= 12 else { return false }

        let currentYear = 26
        let currentMonth = 3
        if year < currentYear || (year == currentYear && month < currentMonth) { return false }

        return true
    }

    var lastFourDigits: String {
        String(cardNumber.replacingOccurrences(of: " ", with: "").suffix(4))
    }

    // MARK: - Formatting Helpers

    func formatCardNumber(_ number: String) -> String {
        let cleaned = number.replacingOccurrences(of: " ", with: "")
        var formatted = ""
        for (i, ch) in cleaned.enumerated() {
            if i > 0 && i % 4 == 0 { formatted += " " }
            formatted += String(ch)
        }
        return formatted
    }

    func formatCardNumberInput(_ input: String) -> String {
        let cleaned = input.replacingOccurrences(of: " ", with: "").prefix(16)
        var formatted = ""
        for (i, ch) in cleaned.enumerated() {
            if i > 0 && i % 4 == 0 { formatted += " " }
            formatted += String(ch)
        }
        return formatted
    }

    func formatExpiryDate(_ input: String) -> String {
        let cleaned = input.replacingOccurrences(of: "/", with: "").prefix(4)
        if cleaned.count > 2 {
            return "\(cleaned.prefix(2))/\(cleaned.suffix(cleaned.count - 2))"
        }
        return String(cleaned)
    }

    func limitCVV(_ input: String) -> String {
        input.count > 4 ? String(input.prefix(4)) : input
    }

    // MARK: - Card Creation

    func createCard() -> SavedCard {
        SavedCard(
            lastFourDigits: lastFourDigits,
            cardType: cardType,
            expiryDate: expiryDate,
            cardholderName: cardholderName
        )
    }

    func addCard(completion: @escaping (SavedCard, Bool) -> Void) {
        isProcessing = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            guard let self else { return }
            let card = self.createCard()
            self.isProcessing = false
            completion(card, self.saveCard)
        }
    }
}
