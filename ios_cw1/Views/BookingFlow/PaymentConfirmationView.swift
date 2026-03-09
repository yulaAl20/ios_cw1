//
//  PaymentConfirmationView.swift
//  ios_cw1
//
//  Created by COBSCCOMP242P-74 on 2026-03-04.
//

import SwiftUI

struct PaymentConfirmationView: View {
    // Appointment details
    let doctor: Doctor
    let selectedDate: Date
    let selectedTimeSlot: String
    let patientName: String
    let patientPhone: String
    let location: String
    let totalAmount: Double
    // Payment details
    let paymentMethod: String
    let transactionID: String
    let date: String
    let time: String
    var onFlowComplete: (() -> Void)? = nil

    @Environment(\.dismiss) private var dismiss

    private let discount: Double = 0

    var body: some View {
        VStack(spacing: 0) {
            // Top bar
            HStack {
                Button(action: { dismiss() }) {
                    Image(systemName: "chevron.left")
                        .font(.title2)
                        .foregroundColor(.primary)
                }
                Spacer()
                Text("Payment Successful")
                    .font(.headline)
                    .fontWeight(.semibold)
                Spacer()
                Color.clear.frame(width: 44, height: 44)
            }
            .padding(.horizontal, 24)
            .padding(.top, 16)
            .padding(.bottom, 8)

            ScrollView(showsIndicators: false) {
                VStack(spacing: 28) {
                    // Success icon and message
                    VStack(spacing: 16) {
                        Image(systemName: "checkmark.circle.fill")
                            .font(.system(size: 70))
                            .foregroundColor(.green)

                        Text("Thank you! Your appointment has been successfully booked.")
                            .font(.body)
                            .multilineTextAlignment(.center)
                            .foregroundColor(.gray)
                            .padding(.horizontal, 24)
                    }
                    .padding(.top, 20)

                    // Details card
                    VStack(alignment: .leading, spacing: 16) {
                        DetailRow(label: "Transaction ID", value: transactionID)
                        DetailRow(label: "Date", value: date)
                        DetailRow(label: "Time", value: time)
                        DetailRow(label: "Payment Method", value: paymentMethod)

                        Divider()
                            .padding(.vertical, 8)

                        HStack {
                            Text("Consultation Fee")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                            Spacer()
                            Text(String(format: "%.2f", totalAmount))
                                .font(.subheadline)
                                .fontWeight(.medium)
                        }

                        HStack {
                            Text("Discount(s)")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                            Spacer()
                            Text(discount > 0 ? String(format: "- %.2f", discount) : "-")
                                .font(.subheadline)
                                .foregroundColor(.green)
                        }

                        Divider()
                            .padding(.vertical, 4)

                        HStack {
                            Text("Total Paid")
                                .font(.headline)
                            Spacer()
                            Text(String(format: "%.2f LKR", totalAmount))
                                .font(.title3)
                                .fontWeight(.bold)
                                .foregroundColor(.blue)
                        }
                    }
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(20)
                    .padding(.horizontal, 24)

                    // Action buttons
                    VStack(spacing: 12) {
                        Button(action: {
                            print("Download receipt tapped")
                        }) {
                            Label("Download Receipt", systemImage: "arrow.down.doc")
                                .font(.headline)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 14)
                                .background(Color.blue)
                                .clipShape(RoundedRectangle(cornerRadius: 20))
                        }

                        Button(action: {
                            print("Share details tapped")
                        }) {
                            Label("Share Details", systemImage: "square.and.arrow.up")
                                .font(.headline)
                                .foregroundColor(.blue)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 14)
                                .background(Color.blue.opacity(0.1))
                                .clipShape(RoundedRectangle(cornerRadius: 20))
                        }

                        NavigationLink(destination: AppointmentConfirmationView(
                            doctor: doctor,
                            selectedDate: selectedDate,
                            selectedTimeSlot: selectedTimeSlot,
                            patientName: patientName,
                            patientPhone: patientPhone,
                            location: location,
                            totalAmount: totalAmount,
                            onFlowComplete: onFlowComplete
                        )) {
                            Text("View Appointment")
                                .font(.headline)
                                .foregroundColor(.blue)
                                .padding(.vertical, 14)
                        }
                    }
                    .padding(.horizontal, 24)

                    Spacer(minLength: 40)
                }
            }
        }
        .navigationBarHidden(true)
    }
}

struct DetailRow: View {
    let label: String
    let value: String

    var body: some View {
        HStack {
            Text(label)
                .font(.subheadline)
                .foregroundColor(.gray)
            Spacer()
            Text(value)
                .font(.body)
                .fontWeight(.medium)
        }
    }
}

#Preview {
    NavigationStack {
        PaymentConfirmationView(
            doctor: MockData.doctors[0],
            selectedDate: Date(),
            selectedTimeSlot: "01:00 PM",
            patientName: "Peter John",
            patientPhone: "+94 77 123 4567",
            location: "Room 12, 1st Floor, Main Wing",
            totalAmount: 2300.00,
            paymentMethod: "Apple Pay",
            transactionID: "TXN-88294",
            date: "Oct 24, 2026",
            time: "10:42 AM"
        )
    }
}
