//
//  AppointmentProgressView.swift
//  ios_cw1
//
//  Created by cobsccomp242p-066 on 2026-03-11.
//
//

import SwiftUI

struct AppointmentProgressView: View {
    @EnvironmentObject var flowViewModel: AppointmentFlowViewModel
    @EnvironmentObject var appointmentStore: AppointmentStore
    @Environment(\.dismiss) var dismiss

    var body: some View {
        NavigationStack {
            ScrollView(showsIndicators: false) {
                VStack(spacing: 0) {
                    headerCard
                    Spacer().frame(height: 24)
                    journeyTimeline
                    if flowViewModel.currentStage == .pharmacyPickup {
                        Spacer().frame(height: 20)
                        medicineList
                    }
                    Spacer().frame(height: 20)
                    advanceButton
                    Spacer().frame(height: 40)
                }
                .padding(.horizontal, 20)
                .padding(.top, 16)
            }
            .background(Color(red: 0.94, green: 0.97, blue: 1.0).ignoresSafeArea())
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: { dismiss() }) {
                        Image(systemName: "xmark.circle.fill")
                            .font(.system(size: 22))
                            .foregroundColor(Color(.systemGray3))
                    }
                }
                ToolbarItem(placement: .principal) {
                    Text("Appointment Journey")
                        .font(.system(size: 16, weight: .semibold))
                }
            }
        }
    }

    private var headerCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 14) {
                ZStack {
                    Circle()
                        .fill(stageGradient)
                        .frame(width: 56, height: 56)
                    Image(systemName: flowViewModel.stageIcon)
                        .font(.system(size: 22, weight: .semibold))
                        .foregroundColor(.white)
                }

                VStack(alignment: .leading, spacing: 4) {
                    Text(flowViewModel.stageTitle)
                        .font(.system(size: 17, weight: .bold))
                        .foregroundColor(.primary)
                    Text(flowViewModel.stageSubtitle)
                        .font(.system(size: 13))
                        .foregroundColor(Color(.systemGray))
                        .lineLimit(2)
                }

                Spacer()

                statusPill
            }

            if flowViewModel.currentStage == .inQueue {
                timerBar
            }
        }
        .padding(18)
        .background(Color.white)
        .cornerRadius(20)
        .shadow(color: .black.opacity(0.07), radius: 12, x: 0, y: 4)
    }

    private var stageGradient: LinearGradient {
        LinearGradient(
            colors: [
                Color(hex: flowViewModel.stageColor[0]),
                Color(hex: flowViewModel.stageColor[1])
            ],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }

    private var statusPill: some View {
        HStack(spacing: 5) {
            if flowViewModel.currentStage != .done {
                Circle()
                    .fill(Color.green)
                    .frame(width: 7, height: 7)
                    .opacity(0.9)
            }
            Text(flowViewModel.currentStage == .done ? "Completed" : "Active")
                .font(.system(size: 12, weight: .semibold))
                .foregroundColor(flowViewModel.currentStage == .done ? .gray : .green)
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 5)
        .background(
            flowViewModel.currentStage == .done
            ? Color(.systemGray5)
            : Color.green.opacity(0.12)
        )
        .cornerRadius(20)
    }

    private var timerBar: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack {
                Image(systemName: "timer")
                    .font(.system(size: 13))
                    .foregroundColor(Color(hex: "#1E5FA8"))
                Text("Estimated wait: \(flowViewModel.estimatedWaitText)")
                    .font(.system(size: 13, weight: .medium))
                    .foregroundColor(Color(hex: "#1E5FA8"))
                Spacer()
                Text("Queue \(flowViewModel.queuePosition) of \(flowViewModel.totalInQueue)")
                    .font(.system(size: 12))
                    .foregroundColor(.gray)
            }

            let progress = max(0.0, min(1.0, Double(flowViewModel.timerSecondsRemaining) / Double(max(1, flowViewModel.queuePosition * 4 * 60))))
            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 4)
                        .fill(Color(hex: "#1E5FA8").opacity(0.15))
                        .frame(height: 6)
                    RoundedRectangle(cornerRadius: 4)
                        .fill(
                            LinearGradient(
                                colors: [Color(hex: "#1E5FA8"), Color(hex: "#2E78C7")],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .frame(width: geo.size.width * progress, height: 6)
                        .animation(.linear(duration: 1.0), value: progress)
                }
            }
            .frame(height: 6)
        }
        .padding(12)
        .background(Color(hex: "#1E5FA8").opacity(0.06))
        .cornerRadius(12)
    }

    private var journeyTimeline: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("Your Journey Today")
                .font(.system(size: 15, weight: .semibold))
                .foregroundColor(.primary)
                .padding(.bottom, 16)

            ForEach(Array(flowViewModel.journeySteps.enumerated()), id: \.element.id) { index, step in
                let status = flowViewModel.stepStatus(for: step)
                let isLast = index == flowViewModel.journeySteps.count - 1

                HStack(alignment: .top, spacing: 0) {
                    VStack(spacing: 0) {
                        stepIndicator(status: status, icon: step.icon)
                        if !isLast {
                            connector(status: status)
                        }
                    }
                    .frame(width: 44)

                    VStack(alignment: .leading, spacing: 0) {
                        stepContent(step: step, status: status)
                        if !isLast {
                            Spacer().frame(height: 24)
                        }
                    }
                    .padding(.leading, 12)
                }
            }
        }
        .padding(18)
        .background(Color.white)
        .cornerRadius(20)
        .shadow(color: .black.opacity(0.05), radius: 10, x: 0, y: 4)
    }

    private func stepIndicator(status: JourneyStepStatus, icon: String) -> some View {
        ZStack {
            Circle()
                .fill(statusBackground(status))
                .frame(width: 40, height: 40)
                .overlay(
                    Circle()
                        .stroke(statusBorder(status), lineWidth: status == .active ? 2.5 : 1.5)
                )

            if status == .completed {
                Image(systemName: "checkmark")
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(.white)
            } else {
                Image(systemName: icon)
                    .font(.system(size: 15, weight: .medium))
                    .foregroundColor(status == .active ? .white : Color(.systemGray3))
            }
        }
    }

    private func connector(status: JourneyStepStatus) -> some View {
        Rectangle()
            .fill(status == .completed ? Color(hex: "#2E78C7").opacity(0.7) : Color(.systemGray4))
            .frame(width: 2.5, height: 28)
            .padding(.vertical, 2)
    }

    private func statusBackground(_ status: JourneyStepStatus) -> Color {
        switch status {
        case .completed: return Color(hex: "#2E78C7")
        case .active:    return Color(hex: "#1E5FA8")
        case .pending:   return Color(.systemGray6)
        }
    }

    private func statusBorder(_ status: JourneyStepStatus) -> Color {
        switch status {
        case .completed: return Color(hex: "#2E78C7")
        case .active:    return Color(hex: "#1E5FA8")
        case .pending:   return Color(.systemGray4)
        }
    }

    private func stepContent(step: JourneyStep, status: JourneyStepStatus) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack(spacing: 8) {
                Text(step.title)
                    .font(.system(size: 15, weight: status == .active ? .bold : .medium))
                    .foregroundColor(status == .pending ? Color(.systemGray2) : .primary)

                if status == .active {
                    Text("NOW")
                        .font(.system(size: 10, weight: .bold))
                        .foregroundColor(.white)
                        .padding(.horizontal, 7)
                        .padding(.vertical, 3)
                        .background(Color(hex: "#1E5FA8"))
                        .cornerRadius(8)
                }
            }

            Text(step.detail)
                .font(.system(size: 12))
                .foregroundColor(Color(.systemGray))

            if status == .active && step.stage == .inQueue {
                Text(flowViewModel.estimatedWaitText + " • Queue \(flowViewModel.queuePosition)/\(flowViewModel.totalInQueue)")
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(Color(hex: "#1E5FA8"))
            } else if status == .active && step.stage == .labQueue {
                Text("Queue \(flowViewModel.labQueuePosition) of \(flowViewModel.labTotalInQueue)")
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(Color(hex: "#1A6B8A"))
            }
        }
        .padding(.top, 8)
    }

    private var medicineList: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack(spacing: 8) {
                Image(systemName: "cross.case.fill")
                    .font(.system(size: 15))
                    .foregroundColor(Color(hex: "#C05A10"))
                Text("Prescribed Medicines")
                    .font(.system(size: 15, weight: .semibold))
            }

            VStack(spacing: 10) {
                ForEach(Array(flowViewModel.medicines.enumerated()), id: \.offset) { _, medicine in
                    HStack(spacing: 12) {
                        Image(systemName: "pills.fill")
                            .font(.system(size: 14))
                            .foregroundColor(Color(hex: "#C05A10"))
                            .frame(width: 28)
                        Text(medicine)
                            .font(.system(size: 14))
                            .foregroundColor(.primary)
                        Spacer()
                    }
                    .padding(12)
                    .background(Color(hex: "#C05A10").opacity(0.06))
                    .cornerRadius(12)
                }
            }

            Button(action: { flowViewModel.markPharmacyCollected() }) {
                HStack(spacing: 8) {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.system(size: 17))
                    Text("Mark as Collected")
                        .font(.system(size: 15, weight: .semibold))
                }
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 14)
                .background(
                    LinearGradient(
                        colors: [Color(hex: "#C05A10"), Color(hex: "#E07020")],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .cornerRadius(14)
            }
        }
        .padding(18)
        .background(Color.white)
        .cornerRadius(20)
        .shadow(color: .black.opacity(0.05), radius: 10, x: 0, y: 4)
    }

    private var advanceButton: some View {
        Group {
            if flowViewModel.currentStage != .done {
                VStack(spacing: 8) {
                    Button(action: { flowViewModel.simulateAdvance() }) {
                        HStack(spacing: 8) {
                            Image(systemName: "forward.fill")
                                .font(.system(size: 14))
                            Text("Simulate Next Stage")
                                .font(.system(size: 14, weight: .semibold))
                        }
                        .foregroundColor(Color(hex: "#1E5FA8"))
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                        .background(Color(hex: "#1E5FA8").opacity(0.1))
                        .cornerRadius(12)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color(hex: "#1E5FA8").opacity(0.3), lineWidth: 1)
                        )
                    }

                    Text("Demo only — in production, stages advance automatically or via hospital system")
                        .font(.system(size: 11))
                        .foregroundColor(Color(.systemGray3))
                        .multilineTextAlignment(.center)
                }
            }
        }
    }
}

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let r, g, b: UInt64
        switch hex.count {
        case 6:
            (r, g, b) = ((int >> 16) & 0xFF, (int >> 8) & 0xFF, int & 0xFF)
        default:
            (r, g, b) = (1, 1, 0)
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: 1
        )
    }
}

#Preview {
    let store = AppointmentStore()
    let flow = AppointmentFlowViewModel(appointmentStore: store)
    return AppointmentProgressView()
        .environmentObject(store)
        .environmentObject(flow)
        .environmentObject(AppRouter())
}
