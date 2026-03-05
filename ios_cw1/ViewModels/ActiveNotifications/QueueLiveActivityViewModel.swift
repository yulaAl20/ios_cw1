//
//  QueueLiveActivityViewModel.swift
//  ios_cw1
//
//  Created by Yulani Alwis on 2026-03-04.
//

import ActivityKit
import Foundation

class QueueLiveActivityViewModel {

    static func start(queueNumber: Int, queueTime: String) {

        guard ActivityAuthorizationInfo().areActivitiesEnabled else {
            return
        }

        let attributes = QueueActivityAttributes()

        let contentState = QueueActivityAttributes.ContentState(
            queueNumber: queueNumber,
            queueTime: queueTime
        )

        do {
            _ = try Activity.request(
                attributes: attributes,
                contentState: contentState
            )
        } catch {
            print("Failed to start Live Activity: \(error)")
        }
    }
}
