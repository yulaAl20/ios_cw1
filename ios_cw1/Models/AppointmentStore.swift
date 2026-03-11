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

struct Appointment: Identifiable {
    let id = UUID()
    let doctorName: String
    let specialty: String
    let location: String
    let token: String?
    var queuePosition: Int?
    let date: Date
    let timeSlot: String
    let status: AppointmentStatus
    let isTest: Bool
    let patientName: String
    let patientPhone: String
    let totalAmount: Double
    
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
}
