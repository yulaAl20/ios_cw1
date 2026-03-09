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

    @State private var searchText = ""
    @State private var selectedSpecialty = "All Specialists"

    let specialties = ["All Specialists", "General", "Cardiology"]
    let doctors = MockData.doctors

    var body: some View {
        VStack(spacing: 0) {
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 24) {
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

                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 12) {
                            ForEach(specialties, id: \.self) { specialty in
                                CategoryChip(title: specialty, isSelected: selectedSpecialty == specialty)
                                    .onTapGesture {
                                        selectedSpecialty = specialty
                                    }
                            }
                        }
                        .padding(.horizontal, 2)
                    }

                    // Doctor list with navigation
                    VStack(alignment: .leading, spacing: 16) {
                        ForEach(filteredDoctors) { doctor in
                            NavigationLink(destination: DoctorDetailView(doctor: doctor, onFlowComplete: onFlowComplete)) {  // <-- Pass closure
                                DoctorCard(doctor: doctor)
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                    }

                    Spacer(minLength: 40)
                }
                .padding(.horizontal, 20)
                .padding(.top, 8)
            }
            .background(Color(.systemBackground))
        }
        .safeAreaInset(edge: .bottom) {
            FloatingNavBarView(selectedTab: $selectedTab)
        }
        .navigationTitle("Choose Your Doctor")
        .navigationBarTitleDisplayMode(.inline)
    }

    // Filter doctors (unchanged)
    var filteredDoctors: [Doctor] {
        var result = doctors
        if selectedSpecialty != "All Specialists" {
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
