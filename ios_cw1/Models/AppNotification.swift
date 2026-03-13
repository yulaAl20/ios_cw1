//
//  AppNotification.swift
//  ios_cw1
//

import Foundation

enum AppNotificationCategory: String, CaseIterable, Identifiable {
    case appointment = "Appointment"
    case pharmacy = "Pharmacy"
    case labs = "Labs"
    case cancellations = "Cancellations"

    var id: String { rawValue }
}

struct AppNotification: Identifiable {
    let id = UUID()
    let category: AppNotificationCategory
    let title: String
    let message: String
    let date: Date
    var isRead: Bool = false
}

extension AppNotification {
    static var sample: [AppNotification] {
        let now = Date()
        return [
            AppNotification(
                category: .appointment,
                title: "Doctor running late",
                message: "Your doctor will be late 5 minutes from the given time.",
                date: Calendar.current.date(byAdding: .minute, value: -3, to: now)!
            ),
            AppNotification(
                category: .appointment,
                title: "Appointment confirmed",
                message: "Your appointment with Dr. Jenny Wilson is confirmed for 10:00 AM.",
                date: Calendar.current.date(byAdding: .hour, value: -2, to: now)!
            ),
            AppNotification(
                category: .pharmacy,
                title: "Order ready",
                message: "Your pharmacy order #CF-204 is ready for pickup at the main pharmacy.",
                date: Calendar.current.date(byAdding: .hour, value: -6, to: now)!
            ),
            AppNotification(
                category: .labs,
                title: "Lab report available",
                message: "Your Blood Test report is now available to view in Lab Reports.",
                date: Calendar.current.date(byAdding: .day, value: -1, to: now)!
            ),
            AppNotification(
                category: .cancellations,
                title: "Appointment cancelled",
                message: "Your appointment on Friday 3:30 PM was cancelled. Please reschedule.",
                date: Calendar.current.date(byAdding: .day, value: -3, to: now)!
            )
        ]
    }
}
