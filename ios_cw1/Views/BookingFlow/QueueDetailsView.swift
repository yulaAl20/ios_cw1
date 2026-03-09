//
//  QueueDetailsView.swift
//  ios_cw1
//
//  Created by COBSCCOMP242P-74 on 2026-03-07.
//

import SwiftUI

struct QueueDetailsView: View {
    let doctor: Doctor
    let selectedDate: Date
    let selectedTimeSlot: String
    let patientName: String
    let patientPhone: String
    let location: String
    let totalAmount: Double
    var onFlowComplete: (() -> Void)? = nil

    private let queueNumber = Int.random(in: 1...20)

    private var registrationTime: String {
        return selectedTimeSlot.replacingOccurrences(of: ":", with: ".")
    }

    private var reservationDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d, yyyy"
        return formatter.string(from: selectedDate)
    }

    private let clinicName = "General Clinic 2"

    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Button(action: { onFlowComplete?() }) {
                    Image(systemName: "chevron.left")
                        .font(.title2)
                        .foregroundColor(.primary)
                }
                Spacer()
                Text("Queue Details")
                    .font(.headline)
                    .fontWeight(.semibold)
                Spacer()
                Color.clear.frame(width: 44, height: 44)
            }
            .padding(.horizontal, 24)
            .padding(.top, 16)
            .padding(.bottom, 8)

            ScrollView(showsIndicators: false) {
                VStack(spacing: 24) {
                    VStack(spacing: 4) {
                        Text(clinicName)
                            .font(.title2)
                            .fontWeight(.bold)

                        Text("Registration time \(registrationTime)")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                    .padding(.top, 20)

                    // QR Code placeholder
                    VStack(spacing: 12) {
                        Text("QR Code:")
                            .font(.headline)

                        RoundedRectangle(cornerRadius: 16)
                            .fill(Color.gray.opacity(0.2))
                            .frame(width: 200, height: 200)
                            .overlay(
                                Image(systemName: "qrcode")
                                    .font(.system(size: 100))
                                    .foregroundColor(.gray)
                            )
                            .padding(.top, 4)

                        Text("Scan this QR code at the \(clinicName) administration when your name is called and your queue number appears.")
                            .font(.caption)
                            .foregroundColor(.gray)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 24)
                    }

                    Divider()
                        .padding(.horizontal, 24)

                    // Details grid
                    VStack(spacing: 12) {
                        DetailRow(label: "Patient Name", value: patientName.isEmpty ? "Yulani Alwis" : patientName)
                        DetailRow(label: "Doctor Name", value: "Dr. \(doctor.fullName)")
                        DetailRow(label: "Queue Number", value: "\(queueNumber)")
                        DetailRow(label: "Reservation Date", value: reservationDate)
                    }
                    .padding(.horizontal, 24)

                    Spacer(minLength: 40)
                }
            }

            // Go to Home button
            VStack {
                Button(action: {
                    onFlowComplete?()
                }) {
                    Text("Go to Home")
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
        }
        .navigationBarHidden(true)
    }
}

#Preview {
    NavigationStack {
        QueueDetailsView(
            doctor: MockData.doctors[0],
            selectedDate: Date(),
            selectedTimeSlot: "01:00 PM",
            patientName: "Yulani Alwis",
            patientPhone: "+94 77 123 4567",
            location: "Room 12, 1st Floor, Main Wing",
            totalAmount: 2300.00
        )
    }
}
