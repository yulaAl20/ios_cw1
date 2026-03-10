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
    @EnvironmentObject private var appointmentStore: AppointmentStore

    @State private var selectedPatient: String = ""
    @State private var phone: String = ""
    @State private var isEditingPhone = false
    @State private var showPhoneWarning = false
    @State private var showPatientPicker = false
    @State private var showAddPatientSheet = false
    @State private var showPaymentSheet = false
    @State private var patients: [String] = []

    private let defaultName = "Yulani Alwis"
    private let defaultPhone = "0777777777"
    private let location = "Room 12, 1st Floor, Main Wing"

    private var formattedDateTime: String {
        let f = DateFormatter()
        f.dateFormat = "EEE, d MMM"
        return "\(f.string(from: selectedDate)) • \(selectedTimeSlot)"
    }

    private var displayPhone: String {
        phone.isEmpty ? defaultPhone : phone
    }

    private var displayPatientName: String {
        selectedPatient.isEmpty ? "\(defaultName) (Self)" : selectedPatient
    }

    // Extract just the name part
    private var patientNameOnly: String {
        displayPatientName.components(separatedBy: " (").first ?? displayPatientName
    }

    var body: some View {
        VStack(spacing: 0) {
            // Header
            HStack {
                Button(action: { dismiss() }) {
                    Image(systemName: "chevron.left")
                        .font(.title2)
                        .foregroundColor(.primary)
                }
                Spacer()
                Text("Booking Details")
                    .font(.headline)
                    .fontWeight(.semibold)
                Spacer()
                Color.clear.frame(width: 44, height: 44)
            }
            .padding(.horizontal, 20)
            .padding(.top, 16)
            .padding(.bottom, 8)

            ScrollView(showsIndicators: false) {
                VStack(spacing: 20) {
                    appointmentSummarySection
                    patientSelectionSection
                    contactNumberSection
                    Spacer().frame(height: 100)
                }
                .padding(.top, 12)
            }

            proceedButton
        }
        .navigationBarHidden(true)
        .sheet(isPresented: $showPatientPicker) {
            BookingPatientPickerSheet(
                patients: patients,
                selectedPatient: $selectedPatient,
                isPresented: $showPatientPicker,
                onAddNew: {
                    showPatientPicker = false
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                        showAddPatientSheet = true
                    }
                }
            )
            .presentationDetents([.height(360)])
        }
        .sheet(isPresented: $showAddPatientSheet) {
            AddPatientSheet(
                isPresented: $showAddPatientSheet,
                onAdd: { name, relationship in
                    let entry = "\(name) (\(relationship))"
                    patients.insert(entry, at: patients.count)
                    selectedPatient = entry
                }
            )
            .presentationDetents([.height(340)])
        }
        .sheet(isPresented: $showPaymentSheet) {
            BookingPaymentConfirmationView(
                doctor: doctor,
                selectedDate: selectedDate,
                selectedTimeSlot: selectedTimeSlot,
                patientName: patientNameOnly,
                patientPhone: displayPhone,
                location: location,
                totalPrice: doctor.fee,
                isPresented: $showPaymentSheet
            )
            .environmentObject(appointmentStore)
            .presentationDetents([.large])
            .interactiveDismissDisabled()
        }
        .onAppear {
            selectedPatient = "\(defaultName) (Self)"
            phone = defaultPhone
            patients = ["\(defaultName) (Self)"]
        }
    }

    // MARK: - Appointment Summary

    var appointmentSummarySection: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("Appointment Summary")
                .font(.system(size: 16, weight: .semibold))
                .padding(.horizontal, 16)
                .padding(.vertical, 14)

            Divider().padding(.leading, 16)

            // Doctor
            HStack(spacing: 12) {
                Image(systemName: "stethoscope")
                    .font(.system(size: 16))
                    .foregroundColor(.blue)
                    .frame(width: 24)
                VStack(alignment: .leading, spacing: 2) {
                    Text("Doctor")
                        .font(.system(size: 13))
                        .foregroundColor(.gray)
                    Text("Dr. \(doctor.fullName) • \(doctor.specialty)")
                        .font(.system(size: 15, weight: .medium))
                }
                Spacer()
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)

            Divider().padding(.leading, 56)

            // Date & Time
            HStack(spacing: 12) {
                Image(systemName: "calendar")
                    .font(.system(size: 16))
                    .foregroundColor(.blue)
                    .frame(width: 24)
                VStack(alignment: .leading, spacing: 2) {
                    Text("Date & Time")
                        .font(.system(size: 13))
                        .foregroundColor(.gray)
                    Text(formattedDateTime)
                        .font(.system(size: 15, weight: .medium))
                }
                Spacer()
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)

            Divider().padding(.leading, 56)

            // Location
            HStack(spacing: 12) {
                Image(systemName: "location.fill")
                    .font(.system(size: 16))
                    .foregroundColor(.blue)
                    .frame(width: 24)
                VStack(alignment: .leading, spacing: 2) {
                    Text("Location")
                        .font(.system(size: 13))
                        .foregroundColor(.gray)
                    Text(location)
                        .font(.system(size: 15, weight: .medium))
                }
                Spacer()
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)

            Divider().padding(.leading, 56)

            // Consultation Fee
            HStack {
                Image(systemName: "creditcard.fill")
                    .font(.system(size: 16))
                    .foregroundColor(.blue)
                    .frame(width: 24)

                Text("Consultation Fee")
                    .font(.system(size: 14))
                    .foregroundColor(.gray)

                Spacer()

                Text(String(format: "LKR %.2f", doctor.fee))
                    .font(.system(size: 17, weight: .bold))
                    .foregroundColor(.blue)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
        }
        .background(Color.white)
        .cornerRadius(12)
        .padding(.horizontal, 20)
    }

    // MARK: - Patient Selection

    var patientSelectionSection: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("Who is this appointment for?")
                .font(.system(size: 16, weight: .semibold))
                .padding(.horizontal, 16)
                .padding(.vertical, 14)

            Divider().padding(.leading, 16)

            Button(action: { showPatientPicker = true }) {
                HStack {
                    Image(systemName: "person.fill")
                        .font(.system(size: 16))
                        .foregroundColor(.blue)
                        .frame(width: 24)

                    Text("Patient")
                        .font(.system(size: 15))
                        .foregroundColor(.primary)

                    Spacer()

                    Text(displayPatientName)
                        .font(.system(size: 15, weight: .medium))
                        .foregroundColor(.blue)

                    Image(systemName: "chevron.right")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(.gray)
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 14)
            }
        }
        .background(Color.white)
        .cornerRadius(12)
        .padding(.horizontal, 20)
    }

    // MARK: - Contact Number

    var contactNumberSection: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("Contact Number")
                .font(.system(size: 16, weight: .semibold))
                .padding(.horizontal, 16)
                .padding(.vertical, 14)

            Divider().padding(.leading, 16)

            VStack(alignment: .leading, spacing: 10) {
                HStack {
                    Image(systemName: "phone.fill")
                        .font(.system(size: 16))
                        .foregroundColor(.blue)
                        .frame(width: 24)

                    if isEditingPhone {
                        TextField("Enter phone number", text: $phone)
                            .font(.system(size: 15))
                            .keyboardType(.phonePad)
                            .textFieldStyle(.plain)
                    } else {
                        Text(displayPhone)
                            .font(.system(size: 15, weight: .medium))
                    }

                    Spacer()

                    Button(action: {
                        if isEditingPhone {
                            isEditingPhone = false
                            if phone != defaultPhone && !phone.isEmpty {
                                showPhoneWarning = true
                            } else {
                                showPhoneWarning = false
                            }
                        } else {
                            isEditingPhone = true
                        }
                    }) {
                        Text(isEditingPhone ? "Save" : "Edit")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(.blue)
                    }
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 12)

                if showPhoneWarning {
                    HStack(spacing: 8) {
                        Image(systemName: "info.circle.fill")
                            .font(.system(size: 14))
                            .foregroundColor(.orange)

                        Text("All messages regarding your booking will be sent to this mobile number.")
                            .font(.system(size: 13))
                            .foregroundColor(.orange)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                    .padding(.horizontal, 16)
                    .padding(.bottom, 12)
                    .transition(.opacity.combined(with: .move(edge: .top)))
                }
            }
        }
        .background(Color.white)
        .cornerRadius(12)
        .padding(.horizontal, 20)
        .animation(.easeInOut(duration: 0.2), value: showPhoneWarning)
    }

    // MARK: - Proceed Button

    var proceedButton: some View {
        VStack {
            Button(action: { showPaymentSheet = true }) {
                Text("Proceed to Pay")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 18)
                    .background(Color.blue)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 16)
            .background(Color(.systemBackground))
            .shadow(color: .black.opacity(0.1), radius: 12, y: -6)
        }
    }
}


// MARK: - Booking Patient Picker Sheet

struct BookingPatientPickerSheet: View {
    let patients: [String]
    @Binding var selectedPatient: String
    @Binding var isPresented: Bool
    var onAddNew: () -> Void

    var body: some View {
        NavigationStack {
            List {
                ForEach(patients, id: \.self) { patient in
                    Button(action: {
                        selectedPatient = patient
                        isPresented = false
                    }) {
                        HStack {
                            VStack(alignment: .leading, spacing: 4) {
                                let parts = patient.components(separatedBy: " (")
                                Text(parts.first ?? patient)
                                    .font(.system(size: 16, weight: .medium))
                                    .foregroundColor(.primary)
                                if parts.count > 1 {
                                    Text(parts[1].replacingOccurrences(of: ")", with: ""))
                                        .font(.system(size: 13))
                                        .foregroundColor(.gray)
                                }
                            }

                            Spacer()

                            if selectedPatient == patient {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundColor(.blue)
                            }
                        }
                    }
                }

                Button(action: onAddNew) {
                    HStack {
                        Image(systemName: "plus.circle.fill")
                            .foregroundColor(.blue)
                        Text("Add Someone")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(.blue)
                    }
                }
            }
            .navigationTitle("Booking For")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") { isPresented = false }
                }
            }
        }
    }
}


// MARK: - Add Patient Sheet

struct AddPatientSheet: View {
    @Binding var isPresented: Bool
    var onAdd: (String, String) -> Void

    @State private var name = ""
    @State private var selectedRelationship = "Child"
    let relationships = ["Child", "Spouse", "Parent", "Friend", "Other"]

    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Name")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                    TextField("Enter name", text: $name)
                        .padding(12)
                        .background(Color(.systemGray6))
                        .cornerRadius(12)
                }

                VStack(alignment: .leading, spacing: 8) {
                    Text("Relationship")
                        .font(.subheadline)
                        .foregroundColor(.gray)

                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 10) {
                            ForEach(relationships, id: \.self) { rel in
                                Button(action: { selectedRelationship = rel }) {
                                    Text(rel)
                                        .font(.system(size: 14, weight: .medium))
                                        .padding(.horizontal, 16)
                                        .padding(.vertical, 10)
                                        .background(selectedRelationship == rel ? Color.blue : Color(.systemGray6))
                                        .foregroundColor(selectedRelationship == rel ? .white : .primary)
                                        .cornerRadius(20)
                                }
                            }
                        }
                    }
                }

                Button(action: {
                    if !name.trimmingCharacters(in: .whitespaces).isEmpty {
                        onAdd(name, selectedRelationship)
                        isPresented = false
                    }
                }) {
                    Text("Add")
                        .font(.system(size: 17, weight: .semibold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                        .background(name.trimmingCharacters(in: .whitespaces).isEmpty ? Color.gray : Color.blue)
                        .cornerRadius(14)
                }
                .disabled(name.trimmingCharacters(in: .whitespaces).isEmpty)

                Spacer()
            }
            .padding(20)
            .navigationTitle("Add Someone")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") { isPresented = false }
                }
            }
        }
    }
}


// MARK: - InfoRow

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
        .environmentObject(AppointmentStore())
    }
}
