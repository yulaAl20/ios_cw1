//
//  PaymentConfirmationView.swift
//  ios_cw1
//
//  Created by Yulani Alwis on 2026-03-08.
//

import SwiftUI

struct PaymentConfirmationSheet: View {
    @Binding var isPresented: Bool
    @StateObject private var viewModel: PaymentViewModel
    
    init(totalPrice: Double, isPresented: Binding<Bool>) {
        _viewModel = StateObject(wrappedValue: PaymentViewModel(totalPrice: totalPrice))
        _isPresented = isPresented
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color(.systemGroupedBackground)
                    .ignoresSafeArea()
                
                if viewModel.paymentSuccess {
                    paymentSuccessView
                } else {
                    VStack(spacing: 0) {
                        ScrollView(showsIndicators: false) {
                            VStack(spacing: 20) {
                                paymentSummarySection
                                paymentMethodsSection
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
                    if !viewModel.paymentSuccess {
                        Button(action: { isPresented = false }) {
                            Image(systemName: "xmark")
                                .font(.system(size: 16, weight: .medium))
                                .foregroundColor(.gray)
                        }
                    }
                }
            }
            .sheet(isPresented: $viewModel.showAddCardSheet) {
                AddCardSheet(
                    isPresented: $viewModel.showAddCardSheet,
                    onCardAdded: { card, save in
                        viewModel.addCard(card, saveForFuture: save)
                    }
                )
                .presentationDetents([.large])
            }
            .alert("Apple Pay", isPresented: $viewModel.showApplePayPrompt) {
                Button("Cancel", role: .cancel) { }
                Button("Simulate Payment") {
                    viewModel.processPayment()
                }
            } message: {
                Text("Double-click the side button and authenticate with Face ID to pay with Apple Pay.\n\n(Simulated for demo)")
            }
        }
    }
    
    //  Payment Success View
    
    @ViewBuilder
    var paymentSuccessView: some View {
        if viewModel.selectedPaymentMethod == .counter {
            PayAtCounterSuccessView(
                viewModel: viewModel,
                isPresented: $isPresented
            )
        } else {
            RegularPaymentSuccessView(
                viewModel: viewModel,
                isPresented: $isPresented
            )
        }
    }
    
    //  Payment Summary Section
    
    var paymentSummarySection: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("Payment Summary")
                .font(.system(size: 16, weight: .semibold))
                .padding(.horizontal, 16)
                .padding(.vertical, 14)
            
            Divider()
                .padding(.leading, 16)
            
            HStack {
                Text("Test Charge")
                    .font(.system(size: 15))
                    .foregroundColor(.gray)
                Spacer()
                Text("LKR \(String(format: "%.2f", viewModel.totalPrice))")
                    .font(.system(size: 15))
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            
            HStack {
                Text("Lab Visit Fee")
                    .font(.system(size: 15))
                    .foregroundColor(.gray)
                Spacer()
                Text("LKR \(String(format: "%.2f", viewModel.labVisitFee))")
                    .font(.system(size: 15))
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            
            HStack {
                Text("Discount")
                    .font(.system(size: 15))
                    .foregroundColor(.gray)
                Spacer()
                Text("-LKR \(String(format: "%.2f", viewModel.discount))")
                    .font(.system(size: 15))
                    .foregroundColor(.green)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            
            Divider()
                .padding(.leading, 16)
            
            HStack {
                Text("Total Amount")
                    .font(.system(size: 16, weight: .semibold))
                Spacer()
                Text("LKR \(String(format: "%.2f", viewModel.totalAmount))")
                    .font(.system(size: 16, weight: .bold))
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 14)
        }
        .background(Color.white)
        .cornerRadius(12)
        .padding(.horizontal, 20)
    }
    
    //  Payment Methods Section
    
    var paymentMethodsSection: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Apple Pay Option
            Button(action: { viewModel.selectedPaymentMethod = .applePay }) {
                HStack(spacing: 12) {
                    Image(systemName: "apple.logo")
                        .font(.system(size: 20))
                        .foregroundColor(.black)
                        .frame(width: 40)
                    
                    Text("Pay")
                        .font(.system(size: 17, weight: .semibold))
                        .foregroundColor(.black)
                    
                    Spacer()
                    
                    radioButton(isSelected: viewModel.selectedPaymentMethod == .applePay)
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 16)
            }
            
            Divider()
                .padding(.leading, 68)
            
            // Credit/Debit Card Option
            Button(action: { viewModel.selectedPaymentMethod = .card }) {
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
                    
                    radioButton(isSelected: viewModel.selectedPaymentMethod == .card)
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 14)
            }
            
            // Show saved cards or add card option when card is selected
            if viewModel.selectedPaymentMethod == .card {
                if viewModel.savedCards.isEmpty {
                    Button(action: { viewModel.showAddCardSheet = true }) {
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
                    ForEach(viewModel.savedCards) { card in
                        Button(action: { viewModel.selectedCard = card }) {
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
                                
                                if viewModel.selectedCard?.id == card.id {
                                    Image(systemName: "checkmark.circle.fill")
                                        .foregroundColor(.blue)
                                }
                            }
                            .padding(.leading, 68)
                            .padding(.trailing, 16)
                            .padding(.vertical, 8)
                        }
                    }
                    
                    Button(action: { viewModel.showAddCardSheet = true }) {
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
            Button(action: { viewModel.selectedPaymentMethod = .counter }) {
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
                        
                        Text("Cash or Card on arrival")
                            .font(.system(size: 13))
                            .foregroundColor(.gray)
                    }
                    
                    Spacer()
                    
                    radioButton(isSelected: viewModel.selectedPaymentMethod == .counter)
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
    
    //  Pay Now Button
    
    var payNowButton: some View {
        VStack {
            Button(action: {
                viewModel.handlePayment()
            }) {
                HStack {
                    if viewModel.isProcessing {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .white))
                            .padding(.trailing, 8)
                    }
                    Text(viewModel.isProcessing ? "Processing..." : "Pay Now")
                        .font(.system(size: 17, weight: .semibold))
                }
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(viewModel.canProceed ? Color.blue : Color.gray)
                .cornerRadius(30)
            }
            .disabled(!viewModel.canProceed || viewModel.isProcessing)
            .padding(.horizontal, 20)
            .padding(.vertical, 16)
        }
        .background(Color(.systemBackground))
    }
}


//  Pay At Counter Success View

struct PayAtCounterSuccessView: View {
    @ObservedObject var viewModel: PaymentViewModel
    @Binding var isPresented: Bool
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 20) {
                Spacer().frame(height: 20)
                
                Text("Appointment Confirmed!")
                    .font(.system(size: 24, weight: .bold))
                
                // Warning Card
                HStack(spacing: 12) {
                    Image(systemName: "clock.fill")
                        .font(.system(size: 24))
                        .foregroundColor(.orange)
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Arrive 30 minutes early")
                            .font(.system(size: 15, weight: .semibold))
                        Text("Please arrive early to complete payment at the counter and avoid any inconvenience.")
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
                        Text("RECEIPT NUMBER")
                            .font(.system(size: 11, weight: .semibold))
                            .foregroundColor(.gray)
                            .tracking(1)
                        
                        Text(viewModel.receiptNumber)
                            .font(.system(size: 28, weight: .bold, design: .monospaced))
                            .foregroundColor(.blue)
                    }
                    
                    Divider()
                    
                    VStack(spacing: 12) {
                        Text("Scan at Counter")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(.gray)
                        
                        if let qrImage = viewModel.generatePaymentQRCode() {
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
                        
                        Text("Show this QR code at the payment counter\nfor faster processing")
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
                            Text("LKR \(String(format: "%.2f", viewModel.totalAmount))")
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
                
                Text("A confirmation has been sent to your registered email and phone number.")
                    .font(.system(size: 13))
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
                
                Spacer().frame(height: 100)
            }
        }
        .overlay(alignment: .bottom) {
            Button("Done") {
                isPresented = false
            }
            .font(.system(size: 17, weight: .semibold))
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background(Color.blue)
            .cornerRadius(30)
            .padding(.horizontal, 20)
            .padding(.bottom, 20)
            .background(
                LinearGradient(
                    colors: [Color(.systemBackground).opacity(0), Color(.systemBackground)],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .frame(height: 100)
                .allowsHitTesting(false)
            )
        }
    }
}


//  Regular Payment Success View

struct RegularPaymentSuccessView: View {
    @ObservedObject var viewModel: PaymentViewModel
    @Binding var isPresented: Bool
    
    @State private var showShareSheet = false
    @State private var showDownloadAlert = false
    
    var appointmentDetails: String {
        """
        🏥 Lab Appointment Confirmation
        
        ✅ Payment Status: Successful
           Amount Paid: LKR \(String(format: "%.2f", viewModel.totalAmount))
        💳 Payment Method: \(viewModel.selectedPaymentMethod.rawValue)
        🎫 Booking Reference: \(viewModel.receiptNumber)
        
        📅 Please arrive on time for your appointment.
        
        Show this confirmation or scan the QR code at the counter.
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
                
                Text("Your lab visit has been booked successfully.")
                    .font(.system(size: 16))
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
                
                // Booking Details Card
                VStack(spacing: 16) {
                    // Booking Reference
                    VStack(spacing: 8) {
                        Text("BOOKING REFERENCE")
                            .font(.system(size: 11, weight: .semibold))
                            .foregroundColor(.gray)
                            .tracking(1)
                        
                        Text(viewModel.receiptNumber)
                            .font(.system(size: 24, weight: .bold, design: .monospaced))
                            .foregroundColor(.blue)
                    }
                    
                    Divider()
                    
                    // QR Code
                    VStack(spacing: 12) {
                        Text("Scan at Counter")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(.gray)
                        
                        if let qrImage = viewModel.generatePaymentQRCode() {
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
                        
                        Text("Show this QR code at the lab reception\nfor quick check-in")
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
                            Text("LKR \(String(format: "%.2f", viewModel.totalAmount))")
                                .font(.system(size: 18, weight: .bold))
                                .foregroundColor(.green)
                        }
                        
                        HStack {
                            Text("Payment Method")
                                .foregroundColor(.gray)
                            Spacer()
                            HStack(spacing: 6) {
                                Image(systemName: viewModel.selectedPaymentMethod == .applePay ? "apple.logo" : "creditcard.fill")
                                    .foregroundColor(.blue)
                                Text(viewModel.selectedPaymentMethod.rawValue)
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
                    // Download Button
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
                    
                    // Share Button
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
                
                Spacer().frame(height: 100)
            }
        }
        .overlay(alignment: .bottom) {
            Button("Done") {
                isPresented = false
            }
            .font(.system(size: 17, weight: .semibold))
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background(Color.blue)
            .cornerRadius(30)
            .padding(.horizontal, 20)
            .padding(.bottom, 20)
            .background(
                LinearGradient(
                    colors: [Color(.systemBackground).opacity(0), Color(.systemBackground)],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .frame(height: 100)
                .allowsHitTesting(false)
            )
        }
        .sheet(isPresented: $showShareSheet) {
            ShareSheet(activityItems: [appointmentDetails])
        }
        .alert("Download Confirmation", isPresented: $showDownloadAlert) {
            Button("OK", role: .cancel) { }
        } message: {
            Text("Your appointment confirmation has been saved to your device.")
        }
    }
}


// Share Sheet for UIActivityViewController
struct ShareSheet: UIViewControllerRepresentable {
    let activityItems: [Any]
    
    func makeUIViewController(context: Context) -> UIActivityViewController {
        UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
    }
    
    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}
