//
//  DoctorHeader.swift
//  ios_cw1
//
//  Created by COBSCCOMP242P-74 on 2026-03-04.
//

import SwiftUI

struct DoctorHeader: View {
    let doctor: Doctor
    var onReviewsTapped: (() -> Void)? = nil

    var body: some View {
        VStack(spacing: 24) {
            // Main info row
            HStack(alignment: .top, spacing: 20) {
                // Left side
                VStack(alignment: .leading, spacing: 10) {
                    HStack(alignment: .center, spacing: 6) {
                        Image(systemName: "star.fill")
                            .foregroundStyle(.yellow)
                            .font(.title3)
                        Text(String(format: "%.1f", doctor.rating))
                            .font(.title3.bold())
                    }

                    Text(doctor.fullName)
                        .font(.title2)
                        .fontWeight(.semibold)
                        .lineLimit(1)
                        .minimumScaleFactor(0.9)

                    VStack(alignment: .leading, spacing: 4) {
                        Text(doctor.degree)
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                        Text(doctor.specialty)
                            .font(.headline)
                            .foregroundStyle(.blue)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)

                // Right side: photo
                profileImage
                    .frame(width: 110, height: 110)
            }
            .padding(.horizontal, 24)

            // Stats card
            HStack(spacing: 0) {
                StatItem(icon: "clock", value: doctor.experience, label: "Experience")
                Divider().frame(height: 48).padding(.vertical, 8)
                StatItem(icon: "person.3", value: doctor.patients, label: "Patients")
                Divider().frame(height: 48).padding(.vertical, 8)
                StatItem(icon: "star", value: doctor.reviews, label: "Reviews")
                    .onTapGesture {
                        onReviewsTapped?()
                    }
            }
            .padding(.vertical, 14)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(.ultraThinMaterial)
                    .shadow(color: .black.opacity(0.07), radius: 8, x: 0, y: 3)
            )
            .padding(.horizontal, 24)
        }
        .padding(.top, 12)
    }

    private var profileImage: some View {
        Group {
            if let imageName = doctor.imageName, let uiImage = UIImage(named: imageName) {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFill()
            } else {
                Image(systemName: "person.fill")
                    .resizable()
                    .scaledToFit()
                    .padding(20)
                    .foregroundStyle(.blue)
                    .background(Color.blue.opacity(0.12))
            }
        }
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.white, lineWidth: 4)
        )
        .shadow(color: .black.opacity(0.14), radius: 6, x: 0, y: 2)
    }
}

struct StatItem: View {
    let icon: String
    let value: String
    let label: String

    var body: some View {
        VStack(spacing: 5) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundStyle(.blue)
            Text(value)
                .font(.subheadline.bold())
            Text(label)
                .font(.caption2)
                .foregroundStyle(.gray)
        }
        .frame(maxWidth: .infinity)
        .multilineTextAlignment(.center)
    }
}

#Preview {
    DoctorHeader(doctor: MockData.doctors[0])
        .padding()
        .background(Color(.systemBackground))
}
