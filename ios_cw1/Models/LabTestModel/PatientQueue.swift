//
//  PatientQueue.swift
//  ios_cw1
//
//  Created by Yulani Alwis on 2026-03-08.
//

import Foundation

enum QueueType: String, Codable {
    case consultation = "Consultation"
    case labScanReview = "Lab/Scan Review"
}

struct PatientQueue: Identifiable, Codable {
    let id: UUID
    let patientName: String
    let queueType: QueueType
    let queueNumber: Int
    let timestamp: Date
    let testName: String? // For lab/scan review patients
    
    init(
        id: UUID = UUID(),
        patientName: String,
        queueType: QueueType,
        queueNumber: Int,
        timestamp: Date = Date(),
        testName: String? = nil
    ) {
        self.id = id
        self.patientName = patientName
        self.queueType = queueType
        self.queueNumber = queueNumber
        self.timestamp = timestamp
        self.testName = testName
    }
}
