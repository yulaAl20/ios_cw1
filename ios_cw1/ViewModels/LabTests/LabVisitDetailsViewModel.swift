//
//  LabVisitDetailsViewModel.swift
//  ios_cw1
//
//  Created by Yulani Alwis on 2026-03-08.
//

import Foundation
import SwiftUI
import Combine

class LabVisitDetailsViewModel: ObservableObject {

    @Published var selectedTests: [LabTest]
    @Published var totalPrice: Double

    @Published var selectedLocation: LabLocation
    @Published var locations: [LabLocation] = [
        LabLocation(name: "CityCare Main Lab",       address: "2nd Floor, Diagnostic Wing"),
        LabLocation(name: "ClinicFlow Central Lab",  address: "Ground Floor, Building A"),
        LabLocation(name: "MedPlus Diagnostics",     address: "1st Floor, Healthcare Complex"),
        LabLocation(name: "HealthFirst Lab",         address: "3rd Floor, Medical Tower")
    ]

    @Published var selectedDate: Date    = Date()
    @Published var selectedTimeSlot: TimeSlot
    @Published var timeSlots: [TimeSlot] = [
        TimeSlot(startTime: "08:00 AM", endTime: "08:30 AM"),
        TimeSlot(startTime: "08:30 AM", endTime: "09:00 AM"),
        TimeSlot(startTime: "09:00 AM", endTime: "09:30 AM"),
        TimeSlot(startTime: "09:30 AM", endTime: "10:00 AM"),
        TimeSlot(startTime: "10:00 AM", endTime: "10:30 AM"),
        TimeSlot(startTime: "10:30 AM", endTime: "11:00 AM"),
        TimeSlot(startTime: "11:00 AM", endTime: "11:30 AM"),
        TimeSlot(startTime: "02:00 PM", endTime: "02:30 PM"),
        TimeSlot(startTime: "02:30 PM", endTime: "03:00 PM"),
        TimeSlot(startTime: "03:00 PM", endTime: "03:30 PM"),
        TimeSlot(startTime: "03:30 PM", endTime: "04:00 PM"),
        TimeSlot(startTime: "04:00 PM", endTime: "04:30 PM")
    ]

    @Published var savedUserName: String  = ""
    @Published var savedUserEmail: String = ""
    @Published var savedUserPhone: String = ""
    @Published var savedUserDOB: Date?    = nil

    var isSelfSelected: Bool {
        selectedPatient == selfPatientLabel
    }

    private var selfPatientLabel: String {
        savedUserName.isEmpty ? "Myself (Self)" : "\(savedUserName) (Self)"
    }

    @Published var selectedPatient: String = ""
    @Published var patients: [String]      = []

    @Published var isProcessingPayment: Bool = false
    @Published var paymentSuccess: Bool      = false

    var formattedDate: String {
        let f = DateFormatter()
        f.dateFormat = "EEE, dd MMM"
        return f.string(from: selectedDate)
    }

    var testCount: Int { selectedTests.count }


    init(selectedTests: [LabTest], totalPrice: Double) {
        self.selectedTests = selectedTests
        self.totalPrice    = totalPrice
        self.selectedLocation = LabLocation(name: "CityCare Main Lab", address: "2nd Floor, Diagnostic Wing")
        self.selectedTimeSlot = TimeSlot(startTime: "09:00 AM", endTime: "09:30 AM")

        loadSavedUserInfo()
    }

    private func loadSavedUserInfo() {
        let defaults = UserDefaults.standard

        savedUserName  = defaults.string(forKey: "userName")        ?? ""
        savedUserEmail = defaults.string(forKey: "userEmail")       ?? ""
        savedUserPhone = defaults.string(forKey: "userPhoneNumber") ?? ""

        let dobInterval = defaults.double(forKey: "userDOB")
        if dobInterval != 0 {
            savedUserDOB = Date(timeIntervalSince1970: dobInterval)
        }

        let selfLabel = selfPatientLabel
        selectedPatient = selfLabel

        patients = [
            selfLabel,
            "Jane Doe (Spouse)",
            "Alex Doe (Child)",
            "+ Add Family Member"
        ]
    }

    func selectLocation(_ location: LabLocation) { selectedLocation = location }
    func selectTimeSlot(_ slot: TimeSlot)         { selectedTimeSlot = slot    }

    func selectPatient(_ patient: String) {
        guard patient != "+ Add Family Member" else { return }
        selectedPatient = patient
    }

    func processPayment(completion: @escaping (Bool) -> Void) {
        isProcessingPayment = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) { [weak self] in
            self?.isProcessingPayment = false
            self?.paymentSuccess = true
            completion(true)
        }
    }

    func resetPaymentState() {
        isProcessingPayment = false
        paymentSuccess      = false
    }

    var formattedDOB: String {
        guard let dob = savedUserDOB else { return "" }
        let f = DateFormatter()
        f.dateStyle = .medium
        return f.string(from: dob)
    }
}
