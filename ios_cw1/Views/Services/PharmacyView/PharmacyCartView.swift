//
//  PharmacyCartView.swift
//  ios_cw1
//
//  Created by Yulani Alwis on 2026-03-08.
//

import SwiftUI
import PhotosUI

struct PharmacyCartView: View {
    
    @ObservedObject var viewModel: PharmacyViewModel
    @Environment(\.dismiss) var dismiss
    
    @State private var showCheckout = false
    @State private var showPrescriptionUpload = false
    @State private var shouldDismissToRoot = false
    
    var body: some View {
        ZStack(alignment: .bottom) {
            VStack(spacing: 0) {
                // Header
                headerSection
                
                if viewModel.cartItems.isEmpty && !viewModel.hasPrescription {
                    emptyCartView
                } else {
                    ScrollView(showsIndicators: false) {
                        VStack(spacing: 16) {
                            // Prescription Section (if has prescription)
                            if viewModel.hasPrescription {
                                prescriptionSection
                            }
                            
                            // Add Prescription Option (if no prescription)
                            if !viewModel.hasPrescription {
                                addPrescriptionSection
                            }
                            
                            // Cart Items
                            if !viewModel.cartItems.isEmpty {
                                cartItemsSection
                            }
                            
                            // Add More Items
                            addMoreItemsSection
                            
                            Spacer().frame(height: 120)
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 16)
                    }
                }
            }
            .background(Color(.systemGroupedBackground))
            
            // Checkout Button
            if !viewModel.cartItems.isEmpty || viewModel.hasPrescription {
                checkoutButton
            }
        }
        .navigationBarHidden(true)
        .sheet(isPresented: $showCheckout) {
            PharmacyCheckoutSheet(viewModel: viewModel, isPresented: $showCheckout, shouldDismissToRoot: $shouldDismissToRoot)
                .presentationDetents([.large])
        }
        .sheet(isPresented: $showPrescriptionUpload) {
            PrescriptionUploadSheet(viewModel: viewModel, isPresented: $showPrescriptionUpload)
                .presentationDetents([.medium])
        }
        .onChange(of: shouldDismissToRoot) { _, newValue in
            if newValue {
                dismiss()
            }
        }
    }
}


// Header Section

extension PharmacyCartView {
    
    var headerSection: some View {
        HStack {
            Button(action: { dismiss() }) {
                Image(systemName: "chevron.left")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(.black)
            }
            
            Spacer()
            
            Text("Cart")
                .font(.system(size: 18, weight: .semibold))
            
            Spacer()
            
            if !viewModel.cartItems.isEmpty || viewModel.hasPrescription {
                Button("Clear") {
                    viewModel.clearCart()
                }
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(.red)
            } else {
                Color.clear.frame(width: 44)
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 12)
        .background(Color.white)
    }
}


// Empty Cart View

extension PharmacyCartView {
    
    var emptyCartView: some View {
        VStack(spacing: 20) {
            Spacer()
            
            Image(systemName: "cart")
                .font(.system(size: 60))
                .foregroundColor(.gray.opacity(0.5))
            
            Text("Your cart is empty")
                .font(.system(size: 20, weight: .semibold))
            
            Text("Add medicines or upload a prescription\nto get started")
                .font(.system(size: 14))
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
            
            VStack(spacing: 12) {
                Button(action: { showPrescriptionUpload = true }) {
                    HStack(spacing: 8) {
                        Image(systemName: "doc.text.fill")
                        Text("Upload Prescription")
                    }
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
                    .background(Color(red: 0.15, green: 0.35, blue: 0.75))
                    .cornerRadius(12)
                }
                
                Button(action: { dismiss() }) {
                    Text("Browse Medicines")
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundColor(Color(red: 0.15, green: 0.35, blue: 0.75))
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                        .background(Color(red: 0.15, green: 0.35, blue: 0.75).opacity(0.1))
                        .cornerRadius(12)
                }
            }
            .padding(.horizontal, 40)
            
            Spacer()
        }
    }
}


// Prescription Section

extension PharmacyCartView {
    
    var prescriptionSection: some View {
        VStack(spacing: 12) {
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Image(systemName: "doc.text.fill")
                        .foregroundColor(.green)
                    Text("Prescription Uploaded")
                        .font(.system(size: 16, weight: .semibold))
                    
                    Spacer()
                    
                    Button(action: {
                        viewModel.hasPrescription = false
                        viewModel.prescriptionImageData = nil
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.gray)
                    }
                }
                
                Text("Your prescription will be reviewed by our pharmacist. Medicines will be added after review.")
                    .font(.system(size: 13))
                    .foregroundColor(.gray)
            }
            .padding(16)
            .background(Color.green.opacity(0.1))
            .cornerRadius(12)
            
            // Add OTC Medicines button
            NavigationLink(destination: MedicineListView(viewModel: viewModel, initialCategory: .all)) {
                HStack(spacing: 12) {
                    Image(systemName: "pills.fill")
                        .font(.system(size: 16))
                        .foregroundColor(Color(red: 0.15, green: 0.35, blue: 0.75))
                    
                    Text("Add OTC Medicines")
                        .font(.system(size: 15, weight: .medium))
                        .foregroundColor(Color(red: 0.15, green: 0.35, blue: 0.75))
                    
                    Spacer()
                    
                    Image(systemName: "chevron.right")
                        .font(.system(size: 14))
                        .foregroundColor(.gray)
                }
                .padding(16)
                .background(Color.white)
                .cornerRadius(12)
            }
        }
    }
    
    var addPrescriptionSection: some View {
        Button(action: { showPrescriptionUpload = true }) {
            HStack(spacing: 12) {
                ZStack {
                    Circle()
                        .fill(Color(red: 0.90, green: 0.94, blue: 0.98))
                        .frame(width: 44, height: 44)
                    
                    Image(systemName: "doc.badge.plus")
                        .font(.system(size: 18))
                        .foregroundColor(Color(red: 0.15, green: 0.35, blue: 0.75))
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("Have a Prescription?")
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundColor(.black)
                    
                    Text("Upload it to order prescription medicines")
                        .font(.system(size: 13))
                        .foregroundColor(.gray)
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .foregroundColor(.gray)
            }
            .padding(16)
            .background(Color.white)
            .cornerRadius(12)
        }
    }
}


// Cart Items Section

extension PharmacyCartView {
    
    var cartItemsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Cart Items (\(viewModel.cartItemCount))")
                .font(.system(size: 16, weight: .semibold))
            
            ForEach(viewModel.cartItems) { item in
                CartItemRow(
                    item: item,
                    onUpdateQuantity: { qty in
                        viewModel.updateQuantity(for: item.medicine, quantity: qty)
                    },
                    onRemove: {
                        viewModel.removeFromCart(item.medicine)
                    }
                )
            }
        }
    }
}


// Add More Items Section

extension PharmacyCartView {
    
    var addMoreItemsSection: some View {
        NavigationLink(destination: MedicineListView(viewModel: viewModel, initialCategory: .all)) {
            HStack {
                Image(systemName: "plus.circle.fill")
                    .foregroundColor(Color(red: 0.15, green: 0.35, blue: 0.75))
                
                Text("Add more items")
                    .font(.system(size: 15, weight: .medium))
                    .foregroundColor(Color(red: 0.15, green: 0.35, blue: 0.75))
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 14))
                    .foregroundColor(.gray)
            }
            .padding(16)
            .background(Color.white)
            .cornerRadius(12)
        }
    }
}


// Checkout Button

extension PharmacyCartView {
    
    var checkoutButton: some View {
        VStack(spacing: 0) {
            Divider()
            
            VStack(spacing: 12) {
                // Summary
                if viewModel.cartTotal > 0 {
                    HStack {
                        Text("Subtotal")
                            .foregroundColor(.gray)
                        Spacer()
                        Text("LKR \(String(format: "%.2f", viewModel.cartTotal))")
                            .font(.system(size: 16, weight: .semibold))
                    }
                }
                
                // If prescription is uploaded: submit order (no payment) and go back to pharmacy
                // If OTC only: proceed to payment checkout
                if viewModel.hasPrescription {
                    Button(action: {
                        _ = viewModel.submitPrescriptionOrder()
                        dismiss()
                    }) {
                        HStack {
                            Text(viewModel.cartItems.isEmpty ? "Submit Prescription" : "Submit Order")
                                .font(.system(size: 17, weight: .semibold))
                        }
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(Color(red: 0.15, green: 0.35, blue: 0.75))
                        .cornerRadius(14)
                    }
                    
                    Text("Your prescription will be reviewed by our pharmacist. Payment will be requested after review.")
                        .font(.system(size: 12))
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.center)
                } else {
                    Button(action: { showCheckout = true }) {
                        HStack {
                            Text("Proceed to Checkout")
                                .font(.system(size: 17, weight: .semibold))
                        }
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(Color(red: 0.15, green: 0.35, blue: 0.75))
                        .cornerRadius(14)
                    }
                }
            }
            .padding(20)
            .background(Color.white)
        }
    }
}


// Cart Item Row

struct CartItemRow: View {
    let item: OrderedMedicine
    let onUpdateQuantity: (Int) -> Void
    let onRemove: () -> Void
    
    var body: some View {
        HStack(spacing: 12) {
            // Medicine Icon
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .fill(item.medicine.category.bgColor)
                    .frame(width: 50, height: 50)
                
                Image(systemName: item.medicine.category.icon)
                    .font(.system(size: 20))
                    .foregroundColor(item.medicine.category.iconColor)
            }
            
            // Medicine Info
            VStack(alignment: .leading, spacing: 4) {
                Text(item.medicine.name)
                    .font(.system(size: 15, weight: .medium))
                
                Text("LKR \(String(format: "%.2f", item.medicine.price))")
                    .font(.system(size: 13))
                    .foregroundColor(.gray)
            }
            
            Spacer()
            
            // Quantity Stepper
            HStack(spacing: 0) {
                Button(action: { onUpdateQuantity(item.quantity - 1) }) {
                    Image(systemName: "minus")
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundColor(Color(red: 0.15, green: 0.35, blue: 0.75))
                        .frame(width: 30, height: 30)
                        .background(Color(.systemGray6))
                }
                
                Text("\(item.quantity)")
                    .font(.system(size: 14, weight: .semibold))
                    .frame(width: 36)
                
                Button(action: { onUpdateQuantity(item.quantity + 1) }) {
                    Image(systemName: "plus")
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundColor(Color(red: 0.15, green: 0.35, blue: 0.75))
                        .frame(width: 30, height: 30)
                        .background(Color(.systemGray6))
                }
            }
            .cornerRadius(8)
            
            // Subtotal
            Text("LKR \(String(format: "%.0f", item.subtotal))")
                .font(.system(size: 14, weight: .semibold))
                .frame(width: 70, alignment: .trailing)
        }
        .padding(12)
        .background(Color.white)
        .cornerRadius(12)
    }
}


// Prescription Upload Sheet

struct PrescriptionUploadSheet: View {
    @ObservedObject var viewModel: PharmacyViewModel
    @Binding var isPresented: Bool
    @State private var selectedPhoto: PhotosPickerItem? = nil
    @State private var selectedImageData: Data? = nil
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 24) {
                // Upload Icon
                ZStack {
                    Circle()
                        .fill(Color(red: 0.90, green: 0.94, blue: 0.98))
                        .frame(width: 80, height: 80)
                    
                    Image(systemName: "doc.text.viewfinder")
                        .font(.system(size: 36))
                        .foregroundColor(Color(red: 0.15, green: 0.35, blue: 0.75))
                }
                .padding(.top, 20)
                
                Text("Upload Prescription")
                    .font(.system(size: 22, weight: .bold))
                
                // Show selected image preview
                if let imageData = selectedImageData, let uiImage = UIImage(data: imageData) {
                    VStack(spacing: 8) {
                        Image(uiImage: uiImage)
                            .resizable()
                            .scaledToFit()
                            .frame(maxHeight: 120)
                            .cornerRadius(12)
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(Color.green, lineWidth: 2)
                            )
                        
                        Text("Prescription selected ✓")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(.green)
                    }
                    .padding(.horizontal, 20)
                } else {
                    Text("Take a photo or select an image of your\nprescription from your gallery")
                        .font(.system(size: 14))
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.center)
                }
                
                VStack(spacing: 12) {
                    // Camera Button (simulated)
                    Button(action: {
                        // Simulate camera capture
                        selectedImageData = Data()
                        viewModel.uploadPrescription(imageData: Data())
                        isPresented = false
                    }) {
                        HStack(spacing: 12) {
                            Image(systemName: "camera.fill")
                                .font(.system(size: 20))
                            Text("Take Photo")
                                .font(.system(size: 16, weight: .semibold))
                        }
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(Color(red: 0.15, green: 0.35, blue: 0.75))
                        .cornerRadius(14)
                    }
                    
                    // Gallery Button - uses PhotosPicker
                    PhotosPicker(selection: $selectedPhoto, matching: .images) {
                        HStack(spacing: 12) {
                            Image(systemName: "photo.on.rectangle")
                                .font(.system(size: 20))
                            Text("Choose from Gallery")
                                .font(.system(size: 16, weight: .semibold))
                        }
                        .foregroundColor(Color(red: 0.15, green: 0.35, blue: 0.75))
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(Color(red: 0.15, green: 0.35, blue: 0.75).opacity(0.1))
                        .cornerRadius(14)
                    }
                    .onChange(of: selectedPhoto) { _, newValue in
                        Task {
                            if let data = try? await newValue?.loadTransferable(type: Data.self) {
                                selectedImageData = data
                                viewModel.uploadPrescription(imageData: data)
                                isPresented = false
                            }
                        }
                    }
                }
                .padding(.horizontal, 20)
                
                Spacer()
            }
            .navigationTitle("Prescription")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        isPresented = false
                    }
                }
            }
        }
    }
}


// Checkout Sheet

struct PharmacyCheckoutSheet: View {
    @ObservedObject var pharmacyViewModel: PharmacyViewModel
    @Binding var isPresented: Bool
    @Binding var shouldDismissToRoot: Bool
    
    @StateObject private var paymentVM: PaymentViewModel
    
    @State private var showDiscountCodeSheet = false
    @State private var discountCode = ""
    @State private var appliedDiscount: Double = 0.0
    @State private var appliedDiscountCode = ""
    @State private var discountError = ""
    
    init(viewModel: PharmacyViewModel, isPresented: Binding<Bool>, shouldDismissToRoot: Binding<Bool>) {
        self.pharmacyViewModel = viewModel
        self._isPresented = isPresented
        self._shouldDismissToRoot = shouldDismissToRoot
        self._paymentVM = StateObject(wrappedValue: PaymentViewModel(totalPrice: viewModel.cartTotal))
    }
    
    var totalWithDiscount: Double {
        max(0, paymentVM.totalPrice - appliedDiscount)
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color(.systemGroupedBackground)
                    .ignoresSafeArea()
                
                if paymentVM.paymentSuccess {
                    pharmacyPaymentSuccessView
                } else {
                    VStack(spacing: 0) {
                        ScrollView(showsIndicators: false) {
                            VStack(spacing: 20) {
                                // Order Summary
                                orderSummarySection
                                
                                // Payment Summary
                                paymentSummarySection
                                
                                // Payment Methods
                                paymentMethodsSection
                                
                                // Note
                                noteSection
                            }
                            .padding(.top, 20)
                            .padding(.bottom, 100)
                        }
                        
                        payNowButton
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    if !paymentVM.paymentSuccess {
                        Button(action: { isPresented = false }) {
                            Image(systemName: "xmark")
                                .font(.system(size: 16, weight: .medium))
                                .foregroundColor(.gray)
                        }
                    }
                }
            }
            .sheet(isPresented: $paymentVM.showAddCardSheet) {
                AddCardSheet(
                    isPresented: $paymentVM.showAddCardSheet,
                    onCardAdded: { card, save in
                        paymentVM.addCard(card, saveForFuture: save)
                    }
                )
                .presentationDetents([.large])
            }
            .sheet(isPresented: $showDiscountCodeSheet) {
                DiscountCodeSheet(
                    isPresented: $showDiscountCodeSheet,
                    discountCode: $discountCode,
                    appliedDiscount: $appliedDiscount,
                    appliedDiscountCode: $appliedDiscountCode,
                    discountError: $discountError,
                    totalPrice: paymentVM.totalPrice
                )
                .presentationDetents([.height(320)])
            }
            .alert("Apple Pay", isPresented: $paymentVM.showApplePayPrompt) {
                Button("Cancel", role: .cancel) { }
                Button("Simulate Payment") {
                    placePharmacyOrder(method: .applePay)
                    paymentVM.processPayment()
                }
            } message: {
                Text("Double-click the side button and authenticate with Face ID to pay with Apple Pay.\n\n(Simulated for demo)")
            }
        }
    }
    
    // Payment Success View
    
    @ViewBuilder
    var pharmacyPaymentSuccessView: some View {
        if paymentVM.selectedPaymentMethod == .counter {
            PharmacyPayAtCounterSuccessView(
                paymentVM: paymentVM,
                pharmacyViewModel: pharmacyViewModel,
                isPresented: $isPresented,
                shouldDismissToRoot: $shouldDismissToRoot
            )
        } else {
            PharmacyRegularPaymentSuccessView(
                paymentVM: paymentVM,
                pharmacyViewModel: pharmacyViewModel,
                isPresented: $isPresented,
                shouldDismissToRoot: $shouldDismissToRoot
            )
        }
    }
    
    // Order Summary Section
    
    var orderSummarySection: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("Order Summary")
                .font(.system(size: 16, weight: .semibold))
                .padding(.horizontal, 16)
                .padding(.vertical, 14)
            
            Divider()
                .padding(.leading, 16)
            
            ForEach(pharmacyViewModel.cartItems) { item in
                HStack {
                    Text("\(item.quantity)x")
                        .font(.system(size: 14))
                        .foregroundColor(.gray)
                        .frame(width: 30, alignment: .leading)
                    
                    Text(item.medicine.name)
                        .font(.system(size: 15))
                    
                    Spacer()
                    
                    Text("LKR \(String(format: "%.2f", item.subtotal))")
                        .font(.system(size: 15))
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
            }
        }
        .background(Color.white)
        .cornerRadius(12)
        .padding(.horizontal, 20)
    }
    
    // Payment Summary Section
    
    var paymentSummarySection: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("Payment Summary")
                .font(.system(size: 16, weight: .semibold))
                .padding(.horizontal, 16)
                .padding(.vertical, 14)
            
            Divider()
                .padding(.leading, 16)
            
            // Medicine Charge
            HStack {
                Text("Medicine Charge")
                    .font(.system(size: 15))
                    .foregroundColor(.gray)
                Spacer()
                Text("LKR \(String(format: "%.2f", paymentVM.totalPrice))")
                    .font(.system(size: 15))
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            
            // Discount Code Section
            if appliedDiscount > 0 {
                HStack {
                    HStack(spacing: 6) {
                        Image(systemName: "tag.fill")
                            .font(.system(size: 12))
                            .foregroundColor(.green)
                        Text(appliedDiscountCode)
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(.green)
                    }
                    
                    Spacer()
                    
                    Text("-LKR \(String(format: "%.2f", appliedDiscount))")
                        .font(.system(size: 15, weight: .medium))
                        .foregroundColor(.green)
                    
                    Button(action: {
                        appliedDiscount = 0
                        appliedDiscountCode = ""
                        discountCode = ""
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .font(.system(size: 16))
                            .foregroundColor(.gray)
                    }
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
            } else {
                Button(action: { showDiscountCodeSheet = true }) {
                    HStack {
                        Image(systemName: "plus.circle.fill")
                            .font(.system(size: 16))
                            .foregroundColor(.blue)
                        
                        Text("Add Discount Code")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(.blue)
                        
                        Spacer()
                        
                        Image(systemName: "chevron.right")
                            .font(.system(size: 12, weight: .medium))
                            .foregroundColor(.gray)
                    }
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
            }
            
            Divider()
                .padding(.leading, 16)
            
            // Total Amount
            HStack {
                Text("Total Amount")
                    .font(.system(size: 16, weight: .semibold))
                Spacer()
                VStack(alignment: .trailing, spacing: 2) {
                    if appliedDiscount > 0 {
                        Text("LKR \(String(format: "%.2f", paymentVM.totalPrice))")
                            .font(.system(size: 13))
                            .foregroundColor(.gray)
                            .strikethrough()
                    }
                    Text("LKR \(String(format: "%.2f", totalWithDiscount))")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(appliedDiscount > 0 ? .green : .primary)
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 14)
        }
        .background(Color.white)
        .cornerRadius(12)
        .padding(.horizontal, 20)
    }
    
    // Payment Methods Section
    
    var paymentMethodsSection: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Apple Pay Option
            Button(action: { paymentVM.selectedPaymentMethod = .applePay }) {
                HStack(spacing: 12) {
                    Image(systemName: "apple.logo")
                        .font(.system(size: 20))
                        .foregroundColor(.black)
                        .frame(width: 40)
                    
                    Text("Pay")
                        .font(.system(size: 17, weight: .semibold))
                        .foregroundColor(.black)
                    
                    Spacer()
                    
                    radioButton(isSelected: paymentVM.selectedPaymentMethod == .applePay)
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 16)
            }
            
            Divider()
                .padding(.leading, 68)
            
            // Credit/Debit Card Option
            Button(action: { paymentVM.selectedPaymentMethod = .card }) {
                HStack(spacing: 12) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 6)
                            .fill(Color.blue.opacity(0.1))
                            .frame(width: 40, height: 28)
                        
                        Image(systemName: "creditcard.fill")
                            .font(.system(size: 14))
                            .foregroundColor(.blue)
                    }
                    
                    VStack(alignment: .leading, spacing: 2) {
                        Text("Credit/Debit Card")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(.black)
                        
                        Text("Visa, Mastercard, Amex")
                            .font(.system(size: 13))
                            .foregroundColor(.gray)
                    }
                    
                    Spacer()
                    
                    radioButton(isSelected: paymentVM.selectedPaymentMethod == .card)
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 14)
            }
            
            // Show saved cards or add card option when card is selected
            if paymentVM.selectedPaymentMethod == .card {
                if paymentVM.savedCards.isEmpty {
                    Button(action: { paymentVM.showAddCardSheet = true }) {
                        HStack {
                            Image(systemName: "plus.circle.fill")
                                .foregroundColor(.blue)
                            Text("Add a new card")
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(.blue)
                        }
                        .padding(.leading, 68)
                        .padding(.vertical, 8)
                    }
                } else {
                    ForEach(paymentVM.savedCards) { card in
                        Button(action: { paymentVM.selectedCard = card }) {
                            HStack(spacing: 12) {
                                Image(systemName: "creditcard")
                                    .foregroundColor(.gray)
                                    .frame(width: 40)
                                
                                Text("•••• \(card.lastFourDigits)")
                                    .font(.system(size: 15))
                                    .foregroundColor(.black)
                                
                                Text(card.cardType)
                                    .font(.system(size: 13))
                                    .foregroundColor(.gray)
                                
                                Spacer()
                                
                                if paymentVM.selectedCard?.id == card.id {
                                    Image(systemName: "checkmark.circle.fill")
                                        .foregroundColor(.blue)
                                }
                            }
                            .padding(.leading, 68)
                            .padding(.trailing, 16)
                            .padding(.vertical, 8)
                        }
                    }
                    
                    Button(action: { paymentVM.showAddCardSheet = true }) {
                        HStack {
                            Image(systemName: "plus.circle.fill")
                                .foregroundColor(.blue)
                            Text("Add a new card")
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(.blue)
                        }
                        .padding(.leading, 68)
                        .padding(.vertical, 8)
                    }
                }
            }
            
            Divider()
                .padding(.leading, 68)
            
            // Pay at Counter Option
            Button(action: { paymentVM.selectedPaymentMethod = .counter }) {
                HStack(spacing: 12) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 6)
                            .fill(Color.green.opacity(0.1))
                            .frame(width: 40, height: 28)
                        
                        Image(systemName: "banknote")
                            .font(.system(size: 14))
                            .foregroundColor(.green)
                    }
                    
                    VStack(alignment: .leading, spacing: 2) {
                        Text("Pay at Counter")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(.black)
                        
                        Text("Cash or Card on pickup")
                            .font(.system(size: 13))
                            .foregroundColor(.gray)
                    }
                    
                    Spacer()
                    
                    radioButton(isSelected: paymentVM.selectedPaymentMethod == .counter)
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 14)
            }
        }
        .background(Color.white)
        .cornerRadius(12)
        .padding(.horizontal, 20)
    }
    
    // Radio Button
    
    func radioButton(isSelected: Bool) -> some View {
        ZStack {
            Circle()
                .stroke(isSelected ? Color.blue : Color.gray.opacity(0.4), lineWidth: 2)
                .frame(width: 22, height: 22)
            
            if isSelected {
                Circle()
                    .fill(Color.blue)
                    .frame(width: 12, height: 12)
            }
        }
    }
    
    // Note Section
    
    var noteSection: some View {
        HStack(spacing: 12) {
            Image(systemName: "info.circle.fill")
                .foregroundColor(.blue)
            
            Text("Your order will be prepared. You'll be notified when it's ready for pickup.")
                .font(.system(size: 13))
                .foregroundColor(.gray)
        }
        .padding(16)
        .background(Color.blue.opacity(0.1))
        .cornerRadius(12)
        .padding(.horizontal, 20)
    }
    
    // Pay Now Button
    
    var payNowButton: some View {
        VStack {
            Button(action: {
                handlePharmacyPayment()
            }) {
                HStack {
                    if paymentVM.isProcessing {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .white))
                            .padding(.trailing, 8)
                    }
                    Text(paymentVM.isProcessing ? "Processing..." : "Pay Now")
                        .font(.system(size: 17, weight: .semibold))
                }
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(paymentVM.canProceed ? Color.blue : Color.gray)
                .cornerRadius(30)
            }
            .disabled(!paymentVM.canProceed || paymentVM.isProcessing)
            .padding(.horizontal, 20)
            .padding(.vertical, 16)
        }
        .background(Color(.systemBackground))
    }
    
    // Handle Payment
    
    private func handlePharmacyPayment() {
        switch paymentVM.selectedPaymentMethod {
        case .applePay:
            paymentVM.showApplePayPrompt = true
        case .card, .counter:
            placePharmacyOrder(method: pharmacyPaymentMethod(from: paymentVM.selectedPaymentMethod))
            paymentVM.processPayment()
        }
    }
    
    private func placePharmacyOrder(method: PharmacyPaymentMethod) {
        _ = pharmacyViewModel.createOrder(paymentMethod: method)
    }
    
    private func pharmacyPaymentMethod(from method: PaymentMethod) -> PharmacyPaymentMethod {
        switch method {
        case .applePay: return .applePay
        case .card: return .online
        case .counter: return .counter
        }
    }
}


// Pharmacy Pay At Counter Success View

struct PharmacyPayAtCounterSuccessView: View {
    @ObservedObject var paymentVM: PaymentViewModel
    @ObservedObject var pharmacyViewModel: PharmacyViewModel
    @Binding var isPresented: Bool
    @Binding var shouldDismissToRoot: Bool
    
    @State private var showShareSheet = false
    @State private var showDownloadAlert = false
    
    var orderDetails: String {
        let orderNumber = pharmacyViewModel.currentOrder?.orderNumber ?? "N/A"
        return """
        🏥 Pharmacy Order Confirmation
        
        📋 Status: Pay at Counter
        💰 Amount to Pay: LKR \(String(format: "%.2f", paymentVM.totalAmount))
        🎫 Order Number: #\(orderNumber)
        🧾 Receipt: \(paymentVM.receiptNumber)
        
        ⏰ Please visit the pharmacy counter to complete payment and pick up your order.
        
        Show this confirmation or scan the QR code at the pharmacy counter.
        """
    }
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 20) {
                Spacer().frame(height: 20)
                
                Text("Order Confirmed!")
                    .font(.system(size: 24, weight: .bold))
                
                // Warning Card
                HStack(spacing: 12) {
                    Image(systemName: "clock.fill")
                        .font(.system(size: 24))
                        .foregroundColor(.orange)
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Payment pending")
                            .font(.system(size: 15, weight: .semibold))
                        Text("Please visit the pharmacy counter to complete payment and pick up your order.")
                            .font(.system(size: 13))
                            .foregroundColor(.gray)
                    }
                }
                .padding(16)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color.orange.opacity(0.1))
                .cornerRadius(12)
                .padding(.horizontal, 20)
                
                // Receipt Details Card
                VStack(spacing: 16) {
                    VStack(spacing: 8) {
                        Text("ORDER NUMBER")
                            .font(.system(size: 11, weight: .semibold))
                            .foregroundColor(.gray)
                            .tracking(1)
                        
                        Text("#\(pharmacyViewModel.currentOrder?.orderNumber ?? "N/A")")
                            .font(.system(size: 28, weight: .bold, design: .monospaced))
                            .foregroundColor(.blue)
                    }
                    
                    Divider()
                    
                    VStack(spacing: 12) {
                        Text("Scan at Pharmacy Counter")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(.gray)
                        
                        if let qrImage = paymentVM.generatePaymentQRCode() {
                            Image(uiImage: qrImage)
                                .resizable()
                                .interpolation(.none)
                                .scaledToFit()
                                .frame(width: 180, height: 180)
                                .padding(12)
                                .background(Color.white)
                                .cornerRadius(12)
                                .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
                        }
                        
                        Text("Show this QR code at the pharmacy counter\nfor faster processing")
                            .font(.system(size: 13))
                            .foregroundColor(.gray)
                            .multilineTextAlignment(.center)
                    }
                    
                    Divider()
                    
                    VStack(spacing: 10) {
                        HStack {
                            Text("Amount to Pay")
                                .foregroundColor(.gray)
                            Spacer()
                            Text("LKR \(String(format: "%.2f", paymentVM.totalAmount))")
                                .font(.system(size: 18, weight: .bold))
                        }
                        
                        HStack {
                            Text("Payment Method")
                                .foregroundColor(.gray)
                            Spacer()
                            HStack(spacing: 6) {
                                Image(systemName: "banknote")
                                    .foregroundColor(.green)
                                Text("Pay at Counter")
                                    .font(.system(size: 15, weight: .medium))
                            }
                        }
                    }
                }
                .padding(20)
                .background(Color.white)
                .cornerRadius(16)
                .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 4)
                .padding(.horizontal, 20)
                
                // Download & Share Buttons
                HStack(spacing: 12) {
                    Button(action: { showDownloadAlert = true }) {
                        HStack(spacing: 8) {
                            Image(systemName: "arrow.down.circle.fill")
                                .font(.system(size: 18))
                            Text("Download")
                                .font(.system(size: 15, weight: .semibold))
                        }
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                        .background(
                            LinearGradient(
                                colors: [
                                    Color(red: 0.15, green: 0.35, blue: 0.75),
                                    Color(red: 0.25, green: 0.50, blue: 0.88)
                                ],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .cornerRadius(12)
                    }
                    
                    Button(action: { showShareSheet = true }) {
                        HStack(spacing: 8) {
                            Image(systemName: "square.and.arrow.up")
                                .font(.system(size: 18))
                            Text("Share")
                                .font(.system(size: 15, weight: .semibold))
                        }
                        .foregroundColor(Color(red: 0.15, green: 0.35, blue: 0.75))
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                        .background(Color.white)
                        .cornerRadius(12)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color(red: 0.15, green: 0.35, blue: 0.75), lineWidth: 2)
                        )
                    }
                }
                .padding(.horizontal, 20)
                
                Text("A confirmation has been sent to your registered email and phone number.")
                    .font(.system(size: 13))
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
                
                // Done Button
                Button("Done") {
                    isPresented = false
                    shouldDismissToRoot = true
                }
                .font(.system(size: 17, weight: .semibold))
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(Color.blue)
                .cornerRadius(30)
                .padding(.horizontal, 20)
                .padding(.top, 10)
                .padding(.bottom, 30)
            }
        }
        .sheet(isPresented: $showShareSheet) {
            ShareSheet(activityItems: [orderDetails])
        }
        .alert("Download Confirmation", isPresented: $showDownloadAlert) {
            Button("OK", role: .cancel) { }
        } message: {
            Text("Your order confirmation has been saved to your device.")
        }
    }
}


// Pharmacy Regular Payment Success View

struct PharmacyRegularPaymentSuccessView: View {
    @ObservedObject var paymentVM: PaymentViewModel
    @ObservedObject var pharmacyViewModel: PharmacyViewModel
    @Binding var isPresented: Bool
    @Binding var shouldDismissToRoot: Bool
    
    @State private var showShareSheet = false
    @State private var showDownloadAlert = false
    
    var orderDetails: String {
        let orderNumber = pharmacyViewModel.currentOrder?.orderNumber ?? "N/A"
        return """
        🏥 Pharmacy Order Confirmation
        
        ✅ Payment Status: Successful
         Amount Paid: LKR \(String(format: "%.2f", paymentVM.totalAmount))
        💳 Payment Method: \(paymentVM.selectedPaymentMethod.rawValue)
        🎫 Order Number: #\(orderNumber)
        🧾 Receipt: \(paymentVM.receiptNumber)
        
        📅 Your order is being prepared. You'll be notified when it's ready for pickup.
        
        Show this confirmation or scan the QR code at the pharmacy counter.
        """
    }
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 20) {
                Spacer().frame(height: 20)
                
                // Success Icon
                ZStack {
                    Circle()
                        .fill(Color.green.opacity(0.1))
                        .frame(width: 100, height: 100)
                    
                    Image(systemName: "checkmark.circle.fill")
                        .font(.system(size: 60))
                        .foregroundColor(.green)
                }
                
                Text("Payment Successful!")
                    .font(.system(size: 24, weight: .bold))
                
                Text("Your pharmacy order has been placed successfully.")
                    .font(.system(size: 16))
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
                
                // Order Details Card
                VStack(spacing: 16) {
                    // Order Number
                    VStack(spacing: 8) {
                        Text("ORDER NUMBER")
                            .font(.system(size: 11, weight: .semibold))
                            .foregroundColor(.gray)
                            .tracking(1)
                        
                        Text("#\(pharmacyViewModel.currentOrder?.orderNumber ?? "N/A")")
                            .font(.system(size: 24, weight: .bold, design: .monospaced))
                            .foregroundColor(.blue)
                    }
                    
                    Divider()
                    
                    // QR Code
                    VStack(spacing: 12) {
                        Text("Scan at Pharmacy Counter")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(.gray)
                        
                        if let qrImage = paymentVM.generatePaymentQRCode() {
                            Image(uiImage: qrImage)
                                .resizable()
                                .interpolation(.none)
                                .scaledToFit()
                                .frame(width: 160, height: 160)
                                .padding(12)
                                .background(Color.white)
                                .cornerRadius(12)
                                .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
                        }
                        
                        Text("Show this QR code at the pharmacy counter\nfor quick pickup")
                            .font(.system(size: 13))
                            .foregroundColor(.gray)
                            .multilineTextAlignment(.center)
                    }
                    
                    Divider()
                    
                    // Payment Details
                    VStack(spacing: 10) {
                        HStack {
                            Text("Amount Paid")
                                .foregroundColor(.gray)
                            Spacer()
                            Text("LKR \(String(format: "%.2f", paymentVM.totalAmount))")
                                .font(.system(size: 18, weight: .bold))
                                .foregroundColor(.green)
                        }
                        
                        HStack {
                            Text("Payment Method")
                                .foregroundColor(.gray)
                            Spacer()
                            HStack(spacing: 6) {
                                Image(systemName: paymentVM.selectedPaymentMethod == .applePay ? "apple.logo" : "creditcard.fill")
                                    .foregroundColor(.blue)
                                Text(paymentVM.selectedPaymentMethod.rawValue)
                                    .font(.system(size: 15, weight: .medium))
                            }
                        }
                        
                        HStack {
                            Text("Status")
                                .foregroundColor(.gray)
                            Spacer()
                            HStack(spacing: 4) {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundColor(.green)
                                    .font(.system(size: 12))
                                Text("Paid")
                                    .font(.system(size: 15, weight: .semibold))
                                    .foregroundColor(.green)
                            }
                        }
                    }
                }
                .padding(20)
                .background(Color.white)
                .cornerRadius(16)
                .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 4)
                .padding(.horizontal, 20)
                
                // Download & Share Buttons
                HStack(spacing: 12) {
                    Button(action: { showDownloadAlert = true }) {
                        HStack(spacing: 8) {
                            Image(systemName: "arrow.down.circle.fill")
                                .font(.system(size: 18))
                            Text("Download")
                                .font(.system(size: 15, weight: .semibold))
                        }
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                        .background(
                            LinearGradient(
                                colors: [
                                    Color(red: 0.15, green: 0.35, blue: 0.75),
                                    Color(red: 0.25, green: 0.50, blue: 0.88)
                                ],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .cornerRadius(12)
                    }
                    
                    Button(action: { showShareSheet = true }) {
                        HStack(spacing: 8) {
                            Image(systemName: "square.and.arrow.up")
                                .font(.system(size: 18))
                            Text("Share")
                                .font(.system(size: 15, weight: .semibold))
                        }
                        .foregroundColor(Color(red: 0.15, green: 0.35, blue: 0.75))
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                        .background(Color.white)
                        .cornerRadius(12)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color(red: 0.15, green: 0.35, blue: 0.75), lineWidth: 2)
                        )
                    }
                }
                .padding(.horizontal, 20)
                
                // Info Text
                Text("A confirmation has been sent to your registered email and phone number.")
                    .font(.system(size: 13))
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
                
                // Done Button
                Button("Done") {
                    isPresented = false
                    shouldDismissToRoot = true
                }
                .font(.system(size: 17, weight: .semibold))
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(Color.blue)
                .cornerRadius(30)
                .padding(.horizontal, 20)
                .padding(.top, 10)
                .padding(.bottom, 30)
            }
        }
        .sheet(isPresented: $showShareSheet) {
            ShareSheet(activityItems: [orderDetails])
        }
        .alert("Download Confirmation", isPresented: $showDownloadAlert) {
            Button("OK", role: .cancel) { }
        } message: {
            Text("Your order confirmation has been saved to your device.")
        }
    }
}
