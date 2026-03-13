//
//  AppointmentsView1.swift
//  ios_cw1
//
//  Created by COBSCCOMP242P-74 on 2026-03-11.
//

import SwiftUI

struct AppointmentsView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var appointmentStore: AppointmentStore
    @EnvironmentObject var router: AppRouter
    @EnvironmentObject var flowViewModel: AppointmentFlowViewModel
    var selectedTabBinding: Binding<Int>?

    @State private var selectedTab = "Upcoming"
    @State private var showBookingFlow = false
    @State private var showCancelAlert = false
    @State private var appointmentToCancel: Appointment? = nil
    @State private var appointmentToReschedule: Appointment? = nil
    @State private var showReschedule = false
    @State private var showLabReschedule = false
    // Show the booking QR sheet (same QR shown after payment)
    @State private var showBookingQR = false
    @State private var selectedAppointmentForQR: Appointment? = nil

    private let qrGenerator = PaymentViewModel(totalPrice: 0)

    private func presentBookingQR(for appointment: Appointment) {
        selectedAppointmentForQR = appointment
        showBookingQR = true
    }

    private var currentAppointments: [Appointment] {
        switch selectedTab {
        case "Upcoming":  return appointmentStore.appointments.filter { $0.status == .upcoming }
        case "Ongoing":   return appointmentStore.appointments.filter { $0.status == .ongoing }
        case "Completed": return appointmentStore.appointments.filter { $0.status == .completed }
        default:          return []
        }
    }

    private var todayDoctorVisits: [Appointment] {
        currentAppointments.filter { Calendar.current.isDateInToday($0.date) && !$0.isTest }
    }
    private var futureDoctorVisits: [Appointment] {
        currentAppointments.filter { !Calendar.current.isDateInToday($0.date) && $0.date > Date() && !$0.isTest }
    }
    private var pastDoctorVisits: [Appointment] {
        currentAppointments.filter { !$0.isTest }
    }
    private var todayLabVisits: [Appointment] {
        currentAppointments.filter { Calendar.current.isDateInToday($0.date) && $0.isTest }
    }
    private var futureLabVisits: [Appointment] {
        currentAppointments.filter { !Calendar.current.isDateInToday($0.date) && $0.date > Date() && $0.isTest }
    }
    private var pastLabVisits: [Appointment] {
        currentAppointments.filter { $0.isTest }
    }

    private var hasDoctorAppointments: Bool {
        !todayDoctorVisits.isEmpty || !futureDoctorVisits.isEmpty
    }
    private var hasLabAppointments: Bool {
        !todayLabVisits.isEmpty || !futureLabVisits.isEmpty
    }

    private func doctorForAppointment(_ appointment: Appointment) -> Doctor {
        let name = appointment.doctorName.replacingOccurrences(of: "Dr. ", with: "")
        if let doctor = MockData.doctors.first(where: { $0.fullName == name }) { return doctor }
        let parts = name.split(separator: " ", maxSplits: 1)
        return Doctor(
            firstName: String(parts.first ?? ""),
            lastName: String(parts.last ?? ""),
            degree: "MD",
            specialty: appointment.specialty,
            rating: 0,
            imageName: nil,
            availableTime: "",
            specialtyType: .general,
            experience: "",
            patients: "",
            reviews: "",
            fee: appointment.totalAmount,
            timeSlots: [],
            bio: "",
            availability: ""
        )
    }

    @ViewBuilder
    private func upcomingCard(for visit: Appointment) -> some View {
        TodayVisitCard(
            type: .upcoming(
                doctor: visit.doctorName,
                specialty: visit.specialty,
                location: visit.location,
                token: visit.token ?? "",
                timeSlot: visit.timeSlot,
                isTest: visit.isTest
            ),
            onCancel: {
                appointmentToCancel = visit
                showCancelAlert = true
            },
            onReschedule: {
                appointmentToReschedule = visit
                if visit.isTest { showLabReschedule = true } else { showReschedule = true }
            }
        )
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {

                HStack {
                    Text("Appointments")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(.primary)
                    Spacer()
                }
                .padding(.horizontal, 20)
                .padding(.top, 16)
                .padding(.bottom, 12)

                ScrollView(showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 18) {

                        AppointmentSegmentedControl(selectedTab: $selectedTab)

                        BookAppointmentButton(showBookingFlow: $showBookingFlow)
                            .fullScreenCover(isPresented: $showBookingFlow) {
                                NavigationStack {
                                    ChooseDoctorView(selectedTab: $router.currentTab, onFlowComplete: {
                                        showBookingFlow = false
                                    })
                                }
                            }

                        if selectedTab == "Upcoming" {
                            if hasDoctorAppointments {
                                AppointmentSectionHeader(title: "Doctor Visits")
                            }
                            if !todayDoctorVisits.isEmpty {
                                AppointmentSubheader(title: "Today")
                                ForEach(todayDoctorVisits) { visit in
                                    Button(action: {
                                        presentBookingQR(for: visit)
                                    }) {
                                        upcomingCard(for: visit)
                                    }
                                    .buttonStyle(.plain)
                                }
                            }
                            if !futureDoctorVisits.isEmpty {
                                AppointmentSubheader(title: "Upcoming")
                                ForEach(futureDoctorVisits) { visit in
                                    Button(action: {
                                        presentBookingQR(for: visit)
                                    }) {
                                        upcomingCard(for: visit)
                                    }
                                    .buttonStyle(.plain)
                                }
                            }
                            if hasLabAppointments {
                                AppointmentSectionHeader(title: "Test / Lab Appointments")
                            }
                            if !todayLabVisits.isEmpty {
                                AppointmentSubheader(title: "Today")
                                ForEach(todayLabVisits) { visit in
                                    Button(action: {
                                        presentBookingQR(for: visit)
                                    }) {
                                        upcomingCard(for: visit)
                                    }
                                    .buttonStyle(.plain)
                                }
                            }
                            if !futureLabVisits.isEmpty {
                                AppointmentSubheader(title: "Upcoming")
                                ForEach(futureLabVisits) { visit in
                                    Button(action: {
                                        presentBookingQR(for: visit)
                                    }) {
                                        upcomingCard(for: visit)
                                    }
                                    .buttonStyle(.plain)
                                }
                            }
                            if !hasDoctorAppointments && !hasLabAppointments {
                                AppointmentEmptyState(icon: "calendar.badge.clock", message: "No upcoming appointments")
                            }

                        } else if selectedTab == "Ongoing" {
                            ongoingContent

                        } else if selectedTab == "Completed" {
                            if !pastDoctorVisits.isEmpty {
                                AppointmentSectionHeader(title: "Doctor Visits")
                                ForEach(pastDoctorVisits) { visit in
                                    Button(action: {
                                        presentBookingQR(for: visit)
                                    }) {
                                        PastVisitCard(title: visit.doctorName, subtitle: visit.specialty, date: visit.formattedDate, isTest: visit.isTest)
                                    }
                                    .buttonStyle(.plain)
                                }
                            }
                            if !pastLabVisits.isEmpty {
                                AppointmentSectionHeader(title: "Test / Lab Appointments")
                                ForEach(pastLabVisits) { visit in
                                    Button(action: {
                                        presentBookingQR(for: visit)
                                    }) {
                                        PastVisitCard(title: visit.doctorName, subtitle: visit.specialty, date: visit.formattedDate, isTest: visit.isTest)
                                    }
                                    .buttonStyle(.plain)
                                }
                            }
                            if pastDoctorVisits.isEmpty && pastLabVisits.isEmpty {
                                AppointmentEmptyState(icon: "checkmark.circle.fill", message: "No completed appointments")
                            }
                        }

                        Spacer(minLength: 120)
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 8)
                }
            }
            // Present booking QR (same payload as after payment)
            .sheet(isPresented: $showBookingQR) {
                if let appt = selectedAppointmentForQR {
                    let receipt = (appt.token?.isEmpty == false) ? (appt.token ?? "") : String(appt.id.uuidString.prefix(8))
                    let amountText = String(format: "%.2f", appt.totalAmount)
                     AppointmentQRCodeSheet(
                         title: appt.isTest ? "Lab Visit Confirmed" : "Appointment Confirmed",
                         receiptNumber: receipt,
                         qrImage: qrGenerator.generatePaymentQRCode(from: receipt),
                         primaryMessage: "Scan at Counter",
                         secondaryMessage: appt.isTest
                             ? "Show this QR code at the lab reception\nfor quick check-in"
                             : "Show this QR code at the reception\nfor quick check-in",
                         details: [
                             .init(label: appt.isTest ? "Test" : "Doctor", value: appt.doctorName),
                             .init(label: "Date & Time", value: "\(appt.formattedDate) • \(appt.timeSlot)"),
                             .init(label: "Location", value: appt.location),
                            .init(label: "Amount", value: "LKR \(amountText)")
                         ]
                     )
                 }
             }
            .navigationBarHidden(true)
            .background(
                LinearGradient(
                    colors: [Color(red: 0.92, green: 0.96, blue: 1.0), Color(.systemGroupedBackground)],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()
            )
            .alert("Confirm Cancellation", isPresented: $showCancelAlert) {
                Button("No", role: .cancel) { appointmentToCancel = nil }
                Button("Confirm", role: .destructive) {
                    if let appointment = appointmentToCancel {
                        withAnimation { appointmentStore.removeAppointment(appointment.id) }
                        appointmentToCancel = nil
                    }
                }
            } message: {
                Text("Are you sure you want to cancel this appointment?")
            }
            .navigationDestination(isPresented: $showReschedule) {
                if let appointment = appointmentToReschedule {
                    BookingTimeView(doctor: doctorForAppointment(appointment))
                }
            }
            .navigationDestination(isPresented: $showLabReschedule) {
                if let appointment = appointmentToReschedule {
                    LabVisitDetailsView(
                        selectedTests: [LabTest(name: appointment.doctorName, description: appointment.specialty, price: appointment.totalAmount, category: .blood)],
                        totalPrice: appointment.totalAmount
                    )
                }
            }
            .safeAreaInset(edge: .bottom) {
                FloatingNavBarView(selectedTab: $router.currentTab)
            }
            .onAppear {
                if let tab = router.appointmentsInitialTab {
                    selectedTab = tab
                    router.appointmentsInitialTab = nil
                }
            }
            .onChange(of: router.appointmentsInitialTab) { newValue in
                if let tab = newValue {
                    selectedTab = tab
                    router.appointmentsInitialTab = nil
                }
            }
        }
    }

    @ViewBuilder
    private var ongoingContent: some View {
        let ongoingAppointments = currentAppointments

        if ongoingAppointments.isEmpty {
            AppointmentEmptyState(icon: "clock.fill", message: "No ongoing appointments")
        } else {
            AppointmentSectionHeader(title: "Active Visit")

            ongoingJourneyBanner

            // Allow tapping the main flow progress card to open the QR scanner
            Button(action: {
                if let appt = appointmentStore.activeAppointment {
                    presentBookingQR(for: appt)
                }
            }) {
                TodayVisitCard(type: .flowProgress(flowViewModel: flowViewModel))
            }
            .buttonStyle(.plain)

            let otherOngoing = ongoingAppointments.filter { $0.id != flowViewModel.activeAppointmentId }
            if !otherOngoing.isEmpty {
                AppointmentSectionHeader(title: "Other Appointments")
                ForEach(otherOngoing) { visit in
                    if let position = visit.queuePosition {
                        Button(action: {
                            presentBookingQR(for: visit)
                        }) {
                            TodayVisitCard(type: .ongoing(
                                doctor: visit.doctorName,
                                specialty: visit.specialty,
                                location: visit.location,
                                token: visit.token ?? "",
                                position: position,
                                isTest: visit.isTest
                            ))
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
        }
    }

    private var ongoingJourneyBanner: some View {
        HStack(spacing: 12) {
            Image(systemName: flowViewModel.stageIcon)
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(Color(hex: flowViewModel.stageColor[0]))
                .frame(width: 36, height: 36)
                .background(Color(hex: flowViewModel.stageColor[0]).opacity(0.12))
                .clipShape(Circle())

            VStack(alignment: .leading, spacing: 2) {
                Text(flowViewModel.stageTitle)
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(.primary)
                Text(flowViewModel.stageSubtitle)
                    .font(.system(size: 12))
                    .foregroundColor(Color(.systemGray))
                    .lineLimit(1)
            }

            Spacer()

            if flowViewModel.currentStage == .inQueue {
                Text(flowViewModel.estimatedWaitText)
                    .font(.system(size: 13, weight: .bold))
                    .foregroundColor(Color(hex: flowViewModel.stageColor[0]))
            }
        }
        .padding(14)
        .background(Color(hex: flowViewModel.stageColor[0]).opacity(0.07))
        .cornerRadius(14)
        .overlay(
            RoundedRectangle(cornerRadius: 14)
                .stroke(Color(hex: flowViewModel.stageColor[0]).opacity(0.2), lineWidth: 1)
        )
    }
}

struct AppointmentSectionHeader: View {
    let title: String
    var body: some View {
        Text(title)
            .font(.system(size: 20, weight: .bold))
            .foregroundColor(.primary)
            .padding(.top, 4)
    }
}

struct AppointmentEmptyState: View {
    let icon: String
    let message: String
    var body: some View {
        VStack(spacing: 14) {
            Image(systemName: icon)
                .font(.system(size: 42))
                .foregroundColor(Color(.systemGray3))
            Text(message)
                .font(.system(size: 15))
                .foregroundColor(Color(.systemGray))
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 60)
    }
}

struct AppointmentSubheader: View {
    let title: String
    var body: some View {
        Text(title)
            .font(.system(size: 15, weight: .medium))
            .foregroundColor(Color(.systemGray))
    }
}

#Preview {
    let store = AppointmentStore()
    let flow = AppointmentFlowViewModel(appointmentStore: store)
    return AppointmentsView()
        .environmentObject(store)
        .environmentObject(AppRouter())
        .environmentObject(flow)
}
