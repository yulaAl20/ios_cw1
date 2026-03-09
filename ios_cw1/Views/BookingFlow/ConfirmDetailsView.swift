//
//  ConfirmDetailsView.swift
//  ios_cw1
//
//  Created by COBSCCOMP242P-74 on 2026-03-04.
//

import SwiftUI

struct ConfirmDetailsView: View {
    let doctor: Doctor
    let selectedDate: Date
    let selectedTimeSlot: String
    var onFlowComplete: (() -> Void)? = nil

    @Environment(\.dismiss) private var dismiss
    @State private var name = ""
    @State private var phone = ""
    @State private var originalName = ""
    @State private var originalPhone = ""
    @State private var isEditing = false

    @AppStorage("userName") private var storedName = ""
    @AppStorage("userPhoneNumber") private var storedPhone = "+94 77 123 4567"

    private let location = "Room 12, 1st Floor, Main Wing"

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
                Text("Confirm Details")
                    .font(.headline)
                    .fontWeight(.semibold)
                Spacer()
                Color.clear.frame(width: 44, height: 44)
            }
            .padding(.horizontal, 24)
            .padding(.top, 16)
            .padding(.bottom, 8)

            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 24) {
                    // Doctor header
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
                        Spacer()
                    }
                    .padding(.horizontal, 24)

                    VStack(spacing: 16) {
                        InfoRow(icon: "calendar", title: "Date & Time", value: formattedDateTime)
                        InfoRow(icon: "location.fill", title: "Location", value: location)
                        Divider()
                            .padding(.horizontal, 8)
                        HStack {
                            Image(systemName: "creditcard.fill")
                                .font(.title3)
                                .foregroundColor(.blue)
                                .frame(width: 24)

                            VStack(alignment: .leading, spacing: 4) {
                                Text("Total Amount")
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                                Text("Consultation Fee")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                            }
                            Spacer()
                            Text(String(format: "%.2f LKR", doctor.fee))
                                .font(.title3)
                                .fontWeight(.bold)
                                .foregroundColor(.blue)
                        }
                    }
                    .padding(.vertical, 12)
                    .padding(.horizontal, 20)
                    .background(Color(.systemGray6))
                    .cornerRadius(20)
                    .padding(.horizontal, 24)

                    VStack(alignment: .center, spacing: 20) {
                        Text("Confirm Your Details")
                            .font(.title3)
                            .fontWeight(.semibold)
                            .frame(maxWidth: .infinity, alignment: .center)

                        if isEditing {
                            VStack(spacing: 16) {
                                // Name field
                                VStack(alignment: .leading, spacing: 6) {
                                    Text("Name")
                                        .font(.subheadline)
                                        .foregroundColor(.gray)
                                    TextField("", text: $name)
                                        .placeholder(when: name.isEmpty) {
                                            Text(storedName.isEmpty ? "Add your name" : storedName)
                                                .foregroundColor(.gray.opacity(0.6))
                                        }
                                        .padding(.horizontal, 12)
                                        .padding(.vertical, 10)
                                        .background(Color(.systemGray5))
                                        .cornerRadius(12)
                                        .font(.body)
                                }

                                // Phone number field
                                VStack(alignment: .leading, spacing: 6) {
                                    Text("Phone Number")
                                        .font(.subheadline)
                                        .foregroundColor(.gray)
                                    TextField("", text: $phone)
                                        .placeholder(when: phone.isEmpty) {
                                            Text(storedPhone)
                                                .foregroundColor(.gray.opacity(0.6))
                                        }
                                        .padding(.horizontal, 12)
                                        .padding(.vertical, 10)
                                        .background(Color(.systemGray5))
                                        .cornerRadius(12)
                                        .font(.body)
                                        .keyboardType(.phonePad)
                                }
                            }

                            HStack(spacing: 20) {
                                Button("Cancel") {
                                    name = originalName
                                    phone = originalPhone
                                    isEditing = false
                                }
                                .font(.subheadline)
                                .fontWeight(.medium)
                                .foregroundColor(.gray)
                                .padding(.horizontal, 20)
                                .padding(.vertical, 10)
                                .background(Color(.systemGray5))
                                .cornerRadius(20)

                                Button("Save") {
                                    originalName = name
                                    originalPhone = phone
                                    isEditing = false
                                }
                                .font(.subheadline)
                                .fontWeight(.medium)
                                .foregroundColor(.white)
                                .padding(.horizontal, 20)
                                .padding(.vertical, 10)
                                .background(Color.blue)
                                .cornerRadius(20)
                            }
                            .padding(.top, 8)
                        } else {
                            VStack(spacing: 16) {
                                HStack {
                                    Text("Name")
                                        .font(.subheadline)
                                        .foregroundColor(.gray)
                                    Spacer()
                                    Text(name.isEmpty ? (storedName.isEmpty ? "Add your name" : storedName) : name)
                                        .font(.body)
                                        .fontWeight(.medium)
                                }
                                HStack {
                                    Text("Phone Number")
                                        .font(.subheadline)
                                        .foregroundColor(.gray)
                                    Spacer()
                                    Text(phone.isEmpty ? storedPhone : phone)
                                        .font(.body)
                                        .fontWeight(.medium)
                                }
                            }
                            .padding(.horizontal, 4)

                            Button(action: {
                                originalName = name
                                originalPhone = phone
                                isEditing = true
                            }) {
                                Text("Edit")
                                    .font(.subheadline)
                                    .fontWeight(.medium)
                                    .foregroundColor(.blue)
                            }
                            .padding(.top, 8)
                        }
                    }
                    .padding(.vertical, 24)
                    .padding(.horizontal, 20)
                    .background(.ultraThinMaterial)
                    .cornerRadius(24)
                    .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 4)
                    .padding(.horizontal, 24)

                    Spacer(minLength: 40)
                }
            }

            if !isEditing {
                VStack {
                    NavigationLink(
                        destination: AppointmentDetailsView(
                            doctor: doctor,
                            selectedDate: selectedDate,
                            selectedTimeSlot: selectedTimeSlot,
                            patientName: name.isEmpty ? (storedName.isEmpty ? "Peter John" : storedName) : name,
                            patientPhone: phone.isEmpty ? storedPhone : phone,
                            onFlowComplete: onFlowComplete
                        )
                    ) {
                        Text("Proceed")
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
                .transition(.move(edge: .bottom).combined(with: .opacity))
            }
        }
        .navigationBarHidden(true)
        .animation(.easeInOut(duration: 0.2), value: isEditing)
        .onAppear {
            if name.isEmpty { name = storedName }
            if phone.isEmpty { phone = storedPhone }
            originalName = name
            originalPhone = phone
        }
    }
}

struct InfoRow: View {
    let icon: String
    let title: String
    let value: String

    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundColor(.blue)
                .frame(width: 24)

            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.subheadline)
                    .foregroundColor(.gray)
                Text(value)
                    .font(.body)
                    .fontWeight(.medium)
            }
            Spacer()
        }
    }
}

extension View {
    func placeholder<Content: View>(
        when shouldShow: Bool,
        alignment: Alignment = .leading,
        @ViewBuilder placeholder: () -> Content
    ) -> some View {
        ZStack(alignment: alignment) {
            self
            if shouldShow {
                placeholder().allowsHitTesting(false)
            }
        }
    }
}

#Preview {
    NavigationStack {
        ConfirmDetailsView(
            doctor: MockData.doctors[0],
            selectedDate: Date(),
            selectedTimeSlot: "01:00 PM"
        )
    }
}
