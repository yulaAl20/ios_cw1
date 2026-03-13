//
//  PaymentViewModel.swift
//  ios_cw1
//
//  Created by Yulani Alwis on 2026-03-08.
//

import Foundation
import Combine
import SwiftUI
import CoreImage.CIFilterBuiltins

class PaymentViewModel: ObservableObject {

    // MARK: - Payment Info
    let totalPrice: Double

    // MARK: - Payment State
    @Published var selectedPaymentMethod: PaymentMethod = .card
    @Published var isProcessing: Bool   = false
    @Published var paymentSuccess: Bool = false

    // MARK: - Card Management
    @Published var savedCards: [SavedCard]  = []
    @Published var selectedCard: SavedCard? = nil

    // MARK: - Sheet States
    @Published var showAddCardSheet:    Bool = false
    @Published var showApplePayPrompt:  Bool = false

    // MARK: - Computed
    var labVisitFee: Double  { 0.0 }
    var discount: Double     { 0.0 }
    var totalAmount: Double  { totalPrice + labVisitFee - discount }

    let receiptNumber: String

    var canProceed: Bool {
        switch selectedPaymentMethod {
        case .applePay: return true
        case .card:     return !savedCards.isEmpty && selectedCard != nil
        case .counter:  return true
        }
    }

    // MARK: - Init

    init(totalPrice: Double) {
        self.totalPrice = totalPrice
        let prefix    = "RCP"
        let timestamp = Int(Date().timeIntervalSince1970) % 1_000_000
        let random    = Int.random(in: 100...999)
        self.receiptNumber = "\(prefix)-\(timestamp)-\(random)"

        // Pre-populate from the shared persistent card store
        let stored = CardStore.shared.savedCards
        self.savedCards  = stored
        self.selectedCard = stored.first
    }

    // MARK: - Actions

    func handlePayment() {
        switch selectedPaymentMethod {
        case .applePay: showApplePayPrompt = true
        case .card, .counter: processPayment()
        }
    }

    func processPayment() {
        isProcessing = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) { [weak self] in
            self?.isProcessing = false
            withAnimation { self?.paymentSuccess = true }
        }
    }

    /// Called by AddCardSheet callback.  When saveForFuture is true the card is
    /// persisted globally via CardStore so it appears in every payment flow and
    /// the Profile page.
    func addCard(_ card: SavedCard, saveForFuture: Bool) {
        if saveForFuture {
            CardStore.shared.addCard(card)
        }
        if !savedCards.contains(where: { $0.id == card.id }) {
            savedCards.append(card)
        }
        selectedCard = card
    }

    //- QR Code Generation

    /// Generate a QR code for a specific booking reference/receipt.
    /// This matches the QR style used in the payment success screens, but lets callers (like Appointments)
    /// display the QR later using the stored appointment token.
    func generatePaymentQRCode(from receipt: String) -> UIImage? {
        guard ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] != "1" else { return nil }

        let qrData = """
        {
            "type": "booking_reference",
            "receipt": "\(receipt)",
            "timestamp": "\(ISO8601DateFormatter().string(from: Date()))"
        }
        """

        let context = CIContext()
        let filter  = CIFilter.qrCodeGenerator()
        filter.message          = Data(qrData.utf8)
        filter.correctionLevel  = "M"

        if let outputImage = filter.outputImage {
            let scaled = outputImage.transformed(by: CGAffineTransform(scaleX: 10, y: 10))
            if let cgImage = context.createCGImage(scaled, from: scaled.extent) {
                return UIImage(cgImage: cgImage)
            }
        }
        return nil
    }

    func generatePaymentQRCode() -> UIImage? {
        guard ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] != "1" else { return nil }

        let qrData = """
        {
            "type": "lab_payment",
            "receipt": "\(receiptNumber)",
            "amount": \(totalAmount),
            "currency": "LKR",
            "status": "pending_payment",
            "timestamp": "\(ISO8601DateFormatter().string(from: Date()))"
        }
        """

        let context = CIContext()
        let filter  = CIFilter.qrCodeGenerator()
        filter.message          = Data(qrData.utf8)
        filter.correctionLevel  = "M"

        if let outputImage = filter.outputImage {
            let scaled = outputImage.transformed(by: CGAffineTransform(scaleX: 10, y: 10))
            if let cgImage = context.createCGImage(scaled, from: scaled.extent) {
                return UIImage(cgImage: cgImage)
            }
        }
        return nil
    }
}
