//
//  ChooseDoctorView.swift
//  ios_cw1
//
//  Created by COBSCCOMP242P-74 on 2026-03-04.
//

import SwiftUI

struct ChooseDoctorView: View {
    @Binding var selectedTab: Int
    var onFlowComplete: (() -> Void)? = nil

    @Environment(\.dismiss) private var dismiss
    @State private var searchText = ""
    @State private var selectedSpecialty = "All"

    let specialties = ["All", "General", "Cardiology", "Gynecologist", "Dentist", "Dermatologist", "Pediatrician"]
    let doctors = MockData.doctors

    var body: some View {
        VStack(spacing: 0) {
            // Custom header with back button
            HStack {
                Button(action: { dismiss() }) {
                    Image(systemName: "chevron.left")
                        .font(.title2)
                        .foregroundColor(.primary)
                }
                Spacer()
                Text("Choose Your Doctor")
                    .font(.headline)
                    .fontWeight(.semibold)
                Spacer()
                Color.clear.frame(width: 44, height: 44)
            }
            .padding(.horizontal, 24)
            .padding(.top, 16)
            .padding(.bottom, 8)

            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 20) {
                    // Search bar
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.gray)
                        TextField("Search doctor, specialty...", text: $searchText)
                            .textFieldStyle(PlainTextFieldStyle())
                    }
                    .padding(12)
                    .background(Color.white)
                    .cornerRadius(16)
                    .shadow(color: .black.opacity(0.05), radius: 4, x: 0, y: 2)

                    // Filter chips
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 10) {
                            ForEach(specialties, id: \.self) { specialty in
                                CategoryChip(title: specialty, isSelected: selectedSpecialty == specialty)
                                    .onTapGesture {
                                        selectedSpecialty = specialty
                                    }
                            }
                        }
                        .padding(.horizontal, 2)
                    }

                    // Doctor list
                    VStack(spacing: 16) {
                        ForEach(filteredDoctors) { doctor in
                            doctorListItem(doctor: doctor)
                        }
                    }

                    Spacer(minLength: 40)
                }
                .padding(.horizontal, 20)
                .padding(.top, 8)
            }
            .background(Color(.systemBackground))
        }
        .navigationBarHidden(true)
    }

    // MARK: - Doctor List Item

    func doctorListItem(doctor: Doctor) -> some View {
        VStack(spacing: 0) {
            HStack(alignment: .top, spacing: 14) {
                // Doctor image
                ZStack {
                    if let imageName = doctor.imageName, UIImage(named: imageName) != nil {
                        Image(imageName)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 64, height: 64)
                            .clipShape(Circle())
                    } else {
                        Circle()
                            .fill(Color.blue.opacity(0.15))
                            .frame(width: 64, height: 64)
                            .overlay(
                                Image(systemName: "person.fill")
                                    .font(.system(size: 26))
                                    .foregroundColor(.blue)
                            )
                    }
                }

                VStack(alignment: .leading, spacing: 6) {
                    // Doctor name + More Info aligned on same row
                    HStack(alignment: .center) {
                        Text("Dr. \(doctor.fullName)")
                            .font(.system(size: 16, weight: .semibold))
                        Spacer()
                        NavigationLink(destination: DoctorDetailView(doctor: doctor, onFlowComplete: onFlowComplete)) {
                            Text("More Info")
                                .font(.system(size: 12, weight: .medium))
                                .foregroundColor(.blue)
                        }
                    }

                    Text(doctor.specialty)
                        .font(.system(size: 14))
                        .foregroundColor(.gray)

                    // Rating & experience info
                    HStack(spacing: 12) {
                        HStack(spacing: 4) {
                            Image(systemName: "star.fill")
                                .font(.system(size: 11))
                                .foregroundColor(.orange)
                            Text(String(format: "%.1f", doctor.rating))
                                .font(.system(size: 13, weight: .medium))
                        }

                        HStack(spacing: 4) {
                            Text(doctor.experience)
                                .font(.system(size: 13))
                                .foregroundColor(.gray)
                            Text("Experience")
                                .font(.system(size: 13))
                                .foregroundColor(.gray)
                        }

                        HStack(spacing: 4) {
                            Image(systemName: "person.2")
                                .font(.system(size: 11))
                                .foregroundColor(.green)
                            Text(doctor.patients)
                                .font(.system(size: 13))
                                .foregroundColor(.gray)
                        }
                    }

                    // Availability
                    HStack(spacing: 4) {
                        Circle()
                            .fill(Color.green)
                            .frame(width: 7, height: 7)
                        Text(doctor.availableTime)
                            .font(.system(size: 12))
                            .foregroundColor(.gray)
                    }
                }
            }
            .padding(.horizontal, 16)
            .padding(.top, 16)
            .padding(.bottom, 12)

            Divider()
                .padding(.horizontal, 16)

            // Fee + Book Appointment CTA
            HStack(alignment: .center) {
                VStack(alignment: .leading, spacing: 2) {
                    Text("Consultation Fee")
                        .font(.system(size: 12))
                        .foregroundColor(.gray)
                    Text(String(format: "LKR %.2f", doctor.fee))
                        .font(.system(size: 15, weight: .bold))
                        .foregroundColor(.blue)
                }

                Spacer()

                NavigationLink(destination: BookingTimeView(doctor: doctor, onFlowComplete: onFlowComplete)) {
                    Text("Book Appointment")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(.white)
                        .padding(.horizontal, 20)
                        .padding(.vertical, 11)
                        .background(Color.blue)
                        .cornerRadius(12)
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
        }
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.06), radius: 6, x: 0, y: 3)
    }

    // MARK: - Filter

    var filteredDoctors: [Doctor] {
        var result = doctors
        if selectedSpecialty != "All" {
            if let specialtyEnum = SpecialtyType(rawValue: selectedSpecialty) {
                result = result.filter { $0.specialtyType == specialtyEnum }
            }
        }
        if !searchText.isEmpty {
            result = result.filter {
                $0.firstName.localizedCaseInsensitiveContains(searchText) ||
                $0.lastName.localizedCaseInsensitiveContains(searchText) ||
                $0.specialty.localizedCaseInsensitiveContains(searchText)
            }
        }
        return result
    }
}

#Preview {
    NavigationStack {
        ChooseDoctorView(selectedTab: .constant(0))
    }
}
