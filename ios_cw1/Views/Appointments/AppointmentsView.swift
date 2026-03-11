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
    var selectedTabBinding: Binding<Int>?

    @State private var selectedTab = "Upcoming"

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

    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Button(action: {
                    if let binding = selectedTabBinding {
                        binding.wrappedValue = 0
                    } else {
                        dismiss()
                    }
                }) {
                    Image(systemName: "chevron.left")
                        .font(.title2)
                        .foregroundColor(.primary)
                }
                Spacer()
                Text("Appointments")
                    .font(.headline)
                    .fontWeight(.semibold)
                Spacer()
                Color.clear.frame(width: 44, height: 44)
            }
            .padding(.horizontal, 24)
            .padding(.top, 16)
            .padding(.bottom, 8)

            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 18) {

                    AppointmentSegmentedControl(selectedTab: $selectedTab)

                    BookAppointmentButton()

                    if selectedTab == "Upcoming" {
                        if !todayVisits.isEmpty {
                            AppointmentSectionHeader(title: "Today's Visits")
                            ForEach(todayVisits) { visit in
                                TodayVisitCard(type: .upcoming(
                                    doctor: visit.doctorName,
                                    specialty: visit.specialty,
                                    location: visit.location,
                                    token: visit.token ?? "",
                                    timeSlot: visit.timeSlot,
                                    isTest: visit.isTest
                                ))
                            }
                        }

                        if !futureVisits.isEmpty {
                            AppointmentSectionHeader(title: "Upcoming Visits")
                            ForEach(futureVisits) { visit in
                                TodayVisitCard(type: .upcoming(
                                    doctor: visit.doctorName,
                                    specialty: visit.specialty,
                                    location: visit.location,
                                    token: visit.token ?? "",
                                    timeSlot: visit.timeSlot,
                                    isTest: visit.isTest
                                ))
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

                    Spacer(minLength: 40)
                }
                .padding(.horizontal, 20)
                .padding(.top, 8)
            }
        }
        .navigationBarHidden(true)
        .background(Color(.systemGroupedBackground).ignoresSafeArea())
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
    return NavigationStack {
        AppointmentsView()
            .environmentObject(sampleStore)
    }
}
