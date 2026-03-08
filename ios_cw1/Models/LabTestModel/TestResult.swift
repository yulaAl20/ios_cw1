//
//  TestResult.swift
//  ios_cw1
//
//  Created by Yulani Alwis on 2026-03-08.
//

import Foundation

struct TestResult: Identifiable, Codable {
    
    let id: UUID
    let testName: String
    let category: TestCategory
    let place: String
    let date: Date
    let doctorName: String
    let status: String
    let reportAvailable: Bool
    let reportURL: String?
    let icon: String
    
    init(
        id: UUID = UUID(),
        testName: String,
        category: TestCategory,
        place: String,
        date: Date,
        doctorName: String,
        status: String,
        reportAvailable: Bool = false,
        reportURL: String? = nil,
        icon: String
    ) {
        self.id = id
        self.testName = testName
        self.category = category
        self.place = place
        self.date = date
        self.doctorName = doctorName
        self.status = status
        self.reportAvailable = reportAvailable
        self.reportURL = reportURL
        self.icon = icon
    }
    
    //  Formatters
    
    private static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMM yyyy"
        return formatter
    }()
    
    private static let timeFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm a"
        return formatter
    }()
    
    //  Computed Properties
    
    var formattedDate: String {
        Self.dateFormatter.string(from: date)
    }
    
    var formattedTime: String {
        Self.timeFormatter.string(from: date)
    }
}
