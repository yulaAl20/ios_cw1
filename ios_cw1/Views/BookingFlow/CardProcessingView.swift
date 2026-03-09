//
//  CardProcessingView.swift
//  ios_cw1
//
//  Created by COBSCCOMP242P-74 on 2026-03-07.
//

import SwiftUI

struct CardProcessingView: View {
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

    private var transactionID: String {
        "TXN-\(Int.random(in: 10000...99999))"
    }

    private var currentDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d, yyyy"
        return formatter.string(from: Date())
    }

    private var currentTime: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm a"
        return formatter.string(from: Date())
    }

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
                    Text("Processing")
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

                    Text("Processing Payment")
                        .font(.title2)
                        .fontWeight(.medium)
                } else {
                    EmptyView() 
                }
            }

            Spacer()
        }
        .navigationBarHidden(true)
        .onAppear {
            // Simulate processing delay
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                withAnimation {
                    isProcessing = false
                    navigateToConfirmation = true
                }
            }
        }
        .background(
            NavigationLink(
                destination: PaymentConfirmationView(
                    doctor: doctor,
                    selectedDate: selectedDate,
                    selectedTimeSlot: selectedTimeSlot,
                    patientName: patientName,
                    patientPhone: patientPhone,
                    location: location,
                    totalAmount: totalAmount,
                    paymentMethod: "Credit/Debit Card",
                    transactionID: transactionID,
                    date: currentDate,
                    time: currentTime,
                    onFlowComplete: onFlowComplete
                ),
                isActive: $navigateToConfirmation
            ) { EmptyView() }
        )
    }
}

#Preview {
    NavigationStack {
        CardProcessingView(
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
