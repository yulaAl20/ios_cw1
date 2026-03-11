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

            lockScreenView(context: context)
                .activityBackgroundTint(lockScreenBackground(stage: context.state.stage))
                .activitySystemActionForegroundColor(.white)

        } dynamicIsland: { context in

            DynamicIsland {

                DynamicIslandExpandedRegion(.leading) {
                    HStack(spacing: 6) {
                        Image(systemName: stageIcon(stage: context.state.stage))
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(stageAccent(stage: context.state.stage))
                        Text(context.state.stageTitle)
                            .font(.system(size: 13, weight: .semibold))
                            .foregroundColor(.white)
                    }
                    .padding(.leading, 4)
                }

                DynamicIslandExpandedRegion(.trailing) {
                    if context.state.stage == "inQueue" {
                        VStack(alignment: .trailing, spacing: 2) {
                            Text("Token")
                                .font(.system(size: 10))
                                .foregroundColor(.white.opacity(0.7))
                            Text("#\(context.state.queueNumber)")
                                .font(.system(size: 17, weight: .bold))
                                .foregroundColor(.white)
                        }
                        .padding(.trailing, 4)
                    } else {
                        Text(context.state.queueTime)
                            .font(.system(size: 13, weight: .medium))
                            .foregroundColor(.white.opacity(0.85))
                            .padding(.trailing, 4)
                    }
                }

                DynamicIslandExpandedRegion(.bottom) {
                    HStack {
                        Text(context.state.stageDetail)
                            .font(.system(size: 12))
                            .foregroundColor(.white.opacity(0.8))
                            .lineLimit(1)
                        Spacer()
                        if context.state.stage == "inQueue" {
                            Text(context.state.queueTime)
                                .font(.system(size: 12, weight: .semibold))
                                .foregroundColor(stageAccent(stage: context.state.stage))
                        }
                    }
                    .padding(.horizontal, 4)
                    .padding(.bottom, 4)
                }

            } compactLeading: {
                Image(systemName: stageIcon(stage: context.state.stage))
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(stageAccent(stage: context.state.stage))

            } compactTrailing: {
                if context.state.stage == "inQueue" {
                    Text("#\(context.state.queueNumber)")
                        .font(.system(size: 13, weight: .bold))
                        .foregroundColor(.white)
                } else {
                    Text(context.state.queueTime)
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(.white)
                }

            } minimal: {
                Image(systemName: stageIcon(stage: context.state.stage))
                    .font(.system(size: 12))
                    .foregroundColor(stageAccent(stage: context.state.stage))
            }
        }
    }

    @ViewBuilder
    private func lockScreenView(context: ActivityViewContext<QueueActivityAttributes>) -> some View {
        HStack(spacing: 16) {
            ZStack {
                Circle()
                    .fill(Color.white.opacity(0.15))
                    .frame(width: 52, height: 52)
                Image(systemName: stageIcon(stage: context.state.stage))
                    .font(.system(size: 22, weight: .semibold))
                    .foregroundColor(.white)
            }

            VStack(alignment: .leading, spacing: 4) {
                Text(context.state.stageTitle)
                    .font(.system(size: 15, weight: .bold))
                    .foregroundColor(.white)

                Text(context.state.stageDetail)
                    .font(.system(size: 12))
                    .foregroundColor(.white.opacity(0.8))
                    .lineLimit(1)
            }

            Spacer()

            if context.state.stage == "inQueue" {
                VStack(alignment: .trailing, spacing: 2) {
                    Text("Wait")
                        .font(.system(size: 11))
                        .foregroundColor(.white.opacity(0.7))
                    Text(context.state.queueTime)
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(.white)
                    Text("Token #\(context.state.queueNumber)")
                        .font(.system(size: 11))
                        .foregroundColor(.white.opacity(0.8))
                }
            } else if context.state.stage == "pharmacyPickup" {
                Image(systemName: "arrow.right.circle.fill")
                    .font(.system(size: 28))
                    .foregroundColor(.white.opacity(0.85))
            } else {
                Image(systemName: "chevron.right.circle.fill")
                    .font(.system(size: 28))
                    .foregroundColor(.white.opacity(0.6))
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 14)
    }

    private func lockScreenBackground(stage: String) -> Color {
        switch stage {
        case "inQueue":        return Color(red: 0.12, green: 0.37, blue: 0.66)
        case "withDoctor":     return Color(red: 0.10, green: 0.48, blue: 0.29)
        case "labQueue":       return Color(red: 0.10, green: 0.42, blue: 0.54)
        case "labOngoing":     return Color(red: 0.42, green: 0.25, blue: 0.66)
        case "pharmacyPickup": return Color(red: 0.75, green: 0.35, blue: 0.06)
        default:               return Color(red: 0.29, green: 0.29, blue: 0.29)
        }
    }

    private func stageIcon(stage: String) -> String {
        switch stage {
        case "inQueue":        return "clock.fill"
        case "withDoctor":     return "stethoscope"
        case "labQueue":       return "flask.fill"
        case "labOngoing":     return "waveform.path.ecg"
        case "pharmacyPickup": return "pills.fill"
        default:               return "checkmark.seal.fill"
        }
    }

    private func stageAccent(stage: String) -> Color {
        switch stage {
        case "inQueue":        return Color(red: 0.55, green: 0.80, blue: 1.0)
        case "withDoctor":     return Color(red: 0.55, green: 1.0, blue: 0.75)
        case "labQueue":       return Color(red: 0.55, green: 0.90, blue: 1.0)
        case "labOngoing":     return Color(red: 0.80, green: 0.65, blue: 1.0)
        case "pharmacyPickup": return Color(red: 1.0, green: 0.75, blue: 0.45)
        default:               return Color(red: 0.75, green: 0.75, blue: 0.75)
        }
    }
}

#Preview("Lock Screen - In Queue", as: .content, using: QueueActivityAttributes()) {
    QueueLiveActivityWidget()
} contentStates: {
    QueueActivityAttributes.ContentState(
        queueNumber: 6,
        queueTime: "~10 mins",
        stage: "inQueue",
        stageTitle: "In Queue",
        stageDetail: "OPD Room 2 • Token #06"
    )
    QueueActivityAttributes.ContentState(
        queueNumber: 6,
        queueTime: "10:15 AM",
        stage: "withDoctor",
        stageTitle: "Appointment in Progress",
        stageDetail: "Dr. Jenny Wilson • OPD Room 2"
    )
    QueueActivityAttributes.ContentState(
        queueNumber: 5,
        queueTime: "~8 mins",
        stage: "labQueue",
        stageTitle: "Lab Test Queued",
        stageDetail: "OPD Lab 1, Ground Floor"
    )
    QueueActivityAttributes.ContentState(
        queueNumber: 0,
        queueTime: "Now",
        stage: "pharmacyPickup",
        stageTitle: "Collect Your Medicine",
        stageDetail: "Main Pharmacy, Ground Floor"
    )
}
