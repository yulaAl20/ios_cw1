//
//  QueueLiveActivityViewModel.swift
//  ios_cw1
//
//  Created by Yulani Alwis on 2026-03-04.
//

import ActivityKit
import Foundation

class QueueLiveActivityViewModel {

    static func start(
        queueNumber: Int,
        queueTime: String,
        stage: String = "inQueue",
        stageTitle: String = "In Queue",
        stageDetail: String = ""
    ) {
        guard ActivityAuthorizationInfo().areActivitiesEnabled else { return }

        let attributes = QueueActivityAttributes()
        let contentState = QueueActivityAttributes.ContentState(
            queueNumber: queueNumber,
            queueTime: queueTime,
            stage: stage,
            stageTitle: stageTitle,
            stageDetail: stageDetail
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

    static func updateAll(
        queueNumber: Int,
        queueTime: String,
        stage: String,
        stageTitle: String,
        stageDetail: String
    ) async {
        let newState = QueueActivityAttributes.ContentState(
            queueNumber: queueNumber,
            queueTime: queueTime,
            stage: stage,
            stageTitle: stageTitle,
            stageDetail: stageDetail
        )

        for activity in Activity<QueueActivityAttributes>.activities {
            await activity.update(using: newState)
        }
    }

    static func endAll() async {
        for activity in Activity<QueueActivityAttributes>.activities {
            await activity.end(dismissalPolicy: .immediate)
        }
    }
}
