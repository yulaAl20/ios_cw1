//
//  ApplePayPaymentView.swift
//  ios_cw1
//
//  Created by COBSCCOMP242P-74 on 2026-03-04.
//


import SwiftUI

struct ApplePayPaymentView: View {
    // Appointment details
    let doctor: Doctor
    let selectedDate: Date
    let selectedTimeSlot: String
    let patientName: String
    let patientPhone: String
    let location: String
    let totalAmount: Double
    var onFlowComplete: (() -> Void)? = nil

    @Environment(\.dismiss) private var dismiss
    @State private var navigateToProcessing = false
    @State private var showChangeMethod = false

    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Button(action: { dismiss() }) {
                    Image(systemName: "chevron.left")
                        .font(.title2)
                        .foregroundColor(.primary)
                }
                Spacer()
                Text("Apple Pay")
                    .font(.headline)
                    .fontWeight(.semibold)
                Spacer()
                Color.clear.frame(width: 44, height: 44)
            }
            .padding(.horizontal, 24)
            .padding(.top, 16)
            .padding(.bottom, 8)

            ScrollView(showsIndicators: false) {
                VStack(spacing: 30) {
                    // Card preview
                    VStack(alignment: .leading, spacing: 16) {
                        HStack {
                            Text("Seylan Visa")
                                .font(.title3)
                                .fontWeight(.semibold)
                            Spacer()
                            Text("•••• 1234")
                                .font(.title3)
                                .foregroundColor(.gray)
                        }

                        HStack {
                            Text("ClinicFlow Hospital")
                                .font(.body)
                                .foregroundColor(.gray)
                            Spacer()
                            Text(String(format: "LKR %.2f", totalAmount))
                                .font(.title2)
                                .fontWeight(.bold)
                        }
                    }
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(16)
                    .padding(.horizontal, 24)

                    // Change payment method button
                    Button(action: {
                        showChangeMethod.toggle()
                    }) {
                        Text("Change Payment Method")
                            .font(.subheadline)
                            .fontWeight(.medium)
                            .foregroundColor(.blue)
                    }
                    .padding(.top, 8)

                    if showChangeMethod {
                        VStack(spacing: 12) {
                            PaymentMethodRow(name: "Seylan Visa", lastFour: "1234")
                            PaymentMethodRow(name: "Other Card", lastFour: "5678")
                        }
                        .padding(.horizontal, 24)
                        .transition(.opacity)
                    }

                    // Confirm with Side Button
                    VStack(spacing: 20) {
                        Text("Confirm with Side Button")
                            .font(.headline)
                            .foregroundColor(.gray)

                        Button(action: {
                            navigateToProcessing = true
                        }) {
                            HStack {
                                Image(systemName: "faceid")
                                    .font(.title2)
                                Text("Pay with Face ID")
                                    .font(.headline)
                            }
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 18)
                            .background(Color.blue)
                            .clipShape(RoundedRectangle(cornerRadius: 20))
                        }
                        .padding(.horizontal, 40)
                    }
                    .padding(.top, 30)

                    Spacer(minLength: 40)
                }
            }
        }
        .navigationBarHidden(true)
        .background(
            NavigationLink(
                destination: ApplePayProcessingView(
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
        )
    }
}

struct PaymentMethodRow: View {
    let name: String
    let lastFour: String

    var body: some View {
        HStack {
            Image(systemName: "creditcard")
                .foregroundColor(.blue)
            Text("\(name) •••• \(lastFour)")
                .font(.body)
            Spacer()
            Image(systemName: "checkmark.circle.fill")
                .foregroundColor(.blue)
        }
        .padding()
        .background(Color(.systemGray5))
        .cornerRadius(12)
    }
}

#Preview {
    NavigationStack {
        ApplePayPaymentView(
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
