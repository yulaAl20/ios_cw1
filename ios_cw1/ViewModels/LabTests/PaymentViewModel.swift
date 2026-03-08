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
    
    // Payment Details
    let totalPrice: Double
    
    // Payment State
    @Published var selectedPaymentMethod: PaymentMethod = .card
    @Published var isProcessing: Bool = false
    @Published var paymentSuccess: Bool = false
    
    // Card Management
    @Published var savedCards: [SavedCard] = []
    @Published var selectedCard: SavedCard? = nil
    
    // Sheet States
    @Published var showAddCardSheet: Bool = false
    @Published var showApplePayPrompt: Bool = false
    
    // Computed Properties
    var labVisitFee: Double { 0.0 }
    var discount: Double { 0.0 }
    var totalAmount: Double { totalPrice + labVisitFee - discount }
    
    // Generate unique receipt number
    private var _receiptNumber: String?
    var receiptNumber: String {
        if _receiptNumber == nil {
            let prefix = "RCP"
            let timestamp = Int(Date().timeIntervalSince1970) % 1000000
            let random = Int.random(in: 100...999)
            _receiptNumber = "\(prefix)-\(timestamp)-\(random)"
        }
        return _receiptNumber!
    }
    
    var canProceed: Bool {
        switch selectedPaymentMethod {
        case .applePay:
            return true
        case .card:
            return !savedCards.isEmpty && selectedCard != nil
        case .counter:
            return true
        }
    }
    
    // Initializer
    init(totalPrice: Double) {
        self.totalPrice = totalPrice
    }
    
    //  Actions
    
    func handlePayment() {
        switch selectedPaymentMethod {
        case .applePay:
            showApplePayPrompt = true
        case .card:
            processPayment()
        case .counter:
            processPayment()
        }
    }
    
    func processPayment() {
        isProcessing = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) { [weak self] in
            self?.isProcessing = false
            withAnimation {
                self?.paymentSuccess = true
            }
        }
    }
    
    func addCard(_ card: SavedCard, saveForFuture: Bool) {
        if saveForFuture {
            savedCards.append(card)
        }
        selectedCard = card
    }
    
    //  QR Code Generation
    
    func generatePaymentQRCode() -> UIImage? {
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
        let filter = CIFilter.qrCodeGenerator()
        filter.message = Data(qrData.utf8)
        filter.correctionLevel = "M"
        
        if let outputImage = filter.outputImage {
            let transform = CGAffineTransform(scaleX: 10, y: 10)
            let scaledImage = outputImage.transformed(by: transform)
            
            if let cgImage = context.createCGImage(scaledImage, from: scaledImage.extent) {
                return UIImage(cgImage: cgImage)
            }
        }
        return nil
    }
}
