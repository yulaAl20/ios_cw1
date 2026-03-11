//
//  AppointmentFlowViewModel.swift
//  ios_cw1
//
//  Created by cobsccomp242p-066 on 2026-03-11.
//

import Foundation
import Combine

class AppointmentFlowViewModel: ObservableObject {

    @Published var currentStage: AppointmentFlowStage = .inQueue
    @Published var queuePosition: Int = 3
    @Published var totalInQueue: Int = 17
    @Published var timerSecondsRemaining: Int = 720
    @Published var isTimerActive: Bool = false
    @Published var labQueuePosition: Int = 5
    @Published var labTotalInQueue: Int = 12
    @Published var showProgressSheet: Bool = false

    var activeAppointmentId: UUID?
    var doctorName: String = "Dr. Jenny Wilson"
    var doctorLocation: String = "OPD Room 2"
    var token: String = "06"
    var labName: String = "Full Blood Count"
    var labLocation: String = "OPD Lab 1, Ground Floor"
    var pharmacyLocation: String = "Main Pharmacy, Ground Floor"
    var medicines: [String] = []
    var hasLabReferral: Bool = false
    var hasPharmacyReferral: Bool = false

    private weak var appointmentStore: AppointmentStore?
    private var countdownTimer: Timer?
    private var autoAdvanceTimer: Timer?
    private var labAutoTimer: Timer?
    private var labAutoSecondsLeft: Int = 10
    private var cancellables = Set<AnyCancellable>()

    init(appointmentStore: AppointmentStore) {
        self.appointmentStore = appointmentStore
        syncFromStore(appointmentStore)

        appointmentStore.$appointments
            .sink { [weak self] _ in
                guard let self, let store = self.appointmentStore else { return }
                self.syncFromStore(store)
            }
            .store(in: &cancellables)
    }

    private func syncFromStore(_ store: AppointmentStore) {
        guard let active = store.activeAppointment else { return }
        activeAppointmentId = active.id
        doctorName = active.doctorName
        doctorLocation = active.location
        token = active.token ?? "06"
        queuePosition = active.queuePosition ?? 3
        totalInQueue = active.totalInQueue ?? 17

        if currentStage == active.flowStage { return }
        currentStage = active.flowStage

        if let lab = active.labReferral {
            hasLabReferral = true
            labQueuePosition = lab.queuePosition
            labTotalInQueue = lab.totalInQueue
            labName = lab.labName
            labLocation = lab.labLocation
        }
        if let pharmacy = active.pharmacyReferral {
            hasPharmacyReferral = true
            pharmacyLocation = pharmacy.pharmacyLocation
            medicines = pharmacy.medicines
        }

        if timerSecondsRemaining == 720 {
            timerSecondsRemaining = queuePosition * 4 * 60
        }
    }

    var estimatedWaitText: String {
        if timerSecondsRemaining <= 0 { return "Your turn now!" }
        let mins = timerSecondsRemaining / 60
        let secs = timerSecondsRemaining % 60
        if mins > 0 { return "~\(mins) min\(mins == 1 ? "" : "s")" }
        return "\(secs)s"
    }

    var stageTitle: String {
        switch currentStage {
        case .inQueue:        return "You're in Queue"
        case .withDoctor:     return "Appointment in Progress"
        case .labQueue:       return "Lab Test Queued"
        case .labOngoing:     return "Lab Test in Progress"
        case .pharmacyPickup: return "Collect Your Medicine"
        case .done:           return "All Done!"
        }
    }

    var stageSubtitle: String {
        switch currentStage {
        case .inQueue:
            return "\(doctorLocation) • Token #\(token) • \(estimatedWaitText)"
        case .withDoctor:
            return "\(doctorName) • \(doctorLocation)"
        case .labQueue:
            return "\(labLocation) • Queue \(labQueuePosition) of \(labTotalInQueue)"
        case .labOngoing:
            return "\(labLocation)"
        case .pharmacyPickup:
            return pharmacyLocation
        case .done:
            return "Your visit is complete for today"
        }
    }

    var stageColor: [String] {
        switch currentStage {
        case .inQueue:        return ["#1E5FA8", "#2E78C7"]
        case .withDoctor:     return ["#1A7A4A", "#28A868"]
        case .labQueue:       return ["#1A6B8A", "#2693B8"]
        case .labOngoing:     return ["#6B3FA8", "#8A5DC8"]
        case .pharmacyPickup: return ["#C05A10", "#E07020"]
        case .done:           return ["#4A4A4A", "#6A6A6A"]
        }
    }

    var stageIcon: String {
        switch currentStage {
        case .inQueue:        return "clock.fill"
        case .withDoctor:     return "stethoscope"
        case .labQueue:       return "flask.fill"
        case .labOngoing:     return "waveform.path.ecg"
        case .pharmacyPickup: return "pills.fill"
        case .done:           return "checkmark.seal.fill"
        }
    }

    func startQueueTimer() {
        guard !isTimerActive, currentStage == .inQueue else { return }
        isTimerActive = true
        countdownTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            guard let self else { return }
            DispatchQueue.main.async {
                if self.timerSecondsRemaining > 0 {
                    self.timerSecondsRemaining -= 1
                } else {
                    self.stopCountdown()
                    self.transitionToWithDoctor()
                }
            }
        }
    }

    func stopCountdown() {
        countdownTimer?.invalidate()
        countdownTimer = nil
        isTimerActive = false
    }

    func transitionToWithDoctor() {
        stopCountdown()
        updateStage(.withDoctor)
        autoAdvanceTimer = Timer.scheduledTimer(withTimeInterval: 12.0, repeats: false) { [weak self] _ in
            DispatchQueue.main.async {
                self?.transitionPostDoctor()
            }
        }
    }

    func transitionPostDoctor() {
        autoAdvanceTimer?.invalidate()
        autoAdvanceTimer = nil
        if hasLabReferral {
            updateStage(.labQueue)
        } else if hasPharmacyReferral {
            updateStage(.pharmacyPickup)
        } else {
            updateStage(.done)
        }
    }

    func startLabQueue() {
        guard currentStage == .labQueue else { return }
        labAutoSecondsLeft = labQueuePosition * 60
        labAutoTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            guard let self else { return }
            DispatchQueue.main.async {
                self.labAutoSecondsLeft -= 1
                if self.labAutoSecondsLeft <= 0 {
                    self.labAutoTimer?.invalidate()
                    self.labAutoTimer = nil
                    self.updateStage(.labOngoing)
                    DispatchQueue.main.asyncAfter(deadline: .now() + 10) {
                        self.transitionPostLab()
                    }
                }
            }
        }
    }

    func transitionPostLab() {
        if hasPharmacyReferral {
            updateStage(.pharmacyPickup)
        } else {
            updateStage(.done)
        }
    }

    func markPharmacyCollected() {
        updateStage(.done)
    }

    func simulateAdvance() {
        switch currentStage {
        case .inQueue:
            stopCountdown()
            transitionToWithDoctor()
        case .withDoctor:
            autoAdvanceTimer?.invalidate()
            autoAdvanceTimer = nil
            transitionPostDoctor()
        case .labQueue:
            labAutoTimer?.invalidate()
            labAutoTimer = nil
            updateStage(.labOngoing)
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                self.transitionPostLab()
            }
        case .labOngoing:
            transitionPostLab()
        case .pharmacyPickup:
            markPharmacyCollected()
        case .done:
            break
        }
    }

    private func updateStage(_ stage: AppointmentFlowStage) {
        currentStage = stage
        if let id = activeAppointmentId {
            appointmentStore?.updateFlowStage(for: id, stage: stage)
        }
    }

    var journeySteps: [JourneyStep] {
        var steps: [JourneyStep] = [
            JourneyStep(
                id: "queue",
                title: "Doctor Queue",
                detail: "\(doctorLocation) • Token #\(token)",
                icon: "clock.fill",
                stage: .inQueue
            ),
            JourneyStep(
                id: "doctor",
                title: "Appointment with \(doctorName)",
                detail: doctorLocation,
                icon: "stethoscope",
                stage: .withDoctor
            )
        ]
        if hasLabReferral {
            steps.append(JourneyStep(
                id: "lab",
                title: "Lab Test: \(labName)",
                detail: labLocation,
                icon: "flask.fill",
                stage: .labQueue
            ))
        }
        if hasPharmacyReferral {
            steps.append(JourneyStep(
                id: "pharmacy",
                title: "Collect Medicine",
                detail: pharmacyLocation,
                icon: "pills.fill",
                stage: .pharmacyPickup
            ))
        }
        return steps
    }

    func stepStatus(for step: JourneyStep) -> JourneyStepStatus {
        let stageOrder: [AppointmentFlowStage] = [
            .inQueue, .withDoctor, .labQueue, .labOngoing, .pharmacyPickup, .done
        ]
        guard let currentIndex = stageOrder.firstIndex(of: currentStage),
              let stepIndex = stageOrder.firstIndex(of: step.stage) else {
            return .pending
        }
        if stepIndex < currentIndex { return .completed }
        if stepIndex == currentIndex { return .active }
        if step.stage == .labQueue && currentStage == .labOngoing { return .active }
        return .pending
    }

    deinit {
        stopCountdown()
        autoAdvanceTimer?.invalidate()
        labAutoTimer?.invalidate()
    }
}

struct JourneyStep: Identifiable {
    let id: String
    let title: String
    let detail: String
    let icon: String
    let stage: AppointmentFlowStage
}

enum JourneyStepStatus {
    case completed
    case active
    case pending
}
