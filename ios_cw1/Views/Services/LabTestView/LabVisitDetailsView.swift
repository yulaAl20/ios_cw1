//
//  LabVisitDetailsView.swift
//  ios_cw1
//
//  Created by Yulani Alwis on 2026-03-08.
//

import SwiftUI

struct LabVisitDetailsView: View {
    
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var appointmentStore: AppointmentStore
    @EnvironmentObject var router: AppRouter
    @StateObject private var viewModel: LabVisitDetailsViewModel
    
    // Sheet states
    @State private var showLocationPicker = false
    @State private var showDatePicker = false
    @State private var showTimePicker = false
    @State private var showPatientPicker = false
    @State private var showPaymentSheet = false
    
    init(selectedTests: [LabTest], totalPrice: Double) {
        _viewModel = StateObject(wrappedValue: LabVisitDetailsViewModel(
            selectedTests: selectedTests,
            totalPrice: totalPrice
        ))
    }
    
    var body: some View {
        ZStack {
            Color(.systemGroupedBackground)
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                header
                
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 20) {
                        selectedTestsSection
                        labLocationSection
                        patientDetailsSection
                        Spacer().frame(height: 100)
                    }
                    .padding(.top, 20)
                }
                
                payNowButton
            }
        }
        .navigationBarHidden(true)
        .sheet(isPresented: $showLocationPicker) {
            LocationPickerSheet(
                locations: viewModel.locations,
                selectedLocation: $viewModel.selectedLocation,
                isPresented: $showLocationPicker
            )
            .presentationDetents([.medium])
        }
        .sheet(isPresented: $showDatePicker) {
            DatePickerSheet(
                selectedDate: $viewModel.selectedDate,
                isPresented: $showDatePicker
            )
            .presentationDetents([.medium])
        }
        .sheet(isPresented: $showTimePicker) {
            TimePickerSheet(
                timeSlots: viewModel.timeSlots,
                selectedTimeSlot: $viewModel.selectedTimeSlot,
                isPresented: $showTimePicker
            )
            .presentationDetents([.medium])
        }
        .sheet(isPresented: $showPatientPicker) {
            PatientPickerSheet(
                patients: viewModel.patients,
                selectedPatient: $viewModel.selectedPatient,
                isPresented: $showPatientPicker
            )
            .presentationDetents([.height(300)])
        }
        .sheet(isPresented: $showPaymentSheet) {
            LabPaymentConfirmationView(
                totalPrice: viewModel.totalPrice,
                isPresented: $showPaymentSheet,
                testName: viewModel.selectedTests.map { $0.name }.joined(separator: ", "),
                labLocation: viewModel.selectedLocation.name,
                selectedDate: viewModel.selectedDate,
                selectedTimeSlot: viewModel.selectedTimeSlot.startTime,
                patientName: viewModel.selectedPatient
            )
            .environmentObject(appointmentStore)
            .environmentObject(router)
            .presentationDetents([.large])
            .interactiveDismissDisabled()
        }
    }
}


// Header

extension LabVisitDetailsView {
    
    var header: some View {
        HStack {
            Button(action: { dismiss() }) {
                Image(systemName: "arrow.left")
                    .font(.system(size: 18, weight: .medium))
                    .foregroundColor(.black)
            }
            
            Spacer()
            
            Text("Lab Visit Details")
                .font(.system(size: 18, weight: .semibold))
            
            Spacer()
            
            Image(systemName: "arrow.left")
                .font(.system(size: 18, weight: .medium))
                .foregroundColor(.clear)
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 16)
        .background(Color(.systemBackground))
    }
}


//Selected Tests Section

extension LabVisitDetailsView {
    
    var selectedTestsSection: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack {
                Text("Selected Test (\(viewModel.testCount))")
                    .font(.system(size: 16, weight: .semibold))
                
                Spacer()
                
                Button("Change Test") {
                    dismiss()
                }
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(.blue)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 14)
            
            Divider()
                .padding(.leading, 16)
            
            ForEach(viewModel.selectedTests) { test in
                VStack(alignment: .leading, spacing: 4) {
                    Text(test.name)
                        .font(.system(size: 16, weight: .medium))
                    
                    Text("LKR \(String(format: "%.2f", test.price))")
                        .font(.system(size: 14))
                        .foregroundColor(.gray)
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
            }
        }
        .background(Color.white)
        .cornerRadius(12)
        .padding(.horizontal, 20)
    }
}


//  Lab Location Section

extension LabVisitDetailsView {
    
    var labLocationSection: some View {
        VStack(alignment: .leading, spacing: 0) {
            Button(action: { showLocationPicker = true }) {
                HStack {
                    Text("Lab Location")
                        .font(.system(size: 15))
                        .foregroundColor(.black)
                    
                    Spacer()
                    
                    Text(viewModel.selectedLocation.name)
                        .font(.system(size: 15))
                        .foregroundColor(.blue)
                    
                    Image(systemName: "chevron.right")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(.gray)
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 14)
            }
            
            Divider()
                .padding(.leading, 16)
            
            HStack {
                Text("Lab Address")
                    .font(.system(size: 15))
                    .foregroundColor(.black)
                
                Spacer()
                
                Text(viewModel.selectedLocation.address)
                    .font(.system(size: 15))
                    .foregroundColor(.gray)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 14)
            
            Divider()
                .padding(.leading, 16)
            
            Text("Visit Schedule")
                .font(.system(size: 16, weight: .semibold))
                .padding(.horizontal, 16)
                .padding(.top, 16)
                .padding(.bottom, 8)
            
            Divider()
                .padding(.leading, 16)
            
            Button(action: { showDatePicker = true }) {
                HStack {
                    Text("Date")
                        .font(.system(size: 15))
                        .foregroundColor(.black)
                    
                    Spacer()
                    
                    Text(viewModel.formattedDate)
                        .font(.system(size: 15))
                        .foregroundColor(.blue)
                    
                    Image(systemName: "calendar")
                        .font(.system(size: 14))
                        .foregroundColor(.blue)
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 14)
            }
            
            Divider()
                .padding(.leading, 16)
            
            Button(action: { showTimePicker = true }) {
                HStack {
                    Text("Time Slot")
                        .font(.system(size: 15))
                        .foregroundColor(.black)
                    
                    Spacer()
                    
                    Text(viewModel.selectedTimeSlot.displayText)
                        .font(.system(size: 15))
                        .foregroundColor(.blue)
                    
                    Image(systemName: "clock")
                        .font(.system(size: 14))
                        .foregroundColor(.blue)
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 14)
            }
        }
        .background(Color.white)
        .cornerRadius(12)
        .padding(.horizontal, 20)
    }
}


// Patient Details Section

extension LabVisitDetailsView {

    var patientDetailsSection: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("Patient Details")
                .font(.system(size: 16, weight: .semibold))
                .padding(.horizontal, 16)
                .padding(.vertical, 14)

            Divider()
                .padding(.leading, 16)

            // Patient picker row
            Button(action: { showPatientPicker = true }) {
                HStack {
                    Text("Patient")
                        .font(.system(size: 15))
                        .foregroundColor(.black)
                    Spacer()
                    Text(viewModel.selectedPatient)
                        .font(.system(size: 15))
                        .foregroundColor(.blue)
                    Image(systemName: "chevron.right")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(.gray)
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 14)
            }

            // Show saved profile fields only when "Self" is selected
            if viewModel.isSelfSelected {
                savedUserInfoRows
            }
        }
        .background(Color.white)
        .cornerRadius(12)
        .padding(.horizontal, 20)
    }

    @ViewBuilder
    var savedUserInfoRows: some View {
        let hasInfo = !viewModel.savedUserName.isEmpty || !viewModel.savedUserPhone.isEmpty

        if hasInfo {
            Divider().padding(.leading, 16)

            VStack(spacing: 0) {
                if !viewModel.savedUserName.isEmpty {
                    patientInfoRow(
                        icon: "person.fill",
                        label: "Full Name",
                        value: viewModel.savedUserName
                    )
                    if !viewModel.savedUserPhone.isEmpty {
                        Divider().padding(.leading, 52)
                    }
                }

                if !viewModel.savedUserPhone.isEmpty {
                    patientInfoRow(
                        icon: "phone.fill",
                        label: "Phone",
                        value: viewModel.savedUserPhone
                    )
                }
            }

            HStack(spacing: 6) {
                Image(systemName: "info.circle")
                    .font(.system(size: 12))
                    .foregroundColor(.blue)
                Text("Update your info in Profile → Edit Details")
                    .font(.system(size: 12))
                    .foregroundColor(.gray)
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 12)

        } else {
            Divider().padding(.leading, 16)
            
            .padding(.horizontal, 16)
            .padding(.vertical, 14)
        }
    }

    func patientInfoRow(icon: String, label: String, value: String) -> some View {
        HStack(spacing: 12) {
            ZStack {
                Circle()
                    .fill(Color.blue.opacity(0.1))
                    .frame(width: 32, height: 32)
                Image(systemName: icon)
                    .font(.system(size: 14))
                    .foregroundColor(Color(red: 0.15, green: 0.35, blue: 0.75))
            }
            Text(label)
                .font(.system(size: 15))
                .foregroundColor(.gray)
            Spacer()
            Text(value)
                .font(.system(size: 15))
                .foregroundColor(.black)
                .multilineTextAlignment(.trailing)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
    }
}


// Pay Now Button

extension LabVisitDetailsView {
    
    var payNowButton: some View {
        Button(action: { showPaymentSheet = true }) {
            Text("Pay Now")
                .font(.system(size: 17, weight: .semibold))
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(Color.blue)
                .cornerRadius(30)
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 16)
        .background(Color(.systemBackground))
    }
}


#Preview {
    NavigationStack {
        LabVisitDetailsView(
            selectedTests: [
                LabTest(name: "Fasting Blood Glucose", description: "Blood sugar test", price: 1500.00, category: .blood)
            ],
            totalPrice: 1500.00
        )
    }
}
