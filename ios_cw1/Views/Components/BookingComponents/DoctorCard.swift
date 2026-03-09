//
//  DoctorCard.swift
//  ios_cw1
//
//  Created by COBSCCOMP242P-74 on 2026-03-04.
//

import SwiftUI

struct DoctorCard: View {
    let doctor: Doctor

    var body: some View {
        HStack(spacing: 16) {
            // Doctor image
            ZStack {
                if let imageName = doctor.imageName, UIImage(named: imageName) != nil {
                    Image(imageName)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 70, height: 70)
                        .clipShape(Circle())
                } else {
                    Circle()
                        .fill(Color.blue.opacity(0.2))
                        .frame(width: 70, height: 70)
                        .overlay(
                            Image(systemName: "person.fill")
                                .font(.system(size: 30))
                                .foregroundColor(.blue)
                        )
                }
            }

            VStack(alignment: .leading, spacing: 4) {
                // Combine first and last name
                Text(doctor.fullName)
                    .font(.headline)

                HStack {
                    Text(doctor.specialty)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                    Spacer()
                    HStack(spacing: 2) {
                        Image(systemName: "star.fill")
                            .font(.caption)
                            .foregroundColor(.yellow)
                        Text(String(format: "%.1f", doctor.rating))
                            .font(.subheadline)
                            .fontWeight(.semibold)
                    }
                }

                HStack(spacing: 4) {
                    Circle()
                        .fill(Color.green)
                        .frame(width: 8, height: 8)
                    Text(doctor.availableTime)
                        .font(.caption)
                        .foregroundColor(.gray)
                }
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.05), radius: 4, x: 0, y: 2)
    }
}

#Preview {
    DoctorCard(doctor: Doctor(
        firstName: "Jenny",
        lastName: "Wilson",
        degree: "MD",
        specialty: "General Physician",
        rating: 4.9,
        imageName: nil,
        availableTime: "Today, 9:30 AM",
        specialtyType: .general,
        experience: "7 Years",
        patients: "5.9k+",
        reviews: "3.8k+",
        fee: 2300.00,
        timeSlots: ["7:30", "8:00", "8:30", "9:00"],
        bio: "",
        availability: "",
    ))
    .padding()
}
