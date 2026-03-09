//
//  ApplePayProcessingView.swift
//  ios_cw1
//
//  Created by COBSCCOMP242P-74 on 2026-03-04.
//

import SwiftUI

struct ApplePayProcessingView: View {
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
    @State private var isProcessing = true
    @State private var navigateToConfirmation = false

    var body: some View {
        VStack(spacing: 0) {
            if !isProcessing {
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
            }

            Spacer()

            VStack(spacing: 30) {
                if isProcessing {
                    ProgressView()
                        .scaleEffect(2)
                        .padding()

                    Text("Processing")
                        .font(.title2)
                        .fontWeight(.medium)

                    Image(systemName: "faceid")
                        .font(.system(size: 40))
                        .foregroundColor(.blue)
                } else {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.system(size: 60))
                        .foregroundColor(.green)

                    Text("Payment Successful")
                        .font(.title2)
                        .fontWeight(.semibold)

                    Button("View Appointment") {
                        navigateToConfirmation = true
                    }
                    .font(.headline)
                    .foregroundColor(.blue)
                    .padding(.top, 20)
                }
            }

            Spacer()
        }
        .navigationBarHidden(true)
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                withAnimation {
                    isProcessing = false
                }
            }
        }
        .background(
            NavigationLink(
                destination: AppointmentConfirmationView(
                    doctor: doctor,
                    selectedDate: selectedDate,
                    selectedTimeSlot: selectedTimeSlot,
                    patientName: patientName,
                    patientPhone: patientPhone,
                    location: location,
                    totalAmount: totalAmount,
                    onFlowComplete: onFlowComplete
                ),
                isActive: $navigateToConfirmation
            ) { EmptyView() }
        )
    }
}

#Preview {
    NavigationStack {
        ApplePayProcessingView(
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
