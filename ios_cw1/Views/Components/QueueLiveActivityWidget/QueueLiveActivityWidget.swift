//
//  QueueLiveActivityWidget.swift
//  ios_cw1
//
//  Created by Yulani Alwis on 2026-03-04.
//

import ActivityKit
import WidgetKit
import SwiftUI

struct QueueLiveActivityWidget: Widget {

    var body: some WidgetConfiguration {

        ActivityConfiguration(for: QueueActivityAttributes.self) { context in

            // Lock Screen UI
            HStack {
                Text("Q: #\(context.state.queueNumber)")
                    .font(.headline)

                Spacer()

                Text(context.state.queueTime)
                    .font(.subheadline)
            }
            .padding()

        } dynamicIsland: { context in

            DynamicIsland {

                DynamicIslandExpandedRegion(.leading) {
                    Text("Queue")
                }

                DynamicIslandExpandedRegion(.trailing) {
                    Text(context.state.queueTime)
                }

                DynamicIslandExpandedRegion(.bottom) {
                    Text("#\(context.state.queueNumber)")
                        .font(.title2)
                        .bold()
                }

            } compactLeading: {
                Text("#\(context.state.queueNumber)")
            } compactTrailing: {
                Text(context.state.queueTime)
            } minimal: {
                Text("\(context.state.queueNumber)")
            }
        }
    }
}

#Preview("Live Activity", as: .content, using: QueueActivityAttributes()) {
    QueueLiveActivityWidget()
} contentStates: {
    QueueActivityAttributes.ContentState(queueNumber: 15, queueTime: "9.15 AM")
    QueueActivityAttributes.ContentState(queueNumber: 3, queueTime: "9.45 AM")
}
