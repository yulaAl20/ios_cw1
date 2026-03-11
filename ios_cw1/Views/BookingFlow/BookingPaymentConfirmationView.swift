//
//  BookingPaymentConfirmationView.swift
//  ios_cw1
//
//  Created by Yulani Alwis on 2026-03-10.
//
//

import SwiftUI

struct BookingPaymentConfirmationView: View {
    @Binding var isPresented: Bool
    @StateObject private var viewModel: PaymentViewModel
    @EnvironmentObject var appointmentStore: AppointmentStore
    @EnvironmentObject var router: AppRouter
    
    let doctor: Doctor
    let selectedDate: Date
    let selectedTimeSlot: String
    let patientName: String
    let patientPhone: String
    let location: String
    
    @State private var showDiscountCodeSheet = false
    @State private var discountCode = ""
    @State private var appliedDiscount: Double = 0.0
    @State private var appliedDiscountCode = ""
    @State private var discountError = ""
    @State private var showShareSheet = false
    @State private var showDownloadAlert = false
    @State private var currentShareText = ""
    
    init(doctor: Doctor, selectedDate: Date, selectedTimeSlot: String, patientName: String, patientPhone: String, location: String, totalPrice: Double, isPresented: Binding<Bool>) {
        self.doctor = doctor
        self.selectedDate = selectedDate
        self.selectedTimeSlot = selectedTimeSlot
        self.patientName = patientName
        self.patientPhone = patientPhone
        self.location = location
        self._isPresented = isPresented
        self._viewModel = StateObject(wrappedValue: PaymentViewModel(totalPrice: totalPrice))
    }
    
    var totalWithDiscount: Double {
        max(0, viewModel.totalPrice - appliedDiscount)
    }
    
    var formattedDateTime: String {
        let f = DateFormatter()
        f.dateFormat = "EEE, d MMM"
        return "\(f.string(from: selectedDate)) • \(selectedTimeSlot)"
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color(.systemGroupedBackground)
                    .ignoresSafeArea()
                
                if viewModel.paymentSuccess {
                    if viewModel.selectedPaymentMethod == .counter {
                        counterSuccessView
                    } else {
                        regularSuccessView
                    }
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
            .sheet(isPresented: $showDiscountCodeSheet) {
                DiscountCodeSheet(
                    isPresented: $showDiscountCodeSheet,
                    discountCode: $discountCode,
                    appliedDiscount: $appliedDiscount,
                    appliedDiscountCode: $appliedDiscountCode,
                    discountError: $discountError,
                    totalPrice: viewModel.totalPrice
                )
                .presentationDetents([.height(320)])
            }
            .sheet(isPresented: $showShareSheet) {
                ShareSheet(activityItems: [currentShareText])
            }
            .alert("Apple Pay", isPresented: $viewModel.showApplePayPrompt) {
                Button("Cancel", role: .cancel) { }
                Button("Simulate Payment") {
                    viewModel.processPayment()
                }
            } message: {
                Text("Double-click the side button and authenticate with Face ID to pay with Apple Pay.\n\n(Simulated for demo)")
            }
            .alert("Download Confirmation", isPresented: $showDownloadAlert) {
                Button("OK", role: .cancel) { }
            } message: {
                Text("Your appointment confirmation has been saved to your device.")
            }
        }
    }
    
    // MARK: - Payment Summary Section
    
    var paymentSummarySection: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("Payment Summary")
                .font(.system(size: 16, weight: .semibold))
                .padding(.horizontal, 16)
                .padding(.vertical, 14)
            
            Divider().padding(.leading, 16)
            
            HStack {
                Text("Consultation Fee")
                    .font(.system(size: 15))
                    .foregroundColor(.gray)
                Spacer()
                Text("LKR \(String(format: "%.2f", viewModel.totalPrice))")
                    .font(.system(size: 15))
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            
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
            
            Divider().padding(.leading, 16)
            
            HStack {
                Text("Total Amount")
                    .font(.system(size: 16, weight: .semibold))
                Spacer()
                VStack(alignment: .trailing, spacing: 2) {
                    if appliedDiscount > 0 {
                        Text("LKR \(String(format: "%.2f", viewModel.totalPrice))")
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
    
    // MARK: - Payment Methods Section
    
    var paymentMethodsSection: some View {
        VStack(alignment: .leading, spacing: 0) {
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
            
            Divider().padding(.leading, 68)
            
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
            
            if viewModel.selectedPaymentMethod == .card {
                if !viewModel.savedCards.isEmpty {
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
            
            Divider().padding(.leading, 68)
            
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
    
    // MARK: - Pay Now Button
    
    var payNowButton: some View {
        VStack {
            Button(action: { viewModel.handlePayment() }) {
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
    
    // MARK: - Counter Success View
    
    var counterSuccessView: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 20) {
                Spacer().frame(height: 20)
                
                Text("Appointment Confirmed!")
                    .font(.system(size: 24, weight: .bold))
                
                HStack(spacing: 12) {
                    Image(systemName: "clock.fill")
                        .font(.system(size: 24))
                        .foregroundColor(.orange)
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Arrive 30 minutes early")
                            .font(.system(size: 15, weight: .semibold))
                        Text("Please arrive early to complete payment at the counter.")
                            .font(.system(size: 13))
                            .foregroundColor(.gray)
                    }
                }
                .padding(16)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color.orange.opacity(0.1))
                .cornerRadius(12)
                .padding(.horizontal, 20)
                
                receiptCard(isPaid: false)
                actionButtons(isCounter: true)
            }
        }
    }
    
    // MARK: - Regular Success View
    
    var regularSuccessView: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 20) {
                Spacer().frame(height: 20)
                
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
                
                Text("Your consultation has been booked successfully.")
                    .font(.system(size: 16))
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
                
                receiptCard(isPaid: true)
                actionButtons(isCounter: false)
            }
        }
    }
    
    // MARK: - Receipt Card (shared)
    
    func receiptCard(isPaid: Bool) -> some View {
        VStack(spacing: 16) {
            VStack(spacing: 8) {
                Text(isPaid ? "BOOKING REFERENCE" : "RECEIPT NUMBER")
                    .font(.system(size: 11, weight: .semibold))
                    .foregroundColor(.gray)
                    .tracking(1)
                Text(viewModel.receiptNumber)
                    .font(.system(size: 24, weight: .bold, design: .monospaced))
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
                        .frame(width: 160, height: 160)
                        .padding(12)
                        .background(Color.white)
                        .cornerRadius(12)
                        .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
                }
                Text(isPaid ? "Show this QR code at the reception\nfor quick check-in" : "Show this QR code at the payment counter\nfor faster processing")
                    .font(.system(size: 13))
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
            }
            
            Divider()
            
            VStack(spacing: 10) {
                detailRow(label: "Doctor", value: "Dr. \(doctor.fullName)")
                detailRow(label: "Date & Time", value: formattedDateTime)
                detailRow(label: "Location", value: location)
                
                HStack {
                    Text(isPaid ? "Amount Paid" : "Amount to Pay")
                        .foregroundColor(.gray)
                    Spacer()
                    Text("LKR \(String(format: "%.2f", viewModel.totalAmount))")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(isPaid ? .green : .primary)
                }
                
                HStack {
                    Text("Payment Method")
                        .foregroundColor(.gray)
                    Spacer()
                    HStack(spacing: 6) {
                        if isPaid {
                            Image(systemName: viewModel.selectedPaymentMethod == .applePay ? "apple.logo" : "creditcard.fill")
                                .foregroundColor(.blue)
                            Text(viewModel.selectedPaymentMethod.rawValue)
                                .font(.system(size: 15, weight: .medium))
                        } else {
                            Image(systemName: "banknote")
                                .foregroundColor(.green)
                            Text("Pay at Counter")
                                .font(.system(size: 15, weight: .medium))
                        }
                    }
                }
                
                if isPaid {
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
        }
        .padding(20)
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 4)
        .padding(.horizontal, 20)
    }
    
    func detailRow(label: String, value: String) -> some View {
        HStack {
            Text(label)
                .foregroundColor(.gray)
            Spacer()
            Text(value)
                .font(.system(size: 15, weight: .medium))
                .multilineTextAlignment(.trailing)
        }
    }
    
    // MARK: - Action Buttons (shared)
    
    func actionButtons(isCounter: Bool) -> some View {
        VStack(spacing: 16) {
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
                            colors: [Color(red: 0.15, green: 0.35, blue: 0.75), Color(red: 0.25, green: 0.50, blue: 0.88)],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .cornerRadius(12)
                }
                
                Button(action: {
                    currentShareText = isCounter ? counterShareText : regularShareText
                    showShareSheet = true
                }) {
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
            
            Button("Done") {
                saveAppointment()
                isPresented = false
                // Switch to appointments tab -> Upcoming after dismissal
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    router.appointmentsInitialTab = "Upcoming"
                    router.currentTab = 2
                }
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

    
    private func saveAppointment() {
        let newAppointment = Appointment(
            doctorName: doctor.fullName,
            specialty: doctor.specialty,
            location: location,
            token: "\(Int.random(in: 10...99))",
            queuePosition: Int.random(in: 3...15),
            totalInQueue: Int.random(in: 15...25),
            date: selectedDate,
            timeSlot: selectedTimeSlot,
            status: .upcoming,
            isTest: false,
            patientName: patientName.isEmpty ? "Yulani Alwis" : patientName,
            patientPhone: patientPhone.isEmpty ? "0777777777" : patientPhone,
            totalAmount: viewModel.totalAmount,
            flowStage: .inQueue
        )
        appointmentStore.addAppointment(newAppointment)
    }

    
    var counterShareText: String {
        """
        🏥 Appointment Confirmation
        
        👨‍⚕️ Doctor: Dr. \(doctor.fullName)
        🩺 Specialty: \(doctor.specialty)
        📅 Date & Time: \(formattedDateTime)
        📍 Location: \(location)
        
        📋 Status: Pay at Counter
        💰 Amount to Pay: LKR \(String(format: "%.2f", viewModel.totalAmount))
        🎫 Receipt Number: \(viewModel.receiptNumber)
        """
    }
    
    var regularShareText: String {
        """
        🏥 Appointment Confirmation
        
        👨‍⚕️ Doctor: Dr. \(doctor.fullName)
        🩺 Specialty: \(doctor.specialty)
        📅 Date & Time: \(formattedDateTime)
        📍 Location: \(location)
        
        ✅ Payment Status: Successful
           Amount Paid: LKR \(String(format: "%.2f", viewModel.totalAmount))
        💳 Payment Method: \(viewModel.selectedPaymentMethod.rawValue)
        🎫 Booking Reference: \(viewModel.receiptNumber)
        """
    }
}

#Preview {
    BookingPaymentConfirmationView(
        doctor: MockData.doctors[0],
        selectedDate: Date(),
        selectedTimeSlot: "01:00 PM",
        patientName: "Yulani Alwis",
        patientPhone: "0777777777",
        location: "Room 12, 1st Floor, Main Wing",
        totalPrice: 2300.00,
        isPresented: .constant(true)
    )
    .environmentObject(AppointmentStore())
    .environmentObject(AppRouter())
}
