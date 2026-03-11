//
//  PharmacyViewModel.swift
//  ios_cw1
//
//  Created by Yulani Alwis on 2026-03-08.
//

import Foundation
import SwiftUI
import Combine
import CoreImage.CIFilterBuiltins

class PharmacyViewModel: ObservableObject {
    
    // Published Properties
    
    // Active Orders
    @Published var activeOrders: [PharmacyOrder] = []
    @Published var currentOrder: PharmacyOrder?
    
    // Cart
    @Published var cartItems: [OrderedMedicine] = []
    @Published var hasPrescription: Bool = false
    @Published var prescriptionImageData: Data?
    
    // Medicines
    @Published var medicines: [Medicine] = SampleMedicines.allOTCMedicines
    @Published var selectedCategory: MedicineCategory = .painRelief
    
    // UI State
    @Published var isLoading: Bool = false
    @Published var showOrderTracking: Bool = false
    @Published var showCart: Bool = false
    @Published var searchText: String = ""
    @Published var showPaymentSheet: Bool = false
    @Published var shouldPopToPharmacy: Bool = false
    
    // Hardcoded prescription medicines that will be "discovered" after pharmacist review
    static let hardcodedPrescriptionMeds: [OrderedMedicine] = [
        OrderedMedicine(medicine: SampleMedicines.prescriptionMedicines[0], quantity: 21),  // Amoxicillin
        OrderedMedicine(medicine: SampleMedicines.prescriptionMedicines[2], quantity: 28),  // Omeprazole
    ]
    
    // Computed Properties
    
    var cartTotal: Double {
        cartItems.reduce(0) { $0 + $1.subtotal }
    }
    
    var cartItemCount: Int {
        cartItems.reduce(0) { $0 + $1.quantity }
    }
    
    var filteredMedicines: [Medicine] {
        let categoryMedicines = SampleMedicines.medicines(for: selectedCategory)
        if searchText.isEmpty {
            return categoryMedicines
        }
        return categoryMedicines.filter {
            $0.name.localizedCaseInsensitiveContains(searchText) ||
            $0.genericName.localizedCaseInsensitiveContains(searchText)
        }
    }
    
    var hasActiveOrder: Bool {
        !activeOrders.isEmpty
    }
    
    // OTC Categories (excluding prescription)
    var otcCategories: [MedicineCategory] {
        [.painRelief, .coldAndFlu, .vitamins, .firstAid]
    }
    
    init() {
        // Load any saved orders or start fresh
    }
    
    // Cart Functions
    
    func addToCart(_ medicine: Medicine, quantity: Int = 1) {
        if let index = cartItems.firstIndex(where: { $0.medicine.id == medicine.id }) {
            cartItems[index].quantity += quantity
        } else {
            cartItems.append(OrderedMedicine(medicine: medicine, quantity: quantity))
        }
    }
    
    func removeFromCart(_ medicine: Medicine) {
        cartItems.removeAll { $0.medicine.id == medicine.id }
    }
    
    func updateQuantity(for medicine: Medicine, quantity: Int) {
        if let index = cartItems.firstIndex(where: { $0.medicine.id == medicine.id }) {
            if quantity <= 0 {
                cartItems.remove(at: index)
            } else {
                cartItems[index].quantity = quantity
            }
        }
    }
    
    func clearCart() {
        cartItems.removeAll()
        hasPrescription = false
        prescriptionImageData = nil
    }
    
    func getQuantityInCart(for medicine: Medicine) -> Int {
        cartItems.first(where: { $0.medicine.id == medicine.id })?.quantity ?? 0
    }
    
    // Prescription Functions
    
    func uploadPrescription(imageData: Data?) {
        self.prescriptionImageData = imageData
        self.hasPrescription = imageData != nil
    }
    
    // Submit prescription order (no payment yet - prescription needs to be reviewed first)
    func submitPrescriptionOrder() -> PharmacyOrder {
        let orderType: PharmacyOrderType
        if !cartItems.isEmpty {
            orderType = .mixed
        } else {
            orderType = .prescription
        }
        
        // Create order with OTC items only for now (prescription meds will be added after review)
        let order = PharmacyOrder(
            orderType: orderType,
            status: .prescriptionUploaded,
            prescriptionImageURL: "uploaded_prescription",
            medicines: cartItems,
            totalAmount: cartTotal,
            isPaid: false
        )
        
        activeOrders.insert(order, at: 0)
        currentOrder = order
        
        // Signal to pop back to pharmacy page
        shouldPopToPharmacy = true
        
        // Clear cart after a delay so the view pops before UI re-renders to empty state
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
            self?.cartItems.removeAll()
            self?.hasPrescription = false
            self?.prescriptionImageData = nil
        }
        
        // Start the prescription review simulation (10 seconds)
        simulatePrescriptionReview(order)
        
        return order
    }
    
    // Create OTC-only order (goes through normal payment flow)
    func createOrder(paymentMethod: PharmacyPaymentMethod) -> PharmacyOrder {
        let order = PharmacyOrder(
            orderType: .overTheCounter,
            status: .preparingMedicine,
            medicines: cartItems,
            paymentMethod: paymentMethod,
            totalAmount: cartTotal,
            isPaid: paymentMethod != .counter
        )
        
        activeOrders.insert(order, at: 0)
        currentOrder = order
        showOrderTracking = true
        
        // Clear cart after order
        clearCart()
        
        // Simulate OTC order progress
        simulateOTCProgress(order)
        
        return order
    }
    
    func createPrescriptionOnlyOrder() -> PharmacyOrder {
        return submitPrescriptionOrder()
    }
    
    // Prescription review simulation - after 10 seconds, pharmacist "reviews" the prescription
    // Adds hardcoded prescription medicines and updates total, then sets status to readyForPayment
    private func simulatePrescriptionReview(_ order: PharmacyOrder) {
        
        guard let index = activeOrders.firstIndex(where: { $0.id == order.id }) else { return }
        
        // After 3 seconds: set to under review
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) { [weak self] in
            self?.updateOrderStatus(at: index, to: .underReview)
        }
        
        // After 10 seconds: prescription reviewed - add prescription medicines and set ready for payment
        DispatchQueue.main.asyncAfter(deadline: .now() + 10) { [weak self] in
            guard let self = self, index < self.activeOrders.count else { return }
            
            // Add hardcoded prescription medicines to the order
            var updatedMedicines = self.activeOrders[index].medicines
            updatedMedicines.append(contentsOf: PharmacyViewModel.hardcodedPrescriptionMeds)
            self.activeOrders[index].medicines = updatedMedicines
            
            // Recalculate total with prescription medicines included
            let newTotal = updatedMedicines.reduce(0.0) { $0 + $1.subtotal }
            self.activeOrders[index].totalAmount = newTotal
            
            // Set status to ready for payment
            self.activeOrders[index].status = .readyForPayment
            self.activeOrders[index].updatedAt = Date()
            
            if self.currentOrder?.id == self.activeOrders[index].id {
                self.currentOrder = self.activeOrders[index]
            }
            
            // Show the payment sheet
            self.showPaymentSheet = true
        }
    }
    
    // OTC order progress simulation
    private func simulateOTCProgress(_ order: PharmacyOrder) {
        guard let index = activeOrders.firstIndex(where: { $0.id == order.id }) else { return }
        
        // After 5 seconds: ready for pickup
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) { [weak self] in
            guard let self = self, index < self.activeOrders.count else { return }
            self.activeOrders[index].status = .readyForPickup
            self.activeOrders[index].queueNumber = "Q-\(Int.random(in: 1...20))"
            self.activeOrders[index].counterNumber = 3
            self.activeOrders[index].updatedAt = Date()
            
            if self.currentOrder?.id == self.activeOrders[index].id {
                self.currentOrder = self.activeOrders[index]
            }
        }
    }
    
    private func updateOrderStatus(at index: Int, to status: PharmacyOrderStatus) {
        guard index < activeOrders.count else { return }
        activeOrders[index].status = status
        activeOrders[index].updatedAt = Date()
        
        if currentOrder?.id == activeOrders[index].id {
            currentOrder = activeOrders[index]
        }
    }
    
    // Complete payment for a prescription order, then simulate pickup ready after 10 seconds
    func completePayment(for order: PharmacyOrder, method: PharmacyPaymentMethod) {
        guard let index = activeOrders.firstIndex(where: { $0.id == order.id }) else { return }
        
        activeOrders[index].paymentMethod = method
        activeOrders[index].isPaid = true
        activeOrders[index].status = .paymentCompleted
        activeOrders[index].updatedAt = Date()
        
        if currentOrder?.id == order.id {
            currentOrder = activeOrders[index]
        }
        
        // After 10 seconds: order is ready for pickup at counter 3
        DispatchQueue.main.asyncAfter(deadline: .now() + 10) { [weak self] in
            guard let self = self, index < self.activeOrders.count else { return }
            self.activeOrders[index].status = .readyForPickup
            self.activeOrders[index].queueNumber = "Q-7"
            self.activeOrders[index].counterNumber = 3
            self.activeOrders[index].updatedAt = Date()
            
            if self.currentOrder?.id == self.activeOrders[index].id {
                self.currentOrder = self.activeOrders[index]
            }
        }
    }
    
    func cancelOrder(_ order: PharmacyOrder) {
        guard let index = activeOrders.firstIndex(where: { $0.id == order.id }) else { return }
        
        activeOrders[index].status = .cancelled
        activeOrders[index].updatedAt = Date()
        
        if currentOrder?.id == order.id {
            currentOrder = activeOrders[index]
        }
    }
    
    // QR Code Generation
    
    func generateQRCode(for order: PharmacyOrder) -> UIImage? {
        let qrData = order.qrCodeData
        
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
