//
//  ApplePayIntroView.swift
//  ios_cw1
//
//  Created by COBSCCOMP242P-74 on 2026-03-04.
//

import SwiftUI

struct ApplePayIntroView: View {
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
    @State private var navigateToPayment = false

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

            Spacer()

            VStack(spacing: 40) {
                Image(systemName: "applelogo")
                    .font(.system(size: 60))
                    .foregroundColor(.black)

                Text(String(format: "LKR %.2f", totalAmount))
                    .font(.largeTitle)
                    .fontWeight(.bold)

                VStack(spacing: 8) {
                    Text("Double Click")
                        .font(.title2)
                        .fontWeight(.medium)
                    Text("to Pay")
                        .font(.title2)
                        .fontWeight(.medium)
                }

                Button(action: {
                    navigateToPayment = true
                }) {
                    Text("Double Click to Pay")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 18)
                        .background(Color.blue)
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                }
                .padding(.horizontal, 40)
            }

            Spacer()
        }
        .navigationBarHidden(true)
        .background(
            NavigationLink(
                destination: ApplePayPaymentView(
                    doctor: doctor,
                    selectedDate: selectedDate,
                    selectedTimeSlot: selectedTimeSlot,
                    patientName: patientName,
                    patientPhone: patientPhone,
                    location: location,
                    totalAmount: totalAmount,
                    onFlowComplete: onFlowComplete
                ),
                isActive: $navigateToPayment
            ) { EmptyView() }
        )
    }
}

#Preview {
    NavigationStack {
        ApplePayIntroView(
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
