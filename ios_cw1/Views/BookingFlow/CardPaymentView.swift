//
//  CardPaymentView.swift
//  ios_cw1
//
//  Created by COBSCCOMP242P-74 on 2026-03-04.
//

import SwiftUI

struct CardPaymentView: View {
    let doctor: Doctor
    let selectedDate: Date
    let selectedTimeSlot: String
    let patientName: String
    let patientPhone: String
    let location: String
    let totalAmount: Double
    var onFlowComplete: (() -> Void)? = nil

    @Environment(\.dismiss) private var dismiss

    @State private var cardNumber = ""
    @State private var cardholderName = ""
    @State private var expiryDate = ""
    @State private var cvv = ""
    @State private var navigateToProcessing = false

    private var isFormValid: Bool {
        let cleanedCardNumber = cardNumber.filter { $0.isNumber }
        return cleanedCardNumber.count >= 16 &&
               !cardholderName.trimmingCharacters(in: .whitespaces).isEmpty &&
               expiryDate.count >= 5 &&
               cvv.count == 3
    }

    var body: some View {
        ZStack {
            NavigationLink(
                destination: CardProcessingView(
                    doctor: doctor,
                    selectedDate: selectedDate,
                    selectedTimeSlot: selectedTimeSlot,
                    patientName: patientName,
                    patientPhone: patientPhone,
                    location: location,
                    totalAmount: totalAmount,
                    onFlowComplete: onFlowComplete
                ),
                isActive: $navigateToProcessing
            ) { EmptyView() }

            VStack(spacing: 0) {
      
                HStack {
                    Button(action: { dismiss() }) {
                        Image(systemName: "chevron.left")
                            .font(.title2)
                            .foregroundColor(.primary)
                    }
                    Spacer()
                    Text("Credit/Debit Card Payment")
                        .font(.headline)
                        .fontWeight(.semibold)
                        .lineLimit(1)
                        .minimumScaleFactor(0.8)
                    Spacer()
                    Color.clear.frame(width: 44, height: 44)
                }
                .padding(.horizontal, 24)
                .padding(.top, 16)
                .padding(.bottom, 8)

                ScrollView(showsIndicators: false) {
                    VStack(spacing: 28) {
                
                        VStack(alignment: .leading, spacing: 16) {
                            HStack {
                                Text(lastFour)
                                    .font(.title2)
                                    .fontWeight(.semibold)
                                    .foregroundColor(.white)
                                Spacer()
                                Image(systemName: "creditcard")
                                    .font(.title2)
                                    .foregroundColor(.white)
                            }

                            Spacer().frame(height: 20)

                            HStack {
                                VStack(alignment: .leading, spacing: 4) {
                                    Text("CARD HOLDER")
                                        .font(.caption2)
                                        .foregroundColor(.white.opacity(0.7))
                                    Text(cardholderName.isEmpty ? "John Doe" : cardholderName)
                                        .font(.body)
                                        .fontWeight(.medium)
                                        .foregroundColor(.white)
                                }
                                Spacer()
                                VStack(alignment: .trailing, spacing: 4) {
                                    Text("EXPIRES")
                                        .font(.caption2)
                                        .foregroundColor(.white.opacity(0.7))
                                    Text(expiryDate.isEmpty ? "12/25" : expiryDate)
                                        .font(.body)
                                        .fontWeight(.medium)
                                        .foregroundColor(.white)
                                }
                            }
                        }
                        .padding(20)
                        .frame(maxWidth: .infinity)
                        .background(
                            LinearGradient(
                                gradient: Gradient(colors: [Color.blue, Color.blue.opacity(0.8)]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .cornerRadius(16)
                        .shadow(color: .black.opacity(0.2), radius: 10, x: 0, y: 4)
                        .padding(.horizontal, 24)

                 
                        VStack(spacing: 20) {
                            // Card Number
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Card Number")
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                                TextField("4242 4242 4242 4242", text: $cardNumber)
                                    .keyboardType(.numberPad)
                                    .onChange(of: cardNumber) { oldValue, newValue in
                                        let digits = newValue.filter { $0.isNumber }
                                        if digits.count > 16 {
                                            cardNumber = String(digits.prefix(16))
                                        } else {
                                            var formatted = ""
                                            for (index, char) in digits.enumerated() {
                                                if index > 0 && index % 4 == 0 {
                                                    formatted += " "
                                                }
                                                formatted.append(char)
                                            }
                                            cardNumber = formatted
                                        }
                                    }
                                    .padding()
                                    .background(Color(.systemGray6))
                                    .cornerRadius(12)
                                    .font(.body)
                            }

                            // Cardholder Name
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Cardholder Name")
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                                TextField("John Doe", text: $cardholderName)
                                    .padding()
                                    .background(Color(.systemGray6))
                                    .cornerRadius(12)
                                    .font(.body)
                                    .autocapitalization(.words)
                            }

                            // Expiry Date and CVV
                            HStack(spacing: 16) {
                                VStack(alignment: .leading, spacing: 8) {
                                    Text("Expiry Date")
                                        .font(.subheadline)
                                        .foregroundColor(.gray)
                                    TextField("MM/YY", text: $expiryDate)
                                        .keyboardType(.numberPad)
                                        .onChange(of: expiryDate) { oldValue, newValue in
                                            let digits = newValue.filter { $0.isNumber }
                                            if digits.count > 4 {
                                                expiryDate = String(digits.prefix(4))
                                            } else {
                                                if digits.count >= 2 {
                                                    let month = digits.prefix(2)
                                                    let year = digits.dropFirst(2)
                                                    expiryDate = "\(month)/\(year)"
                                                } else {
                                                    expiryDate = digits
                                                }
                                            }
                                        }
                                        .padding()
                                        .background(Color(.systemGray6))
                                        .cornerRadius(12)
                                        .font(.body)
                                }

                                VStack(alignment: .leading, spacing: 8) {
                                    Text("CVV")
                                        .font(.subheadline)
                                        .foregroundColor(.gray)
                                    TextField("123", text: $cvv)
                                        .keyboardType(.numberPad)
                                        .onChange(of: cvv) { oldValue, newValue in
                                            if newValue.count > 3 {
                                                cvv = String(newValue.prefix(3))
                                            }
                                        }
                                        .padding()
                                        .background(Color(.systemGray6))
                                        .cornerRadius(12)
                                        .font(.body)
                                }
                            }
                        }
                        .padding(.horizontal, 24)

                        Spacer(minLength: 40)
                    }
                }

           
                if isFormValid {
                    VStack {
                        Button(action: {
                            navigateToProcessing = true
                        }) {
                            Text("Pay \(String(format: "%.2f LKR", totalAmount))")
                                .font(.headline)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 18)
                                .background(Color.blue)
                                .clipShape(RoundedRectangle(cornerRadius: 20))
                        }
                        .padding(.horizontal, 24)
                        .padding(.vertical, 16)
                        .background(Color(.systemBackground))
                        .shadow(color: .black.opacity(0.1), radius: 12, y: -6)
                    }
                    .transition(.opacity)
                }
            }
            .navigationBarHidden(true)
            .animation(.easeInOut, value: isFormValid)
        }
        .onAppear {
            navigateToProcessing = false
        }
    }

    private var lastFour: String {
        let cleaned = cardNumber.filter { $0.isNumber }
        guard cleaned.count >= 4 else { return "4242" }
        return String(cleaned.suffix(4))
    }
}

#Preview {
    NavigationStack {
        CardPaymentView(
            doctor: MockData.doctors[0],
            selectedDate: Date(),
            selectedTimeSlot: "01:00 PM",
            patientName: "Peter John",
            patientPhone: "+94 77 123 4567",
            location: "Room 12, 1st Floor, Main Wing",
            totalAmount: 2300.00
        )
    }
}
