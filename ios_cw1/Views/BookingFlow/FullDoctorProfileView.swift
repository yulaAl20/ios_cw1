//
//  FullDoctorProfileView.swift
//  ios_cw1
//
//  Created by COBSCCOMP242P-74 on 2026-03-04.
//

import SwiftUI

struct FullDoctorProfileView: View {
    let doctor: Doctor
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        ZStack(alignment: .bottom) {
            ScrollView(showsIndicators: false) {
                VStack(spacing: 24) {
                    HStack {
                        Button(action: { dismiss() }) {
                            Image(systemName: "chevron.left")
                                .font(.title2)
                                .foregroundColor(.primary)
                        }
                        Spacer()
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 16)
                    DoctorHeader(doctor: doctor)
                        .padding(.top, 8)

                    // About section
                    VStack(alignment: .leading, spacing: 12) {
                        Text("About \(doctor.firstName)")
                            .font(.title3)
                            .fontWeight(.semibold)

                        Text(doctor.bio)
                            .font(.body)
                            .foregroundColor(.secondary)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 24)

                    // Availability
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Available on:")
                            .font(.headline)
                            .foregroundColor(.primary)
                        Text(doctor.availability)
                            .font(.body)
                            .foregroundColor(.blue)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 24)

                    // Consultation fee card
                    HStack {
                        Text("Consultation Fee")
                            .font(.headline)
                            .foregroundColor(.gray)
                        Spacer()
                        Text(String(format: "%.2f LKR", doctor.fee))
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.blue)
                    }
                    .padding(.horizontal, 24)
                    .padding(.vertical, 20)
                    .background(
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Color.blue.opacity(0.06))
                    )
                    .padding(.horizontal, 24)
                    .padding(.top, 8)

                    Spacer(minLength: 100)
                }
            }
            .background(Color(.systemBackground))

            // Bottom book button
            VStack {
                Button(action: {
                    print("Book appointment for \(doctor.fullName)")
                }) {
                    Text("Book Appointment")
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
    FullDoctorProfileView(doctor: Doctor(
        firstName: "Jenny",
        lastName: "Wilson",
        degree: "DMD",
        specialty: "Dental Specialist",
        rating: 4.9,
        imageName: "jenny_wilson",
        availableTime: "Today, 9:30 AM",
        specialtyType: .dentist,
        experience: "7 Years",
        patients: "5.9k+",
        reviews: "3.8k+",
        fee: 2300.00,
        timeSlots: [],
        bio: "Dr. Jenny Wilson is a highly trusted dental specialist known for her gentle care and accurate treatment. With years of experience and thousands of satisfied patients, she focuses on providing effective solutions tailored to each patient’s needs. Her friendly approach helps patients feel comfortable and confident during every visit.",
        availability: "Monday – Friday"
    ))
}
