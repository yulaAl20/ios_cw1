//
//  AppointmentStore.swift
//  ios_cw1
//
//  Created by COBSCCOMP242P-74 on 2026-03-07.
//

import Foundation
import Combine

enum AppointmentStatus: String, CaseIterable {
    case upcoming = "Upcoming"
    case ongoing = "Ongoing"
    case completed = "Completed"
}

enum AppointmentFlowStage: String, Equatable {
    case inQueue        = "In Queue"
    case withDoctor     = "With Doctor"
    case labQueue       = "Lab Queue"
    case labOngoing     = "Lab In Progress"
    case pharmacyPickup = "Collect Medicine"
    case done           = "Done"
}

struct LabReferral {
    let labName: String
    let labLocation: String
    var queuePosition: Int
    var totalInQueue: Int
}

struct PharmacyReferral {
    let pharmacyLocation: String
    let medicines: [String]
}

struct Appointment: Identifiable {
    let id = UUID()
    let doctorName: String
    let specialty: String
    let location: String
    let token: String?
    var queuePosition: Int?
    var totalInQueue: Int?
    let date: Date
    let timeSlot: String
    let status: AppointmentStatus
    let isTest: Bool
    let patientName: String
    let patientPhone: String
    let totalAmount: Double
    var flowStage: AppointmentFlowStage
    var labReferral: LabReferral?
    var pharmacyReferral: PharmacyReferral?

    var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "d MMMM yyyy"
        return formatter.string(from: date)
    }

    var formattedDateTime: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE, d MMM • h:mm a"
        return formatter.string(from: date)
    }
}

struct AppointmentDetails {
    let doctorName: String
    let specialty: String
    let dateTime: String
    let location: String
    let patientName: String
    let patientPhone: String
    let totalAmount: Double
}

class AppointmentStore: ObservableObject {
    @Published var appointments: [Appointment] = []
    @Published var currentAppointment: AppointmentDetails?

    init() {
        appointments.append(
            Appointment(
                doctorName: "Dr. Jenny Wilson",
                specialty: "General Physician",
                location: "OPD Room 2",
                token: "06",
                queuePosition: 3,
                totalInQueue: 17,
                date: Date(),
                timeSlot: "10:00 AM",
                status: .ongoing,
                isTest: false,
                patientName: "John Doe",
                patientPhone: "0762182199",
                totalAmount: 2300,
                flowStage: .inQueue,
                labReferral: LabReferral(
                    labName: "Full Blood Count",
                    labLocation: "OPD Lab 1, Ground Floor",
                    queuePosition: 5,
                    totalInQueue: 12
                ),
                pharmacyReferral: PharmacyReferral(
                    pharmacyLocation: "Main Pharmacy, Ground Floor",
                    medicines: ["Paracetamol 500mg", "Vitamin C 1000mg", "Amoxicillin 250mg"]
                )
            )
        )
    }

    var activeAppointment: Appointment? {
        appointments.first { $0.status == .ongoing }
    }

    func addAppointment(_ appointment: Appointment) {
        appointments.append(appointment)
        self.currentAppointment = AppointmentDetails(
            doctorName: appointment.doctorName,
            specialty: appointment.specialty,
            dateTime: appointment.formattedDateTime,
            location: appointment.location,
            patientName: appointment.patientName,
            patientPhone: appointment.patientPhone,
            totalAmount: appointment.totalAmount
        )
    }

    func removeAppointment(_ id: UUID) {
        appointments.removeAll { $0.id == id }
    }

    func updateFlowStage(for id: UUID, stage: AppointmentFlowStage) {
        if let index = appointments.firstIndex(where: { $0.id == id }) {
            appointments[index].flowStage = stage
        }
    }
}
