//
//  QueueActivityAttributes.swift
//  ios_cw1
//
//  Created by Yulani Alwis on 2026-03-04.
//


import ActivityKit

struct QueueActivityAttributes: ActivityAttributes {

    public struct ContentState: Codable, Hashable {
        var queueNumber: Int
        var queueTime: String
        var stage: String
        var stageTitle: String
        var stageDetail: String
    }
}
