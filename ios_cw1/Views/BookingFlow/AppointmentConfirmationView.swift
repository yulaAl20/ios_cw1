//
//  AppointmentConfirmationView.swift
//  ios_cw1
//
//  Created by COBSCCOMP242P-74 on 2026-03-04.
//

import SwiftUI

struct AppointmentConfirmationView: View {
    let doctor: Doctor
    let selectedDate: Date
    let selectedTimeSlot: String
    let patientName: String
    let patientPhone: String
    let location: String
    let totalAmount: Double
    var onFlowComplete: (() -> Void)? = nil

    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var appointmentStore: AppointmentStore

    private var formattedDateTime: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEE, d MMM"
        let dateString = dateFormatter.string(from: selectedDate)
        return "\(dateString) • \(selectedTimeSlot)"
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
                Text("Appointment Confirmed")
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
                    // Success icon
                    Image(systemName: "checkmark.circle.fill")
                        .font(.system(size: 60))
                        .foregroundColor(.green)
                        .padding(.top, 20)

                    Text("Your appointment has been confirmed")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .multilineTextAlignment(.center)

                    // Details card
                    VStack(alignment: .leading, spacing: 20) {
                        // Doctor info
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
                            .frame(width: 50, height: 50)
                            .clipShape(Circle())

                            VStack(alignment: .leading, spacing: 2) {
                                Text("Dr. \(doctor.fullName)")
                                    .font(.headline)
                                Text(doctor.specialty)
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                            }
                            Spacer()
                        }

                        Divider()

                        // Date & Time
                        HStack {
                            Image(systemName: "calendar")
                                .foregroundColor(.blue)
                                .frame(width: 24)
                            Text("Date & Time")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                            Spacer()
                            Text(formattedDateTime)
                                .font(.body)
                                .fontWeight(.medium)
                        }

                        // Location
                        HStack {
                            Image(systemName: "location.fill")
                                .foregroundColor(.blue)
                                .frame(width: 24)
                            Text("Location")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                            Spacer()
                            Text(location)
                                .font(.body)
                                .fontWeight(.medium)
                                .multilineTextAlignment(.trailing)
                        }

                        // Patient info
                        HStack {
                            Image(systemName: "person.fill")
                                .foregroundColor(.blue)
                                .frame(width: 24)
                            VStack(alignment: .leading, spacing: 2) {
                                Text("Patient")
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                                Text(patientName.isEmpty ? "Peter John" : patientName)
                                    .font(.body)
                                    .fontWeight(.medium)
                                Text(patientPhone.isEmpty ? "+94 77 123 4567" : patientPhone)
                                    .font(.caption)
                                    .foregroundColor(.gray)
                            }
                            Spacer()
                        }

                        Divider()

                        // Total Amount
                        HStack {
                            Text("Total Amount")
                                .font(.headline)
                            Spacer()
                            Text(String(format: "LKR %.2f", totalAmount))
                                .font(.title3)
                                .fontWeight(.bold)
                                .foregroundColor(.blue)
                        }
                    }
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(20)
                    .padding(.horizontal, 24)

                    Spacer(minLength: 40)
                }
            }

            // Back to Home button
            VStack {
                Button(action: {
                    print("onFlowComplete is \(onFlowComplete == nil ? "nil" : "set")")
                    let appointment = AppointmentDetails(
                        doctorName: doctor.fullName,
                        specialty: doctor.specialty,
                        dateTime: formattedDateTime,
                        location: location,
                        patientName: patientName.isEmpty ? "Peter John" : patientName,
                        patientPhone: patientPhone.isEmpty ? "+94 77 123 4567" : patientPhone,
                        totalAmount: totalAmount
                    )
                    appointmentStore.currentAppointment = appointment
                    
                    if let onFlowComplete = onFlowComplete {
                        onFlowComplete()
                    } else {
                        print("onFlowComplete is nil – falling back to dismiss")
                        dismiss()
                    }
                }) {
                    Text("Back to Home")
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
        AppointmentConfirmationView(
            doctor: Doctor(
                firstName: "Jenny",
                lastName: "Wilson",
                degree: "DMD",
                specialty: "General Physician",
                rating: 4.9,
                imageName: nil,
                availableTime: "Today, 9:30 AM",
                specialtyType: .general,
                experience: "7 Years",
                patients: "5.9k+",
                reviews: "3.8k+",
                fee: 2300.00,
                timeSlots: [],
                bio: "Sample bio",
                availability: "Monday–Friday"
            ),
            selectedDate: Date(),
            selectedTimeSlot: "01:00 PM",
            patientName: "Peter John",
            patientPhone: "+94 77 123 4567",
            location: "Room 12, 1st Floor, Main Wing",
            totalAmount: 2300.00
        )
        .environmentObject(AppointmentStore())
    }
}
