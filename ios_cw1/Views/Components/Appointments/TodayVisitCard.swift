//
//  TodayVisitCard.swift
//  ios_cw1
//
//  Created by COBSCCOMP242P-74 on 2026-03-11.
//

import SwiftUI

struct TodayVisitCard: View {
    enum CardType {
        case upcoming(doctor: String, specialty: String, location: String, token: String, timeSlot: String, isTest: Bool)
        case ongoing(doctor: String, specialty: String, location: String, token: String, position: Int, isTest: Bool)
        case flowProgress(flowViewModel: AppointmentFlowViewModel)
    }

    let type: CardType
    var onCancel: (() -> Void)? = nil
    var onReschedule: (() -> Void)? = nil

    var body: some View {
        switch type {
        case .upcoming(let doctor, let specialty, let location, let token, let timeSlot, let isTest):
            UpcomingCard(
                doctor: doctor, specialty: specialty, location: location,
                token: token, timeSlot: timeSlot, isTest: isTest,
                onCancel: onCancel, onReschedule: onReschedule
            )
        case .ongoing(let doctor, let specialty, let location, let token, let position, let isTest):
            OngoingCard(
                doctor: doctor, specialty: specialty, location: location,
                token: token, position: position, isTest: isTest
            )
        case .flowProgress(let vm):
            FlowProgressCard(flowViewModel: vm)
        }
    }
}

private struct UpcomingCard: View {
    let doctor: String
    let specialty: String
    let location: String
    let token: String
    let timeSlot: String
    let isTest: Bool
    var onCancel: (() -> Void)? = nil
    var onReschedule: (() -> Void)? = nil

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {

            HStack(alignment: .top, spacing: 14) {
                ZStack {
                    Circle()
                        .fill(Color(red: 0.87, green: 0.93, blue: 1.0))
                        .frame(width: 56, height: 56)
                    Image(systemName: isTest ? "flask.fill" : "stethoscope")
                        .font(.system(size: 22))
                        .foregroundColor(Color(red: 0.15, green: 0.35, blue: 0.75))
                }

                VStack(alignment: .leading, spacing: 4) {
                    Text(doctor)
                        .font(.system(size: 17, weight: .bold))
                        .foregroundColor(.primary)

                    Text(specialty)
                        .font(.system(size: 13))
                        .foregroundColor(Color(.systemGray))

                    HStack(spacing: 4) {
                        Image(systemName: "mappin.circle.fill")
                            .font(.system(size: 12))
                            .foregroundColor(Color(.systemGray2))
                        Text(location)
                            .font(.system(size: 13))
                            .foregroundColor(Color(.systemGray))
                    }

                    HStack(spacing: 4) {
                        Image(systemName: "calendar")
                            .font(.system(size: 12))
                            .foregroundColor(Color(.systemGray2))
                        Text("Today, \(timeSlot)")
                            .font(.system(size: 13))
                            .foregroundColor(Color(.systemGray))
                    }
                }

                Spacer()
            }
            .padding(.bottom, 14)

            Divider().padding(.bottom, 12)

            HStack(spacing: 12) {
                Button(action: { onCancel?() }) {
                    Text("Cancel")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.red)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 10)
                        .background(Color.red.opacity(0.08))
                        .cornerRadius(10)
                        .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.red.opacity(0.3), lineWidth: 1))
                }

                Button(action: { onReschedule?() }) {
                    Text("Reschedule")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(Color(red: 0.15, green: 0.35, blue: 0.75))
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 10)
                        .background(Color.white)
                        .cornerRadius(10)
                        .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color(red: 0.15, green: 0.35, blue: 0.75), lineWidth: 1.5))
                }
            }
        }
        .padding(16)
        .background(Color.white)
        .cornerRadius(18)
        .shadow(color: .black.opacity(0.07), radius: 10, x: 0, y: 4)
    }
}

private struct OngoingCard: View {
    let doctor: String
    let specialty: String
    let location: String
    let token: String
    let position: Int
    let isTest: Bool

    private var ordinal: String {
        switch position {
        case 1: return "1st"
        case 2: return "2nd"
        case 3: return "3rd"
        default: return "\(position)th"
        }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack(alignment: .top, spacing: 14) {
                ZStack {
                    Circle()
                        .fill(Color(red: 0.87, green: 0.93, blue: 1.0))
                        .frame(width: 56, height: 56)
                    Image(systemName: isTest ? "flask.fill" : "stethoscope")
                        .font(.system(size: 22))
                        .foregroundColor(Color(red: 0.15, green: 0.35, blue: 0.75))
                }

                VStack(alignment: .leading, spacing: 4) {
                    Text(doctor)
                        .font(.system(size: 17, weight: .bold))
                        .foregroundColor(.primary)
                    Text(specialty)
                        .font(.system(size: 12))
                        .foregroundColor(Color(.systemGray))
                    Text(location)
                        .font(.system(size: 12))
                        .foregroundColor(Color(.systemGray))
                }

                Spacer()

                HStack(spacing: 4) {
                    Circle().fill(Color.green).frame(width: 7, height: 7)
                    Text("In Queue")
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundColor(.green)
                }
                .padding(.horizontal, 10)
                .padding(.vertical, 5)
                .background(Color.green.opacity(0.1))
                .cornerRadius(20)
            }

            HStack(spacing: 0) {
                VStack(alignment: .leading, spacing: 2) {
                    Text("QUEUE TOKEN")
                        .font(.system(size: 11, weight: .semibold))
                        .foregroundColor(Color(.systemGray))
                        .kerning(0.5)
                    Text("#\(token)")
                        .font(.system(size: 26, weight: .bold))
                        .foregroundColor(Color(red: 0.15, green: 0.35, blue: 0.75))
                }
                .frame(maxWidth: .infinity, alignment: .leading)

                Divider().frame(height: 44).padding(.horizontal, 16)

                VStack(alignment: .leading, spacing: 2) {
                    Text("YOUR POSITION")
                        .font(.system(size: 11, weight: .semibold))
                        .foregroundColor(Color(.systemGray))
                        .kerning(0.5)
                    HStack(alignment: .firstTextBaseline, spacing: 4) {
                        Text(ordinal)
                            .font(.system(size: 22, weight: .bold))
                            .foregroundColor(.primary)
                        Text("in line")
                            .font(.system(size: 15))
                            .foregroundColor(Color(.systemGray))
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding(.vertical, 14)

            Divider().padding(.bottom, 12)

            HStack(spacing: 12) {
                Button(action: {}) {
                    Text("Cancel")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.red)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 10)
                        .background(Color.red.opacity(0.08))
                        .cornerRadius(10)
                        .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.red.opacity(0.3), lineWidth: 1))
                }

                Button(action: {}) {
                    Text("Track Progress")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(Color(red: 0.15, green: 0.35, blue: 0.75))
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 10)
                        .background(Color.white)
                        .cornerRadius(10)
                        .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color(red: 0.15, green: 0.35, blue: 0.75), lineWidth: 1.5))
                }
            }
        }
        .padding(16)
        .background(Color.white)
        .cornerRadius(18)
        .shadow(color: .black.opacity(0.07), radius: 10, x: 0, y: 4)
    }
}

struct FlowProgressCard: View {
    @ObservedObject var flowViewModel: AppointmentFlowViewModel
    @State private var showSheet = false

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack(alignment: .top, spacing: 14) {
                ZStack {
                    Circle()
                        .fill(
                            LinearGradient(
                                colors: [
                                    Color(hex: flowViewModel.stageColor[0]),
                                    Color(hex: flowViewModel.stageColor[1])
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 56, height: 56)
                    Image(systemName: flowViewModel.stageIcon)
                        .font(.system(size: 22))
                        .foregroundColor(.white)
                }

                VStack(alignment: .leading, spacing: 4) {
                    Text(flowViewModel.stageTitle)
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(.primary)
                    Text(flowViewModel.stageSubtitle)
                        .font(.system(size: 13))
                        .foregroundColor(Color(.systemGray))
                        .lineLimit(2)
                }

                Spacer()

                stagePill
            }

            stepStrip

            Divider()

            Button(action: { showSheet = true }) {
                HStack {
                    Text("View Full Journey")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(Color(hex: flowViewModel.stageColor[0]))
                    Spacer()
                    Image(systemName: "chevron.right")
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundColor(Color(hex: flowViewModel.stageColor[0]))
                }
            }
            .sheet(isPresented: $showSheet) {
                AppointmentProgressView()
                    .environmentObject(flowViewModel)
                    .environmentObject(AppointmentStore())
            }
        }
        .padding(16)
        .background(Color.white)
        .cornerRadius(18)
        .shadow(color: .black.opacity(0.07), radius: 10, x: 0, y: 4)
    }

    private var stagePill: some View {
        HStack(spacing: 5) {
            if flowViewModel.currentStage != .done {
                Circle()
                    .fill(Color.green)
                    .frame(width: 7, height: 7)
            }
            Text(flowViewModel.currentStage == .done ? "Done" : "Active")
                .font(.system(size: 11, weight: .semibold))
                .foregroundColor(flowViewModel.currentStage == .done ? .gray : .green)
        }
        .padding(.horizontal, 9)
        .padding(.vertical, 4)
        .background(flowViewModel.currentStage == .done ? Color(.systemGray5) : Color.green.opacity(0.1))
        .cornerRadius(20)
    }

    private var stepStrip: some View {
        HStack(spacing: 0) {
            ForEach(Array(flowViewModel.journeySteps.enumerated()), id: \.element.id) { index, step in
                let status = flowViewModel.stepStatus(for: step)

                HStack(spacing: 0) {
                    ZStack {
                        Circle()
                            .fill(stepColor(status))
                            .frame(width: 28, height: 28)
                        Image(systemName: status == .completed ? "checkmark" : step.icon)
                            .font(.system(size: 11, weight: .bold))
                            .foregroundColor(status == .pending ? Color(.systemGray3) : .white)
                    }

                    if index < flowViewModel.journeySteps.count - 1 {
                        Rectangle()
                            .fill(status == .completed ? Color(hex: flowViewModel.stageColor[0]).opacity(0.6) : Color(.systemGray4))
                            .frame(height: 2.5)
                            .frame(maxWidth: .infinity)
                    }
                }
                .frame(maxWidth: index < flowViewModel.journeySteps.count - 1 ? .infinity : nil)
            }
        }
    }

    private func stepColor(_ status: JourneyStepStatus) -> Color {
        switch status {
        case .completed: return Color(hex: flowViewModel.stageColor[0])
        case .active:    return Color(hex: flowViewModel.stageColor[0])
        case .pending:   return Color(.systemGray5)
        }
    }
}

#Preview {
    let store = AppointmentStore()
    let flow = AppointmentFlowViewModel(appointmentStore: store)
    return VStack(spacing: 16) {
        TodayVisitCard(type: .ongoing(
            doctor: "Dr. Sarah Wilson",
            specialty: "Cardiologist",
            location: "Heart Care Center",
            token: "42",
            position: 5,
            isTest: false
        ))
        TodayVisitCard(type: .flowProgress(flowViewModel: flow))
    }
    .padding()
    .background(Color(.systemGroupedBackground))
}
