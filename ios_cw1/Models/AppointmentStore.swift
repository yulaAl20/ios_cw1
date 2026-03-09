//
//  AppointmentStore.swift
//  ios_cw1
//
//  Created by COBSCCOMP242P-74 on 2026-03-07.
//

import Foundation
import Combine

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
    @Published var currentAppointment: AppointmentDetails?
}
