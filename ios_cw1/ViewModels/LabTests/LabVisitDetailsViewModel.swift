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
    
    // Selected Tests (passed from BookTestView)
    @Published var selectedTests: [LabTest]
    @Published var totalPrice: Double
    
    // Lab Location
    @Published var selectedLocation: LabLocation
    @Published var locations: [LabLocation] = [
        LabLocation(name: "CityCare Main Lab", address: "2nd Floor, Diagnostic Wing"),
        LabLocation(name: "ClinicFlow Central Lab", address: "Ground Floor, Building A"),
        LabLocation(name: "MedPlus Diagnostics", address: "1st Floor, Healthcare Complex"),
        LabLocation(name: "HealthFirst Lab", address: "3rd Floor, Medical Tower")
    ]
    
    // Visit Schedule
    @Published var selectedDate: Date = Date()
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
    
    // Patient Details
    @Published var selectedPatient: String = "John Doe (Self)"
    @Published var patients: [String] = [
        "John Doe (Self)",
        "Jane Doe (Spouse)",
        "Alex Doe (Child)",
        "+ Add Family Member"
    ]
    
    // Payment State
    @Published var isProcessingPayment: Bool = false
    @Published var paymentSuccess: Bool = false
    
    // Computed Properties
    var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE, dd MMM"
        return formatter.string(from: selectedDate)
    }
    
    var testCount: Int {
        selectedTests.count
    }
    
    // Initializer
    init(selectedTests: [LabTest], totalPrice: Double) {
        self.selectedTests = selectedTests
        self.totalPrice = totalPrice
        
        // Set default selections
        self.selectedLocation = LabLocation(name: "CityCare Main Lab", address: "2nd Floor, Diagnostic Wing")
        self.selectedTimeSlot = TimeSlot(startTime: "09:00 AM", endTime: "09:30 AM")
    }
    
    // Actions
    func selectLocation(_ location: LabLocation) {
        selectedLocation = location
    }
    
    func selectTimeSlot(_ slot: TimeSlot) {
        selectedTimeSlot = slot
    }
    
    func selectPatient(_ patient: String) {
        if patient != "+ Add Family Member" {
            selectedPatient = patient
        }
    }
    
    func processPayment(completion: @escaping (Bool) -> Void) {
        isProcessingPayment = true
        
        // Simulate payment processing
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) { [weak self] in
            self?.isProcessingPayment = false
            self?.paymentSuccess = true
            completion(true)
        }
    }
    
    func resetPaymentState() {
        isProcessingPayment = false
        paymentSuccess = false
    }
}
