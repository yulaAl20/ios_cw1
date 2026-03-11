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
    var selectedTabBinding: Binding<Int>?

    @State private var selectedTab = "Upcoming"
    @State private var showBookingFlow = false
    @State private var showCancelAlert = false
    @State private var appointmentToCancel: Appointment? = nil
    @State private var appointmentToReschedule: Appointment? = nil
    @State private var showReschedule = false

    private var currentAppointments: [Appointment] {
        switch selectedTab {
        case "Upcoming":  return appointmentStore.appointments.filter { $0.status == .upcoming }
        case "Ongoing":   return appointmentStore.appointments.filter { $0.status == .ongoing }
        case "Completed": return appointmentStore.appointments.filter { $0.status == .completed }
        default:          return []
        }
    }

    private var todayVisits: [Appointment] {
        currentAppointments.filter { Calendar.current.isDateInToday($0.date) }
    }

    private var futureVisits: [Appointment] {
        currentAppointments.filter { !Calendar.current.isDateInToday($0.date) && $0.date > Date() }
    }

    private var pastVisits: [Appointment] {
        currentAppointments
    }

    private func doctorForAppointment(_ appointment: Appointment) -> Doctor {
        let name = appointment.doctorName.replacingOccurrences(of: "Dr. ", with: "")
        if let doctor = MockData.doctors.first(where: { $0.fullName == name }) {
            return doctor
        }
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
                            if !todayVisits.isEmpty {
                                AppointmentSectionHeader(title: "Today's Visits")
                                ForEach(todayVisits) { visit in
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
                                            showReschedule = true
                                        }
                                    )
                                }
                            }

                            if !futureVisits.isEmpty {
                                AppointmentSectionHeader(title: "Upcoming Visits")
                                ForEach(futureVisits) { visit in
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
                                            showReschedule = true
                                        }
                                    )
                                }
                            }

                            if todayVisits.isEmpty && futureVisits.isEmpty {
                                AppointmentEmptyState(icon: "calendar.badge.clock", message: "No upcoming appointments")
                            }

                        } else if selectedTab == "Ongoing" {
                            if !todayVisits.isEmpty {
                                AppointmentSectionHeader(title: "Today's Visits")
                                ForEach(todayVisits) { visit in
                                    if let position = visit.queuePosition {
                                        TodayVisitCard(type: .ongoing(
                                            doctor: visit.doctorName,
                                            specialty: visit.specialty,
                                            location: visit.location,
                                            token: visit.token ?? "",
                                            position: position,
                                            isTest: visit.isTest
                                        ))
                                    }
                                }
                            } else {
                                AppointmentEmptyState(icon: "clock.fill", message: "No ongoing appointments")
                            }

                        } else if selectedTab == "Completed" {
                            if !pastVisits.isEmpty {
                                AppointmentSectionHeader(title: "Past Visits")
                                ForEach(pastVisits) { visit in
                                    PastVisitCard(
                                        title: visit.doctorName,
                                        subtitle: visit.specialty,
                                        date: visit.formattedDate,
                                        isTest: visit.isTest
                                    )
                                }
                            } else {
                                AppointmentEmptyState(icon: "checkmark.circle.fill", message: "No completed appointments")
                            }
                        }

                        Spacer(minLength: 120)
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 8)
                }
            }
            .navigationBarHidden(true)
            .background(Color(.systemGroupedBackground).ignoresSafeArea())
            .alert("Confirm Cancellation", isPresented: $showCancelAlert) {
                Button("No", role: .cancel) {
                    appointmentToCancel = nil
                }
                Button("Confirm", role: .destructive) {
                    if let appointment = appointmentToCancel {
                        withAnimation {
                            appointmentStore.removeAppointment(appointment.id)
                        }
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
            .safeAreaInset(edge: .bottom) {
                FloatingNavBarView(selectedTab: $router.currentTab)
            }
        }
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

#Preview {
    let sampleStore = AppointmentStore()
    sampleStore.appointments = [
        Appointment(
            doctorName: "Dr. Sarah Wilson",
            specialty: "Cardiologist",
            location: "Heart Care Center",
            token: "42",
            queuePosition: 5,
            date: Date(),
            timeSlot: "10:30 AM",
            status: .ongoing,
            isTest: false,
            patientName: "John Doe",
            patientPhone: "0777123456",
            totalAmount: 2300
        ),
        Appointment(
            doctorName: "Blood Test",
            specialty: "Lab",
            location: "Laboratory 03",
            token: "07",
            queuePosition: nil,
            date: Date(),
            timeSlot: "11:30 AM",
            status: .upcoming,
            isTest: true,
            patientName: "John Doe",
            patientPhone: "0777123456",
            totalAmount: 1200
        ),
        Appointment(
            doctorName: "Dr. Sarah Perera",
            specialty: "General Physician",
            location: "ClinicFlow",
            token: nil,
            queuePosition: nil,
            date: Calendar.current.date(byAdding: .day, value: -5, to: Date())!,
            timeSlot: "9:00 AM",
            status: .completed,
            isTest: false,
            patientName: "Alice Brown",
            patientPhone: "0777888999",
            totalAmount: 1800
        )
    ]
    return AppointmentsView()
            .environmentObject(sampleStore)
            .environmentObject(AppRouter())
}
