//
//  PaymentView.swift
//  ios_cw1
//
//  Created by COBSCCOMP242P-74 on 2026-03-04.
//

import SwiftUI

struct PaymentView: View {
    let doctor: Doctor
    let selectedDate: Date
    let selectedTimeSlot: String
    let patientName: String
    let patientPhone: String
    let location: String
    let totalAmount: Double
    var onFlowComplete: (() -> Void)? = nil

    @State private var navigateToCardPayment = false
    @State private var navigateToApplePayIntro = false
    @State private var navigateToCounterConfirmation = false
    @Environment(\.dismiss) private var dismiss
    @State private var selectedMethod: PaymentMethod? = nil

    enum PaymentMethod: String, CaseIterable {
        case applePay = "Apple Pay"
        case card = "Credit/Debit Card"
        case counter = "Pay at Counter"

        var subtitle: String? {
            switch self {
            case .applePay: return nil
            case .card: return "Visa, Mastercard, Amex"
            case .counter: return "Cash or Card on arrival"
            }
        }

        var icon: String {
            switch self {
            case .applePay: return "applelogo"
            case .card: return "creditcard"
            case .counter: return "banknote"
            }
        }
    }

    var body: some View {
        ZStack {
            // Navigation links
            NavigationLink(
                destination: CardPaymentView(
                    doctor: doctor,
                    selectedDate: selectedDate,
                    selectedTimeSlot: selectedTimeSlot,
                    patientName: patientName,
                    patientPhone: patientPhone,
                    location: location,
                    totalAmount: totalAmount,
                    onFlowComplete: onFlowComplete
                ),
                isActive: $navigateToCardPayment
            ) { EmptyView() }

            NavigationLink(
                destination: ApplePayIntroView(
                    doctor: doctor,
                    selectedDate: selectedDate,
                    selectedTimeSlot: selectedTimeSlot,
                    patientName: patientName,
                    patientPhone: patientPhone,
                    location: location,
                    totalAmount: totalAmount,
                    onFlowComplete: onFlowComplete   
                ),
                isActive: $navigateToApplePayIntro
            ) { EmptyView() }


            NavigationLink(
                destination: QueueDetailsView(
                    doctor: doctor,
                    selectedDate: selectedDate,
                    selectedTimeSlot: selectedTimeSlot,
                    patientName: patientName,
                    patientPhone: patientPhone,
                    location: location,
                    totalAmount: totalAmount,
                    onFlowComplete: onFlowComplete
                ),
                isActive: $navigateToCounterConfirmation
            ) { EmptyView() }

            VStack(spacing: 0) {
                HStack {
                    Button(action: { dismiss() }) {
                        Image(systemName: "chevron.left")
                            .font(.title2)
                            .foregroundColor(.primary)
                    }
                    Spacer()
                    Text("Payment")
                        .font(.headline)
                        .fontWeight(.semibold)
                    Spacer()
                    Color.clear.frame(width: 44, height: 44)
                }
                .padding(.horizontal, 24)
                .padding(.top, 16)
                .padding(.bottom, 8)

                ScrollView(showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 32) {
                        // Total Amount
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Total Amount")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                            Text(String(format: "LKR %.2f", totalAmount))
                                .font(.largeTitle)
                                .fontWeight(.bold)
                                .foregroundColor(.primary)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal, 24)
                        .padding(.top, 8)

                        // Payment method section
                        VStack(alignment: .leading, spacing: 16) {
                            Text("SELECT PAYMENT METHOD")
                                .font(.footnote)
                                .fontWeight(.semibold)
                                .foregroundColor(.gray)
                                .padding(.horizontal, 24)

                            VStack(spacing: 0) {
                                ForEach(PaymentMethod.allCases, id: \.self) { method in
                                    Button(action: {
                                        selectedMethod = method
                                    }) {
                                        HStack(spacing: 16) {
                                            ZStack {
                                                Circle()
                                                    .stroke(selectedMethod == method ? Color.blue : Color.gray, lineWidth: 2)
                                                    .frame(width: 24, height: 24)
                                                if selectedMethod == method {
                                                    Circle()
                                                        .fill(Color.blue)
                                                        .frame(width: 14, height: 14)
                                                }
                                            }

                                            Image(systemName: method.icon)
                                                .font(.title3)
                                                .foregroundColor(.blue)
                                                .frame(width: 32)

                                            VStack(alignment: .leading, spacing: 2) {
                                                Text(method.rawValue)
                                                    .font(.body)
                                                    .fontWeight(.medium)
                                                    .foregroundColor(.primary)
                                                if let subtitle = method.subtitle {
                                                    Text(subtitle)
                                                        .font(.caption)
                                                        .foregroundColor(.gray)
                                                }
                                            }
                                            Spacer()
                                        }
                                        .padding(.vertical, 12)
                                        .padding(.horizontal, 24)
                                        .background(Color(.systemBackground))
                                    }
                                    .buttonStyle(PlainButtonStyle())

                                    if method != .counter {
                                        Divider()
                                            .padding(.leading, 70)
                                    }
                                }
                            }
                            .background(Color(.systemGray6))
                            .cornerRadius(16)
                            .padding(.horizontal, 24)
                        }

                        if selectedMethod == .counter {
                            HStack(alignment: .top, spacing: 12) {
                                Image(systemName: "info.circle")
                                    .foregroundColor(.blue)
                                    .font(.title3)
                                Text("Please arrive 20 minutes before your consultation time to finalize the payment.")
                                    .font(.footnote)
                                    .foregroundColor(.gray)
                                    .fixedSize(horizontal: false, vertical: true)
                            }
                            .padding(.horizontal, 24)
                            .padding(.top, 8)
                            .transition(.opacity)
                        }

                        Spacer(minLength: 40)
                    }
                }

                if selectedMethod == .counter {
                    VStack {
                        Button(action: {
                            navigateToCounterConfirmation = true
                        }) {
                            Text("Confirm Appointment")
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
                    .transition(.move(edge: .bottom).combined(with: .opacity))
                }
            }
            .navigationBarHidden(true)
            .animation(.easeInOut(duration: 0.2), value: selectedMethod)
        }
        .onChange(of: selectedMethod) { newMethod in
            if newMethod == .card {
                navigateToCardPayment = true
            } else if newMethod == .applePay {
                navigateToApplePayIntro = true
            }
        }
        .onAppear {
            selectedMethod = nil
            navigateToCardPayment = false
            navigateToApplePayIntro = false
            navigateToCounterConfirmation = false
        }
    }
}

#Preview {
    NavigationStack {
        PaymentView(
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
