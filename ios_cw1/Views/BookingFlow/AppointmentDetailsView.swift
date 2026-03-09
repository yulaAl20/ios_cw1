//
//  AppointmentDetailsView.swift
//  ios_cw1
//
//  Created by COBSCCOMP242P-74 on 2026-03-04.
//

import SwiftUI

struct AppointmentDetailsView: View {
    let doctor: Doctor
    let selectedDate: Date
    let selectedTimeSlot: String
    let patientName: String
    let patientPhone: String
    var onFlowComplete: (() -> Void)? = nil

    @Environment(\.dismiss) private var dismiss

    private let location = "Room 12, 1st Floor, Main Wing"
    private let consultationFee: Double = 2300.00

    private var formattedDateTime: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEE, d MMM"
        let dateString = dateFormatter.string(from: selectedDate)
        return "\(dateString) • \(selectedTimeSlot)"
    }

    private var discount: Double {
        doctor.fee - consultationFee
    }

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
                Text("Appointment Details")
                    .font(.headline)
                    .fontWeight(.semibold)
                Spacer()
                Color.clear.frame(width: 44, height: 44)
            }
            .padding(.horizontal, 24)
            .padding(.top, 16)
            .padding(.bottom, 8)

            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 28) {
                    // Doctor header with Edit button
                    HStack(alignment: .center) {
                        HStack(spacing: 12) {
                            Group {
                                if let imageName = doctor.imageName, let uiImage = UIImage(named: imageName) {
                                    Image(uiImage: uiImage)
                                        .resizable()
                                        .scaledToFill()
                                } else {
                                    Image(systemName: "person.fill")
                                        .resizable()
                                        .scaledToFit()
                                        .foregroundStyle(.blue)
                                        .background(Color.blue.opacity(0.15))
                                }
                            }
                            .frame(width: 48, height: 48)
                            .clipShape(Circle())

                            VStack(alignment: .leading, spacing: 2) {
                                Text("Dr. \(doctor.fullName)")
                                    .font(.headline)
                                Text(doctor.specialty)
                                    .font(.subheadline)
                                    .foregroundStyle(.gray)
                            }
                        }
                        Spacer()
                        Button("Edit") {
                            dismiss()
                        }
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .foregroundColor(.blue)
                    }
                    .padding(.horizontal, 24)

                    // Date & Time
                    HStack(spacing: 16) {
                        Image(systemName: "calendar")
                            .font(.title3)
                            .foregroundColor(.blue)
                            .frame(width: 24)

                        VStack(alignment: .leading, spacing: 4) {
                            Text("Date & Time")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                            Text(formattedDateTime)
                                .font(.body)
                                .fontWeight(.medium)
                        }
                        Spacer()
                    }
                    .padding(.horizontal, 24)

                    // Location
                    HStack(spacing: 16) {
                        Image(systemName: "location.fill")
                            .font(.title3)
                            .foregroundColor(.blue)
                            .frame(width: 24)

                        VStack(alignment: .leading, spacing: 4) {
                            Text("Location")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                            Text(location)
                                .font(.body)
                                .fontWeight(.medium)
                        }
                        Spacer()
                    }
                    .padding(.horizontal, 24)

                    // Patient Info
                    VStack(alignment: .leading, spacing: 12) {
                        HStack {
                            Text("Patient Info")
                                .font(.headline)
                            Spacer()
                            Button("Change") {
                                dismiss()
                            }
                            .font(.subheadline)
                            .fontWeight(.medium)
                            .foregroundColor(.blue)
                        }

                        VStack(alignment: .leading, spacing: 4) {
                            Text(patientName.isEmpty ? "Peter John" : patientName)
                                .font(.body)
                                .fontWeight(.medium)
                            Text(patientPhone.isEmpty ? "+94 77 123 4567" : patientPhone)
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                    }
                    .padding(.horizontal, 24)

                    // Payment Summary
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Payment Summary")
                            .font(.headline)

                        VStack(spacing: 12) {
                            HStack {
                                Text("Consultation Fee")
                                    .font(.subheadline)
                                Spacer()
                                Text(String(format: "%.2f", consultationFee))
                                    .font(.subheadline)
                                    .fontWeight(.medium)
                            }

                            HStack {
                                Text("Discount")
                                    .font(.subheadline)
                                Spacer()
                                Text(discount > 0 ? String(format: "- %.2f", discount) : "-")
                                    .font(.subheadline)
                                    .foregroundColor(.green)
                            }

                            Divider()
                                .padding(.vertical, 4)

                            HStack {
                                Text("Total Amount")
                                    .font(.headline)
                                Spacer()
                                Text(String(format: "%.2f LKR", doctor.fee))
                                    .font(.title3)
                                    .fontWeight(.bold)
                                    .foregroundColor(.blue)
                            }
                        }
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(16)
                    }
                    .padding(.horizontal, 24)

                    Spacer(minLength: 40)
                }
            }

            // Cancel and Proceed
            HStack(spacing: 16) {
                Button(action: {
                    dismiss()
                }) {
                    Text("Cancel")
                        .font(.headline)
                        .foregroundColor(.gray)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 18)
                        .background(Color(.systemGray5))
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                }

                NavigationLink(
                    destination: PaymentView(
                        doctor: doctor,
                        selectedDate: selectedDate,
                        selectedTimeSlot: selectedTimeSlot,
                        patientName: patientName,
                        patientPhone: patientPhone,
                        location: location,
                        totalAmount: doctor.fee,
                        onFlowComplete: onFlowComplete                       )
                ) {
                    Text("Proceed")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 18)
                        .background(Color.blue)
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                }
            }
            .padding(.horizontal, 24)
            .padding(.vertical, 16)
            .background(Color(.systemBackground))
            .shadow(color: .black.opacity(0.1), radius: 12, y: -6)
        }
        .navigationBarHidden(true)
    }
}

#Preview {
    NavigationStack {
        AppointmentDetailsView(
            doctor: MockData.doctors[0],
            selectedDate: Date(),
            selectedTimeSlot: "01:00 PM",
            patientName: "Peter John",
            patientPhone: "+94 77 123 4567"
        )
    }
}
