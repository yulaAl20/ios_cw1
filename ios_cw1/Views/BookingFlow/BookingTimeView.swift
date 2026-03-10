//
//  BookingTimeView.swift
//  ios_cw1
//
//  Created by COBSCCOMP242P-74 on 2026-03-04.
//

import SwiftUI

struct BookingTimeView: View {
    let doctor: Doctor
    var onFlowComplete: (() -> Void)? = nil

    @Environment(\.dismiss) private var dismiss
    @State private var selectedDate: Date? = nil
    @State private var selectedTimeSlot: String? = nil
    @State private var currentWeekOffset: Int = 0
    @State private var navigateToConfirm = false

    // Simulated booked slots per day (keyed by day-of-year)
    private let bookedSlots: [Int: Set<String>] = {
        let calendar = Calendar.current
        let today = Date()
        var booked: [Int: Set<String>] = [:]
        for dayOffset in 0..<21 {
            if let date = calendar.date(byAdding: .day, value: dayOffset, to: today) {
                let dayOfYear = calendar.ordinality(of: .day, in: .year, for: date) ?? 0
                // Simulate some booked slots differently per day
                switch dayOffset % 5 {
                case 0: booked[dayOfYear] = ["10:00 AM", "12:00 PM", "3:00 PM"]
                case 1: booked[dayOfYear] = ["11:00 AM", "1:00 PM", "5:00 PM"]
                case 2: booked[dayOfYear] = ["10:00 AM", "2:00 PM", "4:00 PM"]
                case 3: booked[dayOfYear] = ["12:00 PM", "3:00 PM"]
                case 4: booked[dayOfYear] = ["11:00 AM", "4:00 PM", "5:00 PM"]
                default: booked[dayOfYear] = []
                }
            }
        }
        return booked
    }()

    // All available time slots per day (10am-6pm, varies by day)
    private func timeSlotsForDate(_ date: Date) -> [String] {
        let calendar = Calendar.current
        let weekday = calendar.component(.weekday, from: date) // 1=Sun, 7=Sat

        switch weekday {
        case 1: // Sunday - shorter hours
            return ["10:00 AM", "11:00 AM", "12:00 PM", "1:00 PM", "2:00 PM"]
        case 7: // Saturday - morning only
            return ["10:00 AM", "11:00 AM", "12:00 PM", "1:00 PM"]
        case 2, 4: // Mon, Wed - full day
            return ["10:00 AM", "11:00 AM", "12:00 PM", "1:00 PM", "2:00 PM", "3:00 PM", "4:00 PM", "5:00 PM"]
        case 3, 5: // Tue, Thu - skip lunch
            return ["10:00 AM", "11:00 AM", "2:00 PM", "3:00 PM", "4:00 PM", "5:00 PM"]
        case 6: // Friday
            return ["10:00 AM", "11:00 AM", "12:00 PM", "1:00 PM", "2:00 PM", "3:00 PM"]
        default:
            return ["10:00 AM", "11:00 AM", "12:00 PM", "1:00 PM", "2:00 PM", "3:00 PM", "4:00 PM", "5:00 PM"]
        }
    }

    private func isSlotBooked(_ slot: String, on date: Date) -> Bool {
        let calendar = Calendar.current
        let dayOfYear = calendar.ordinality(of: .day, in: .year, for: date) ?? 0
        return bookedSlots[dayOfYear]?.contains(slot) ?? false
    }

    // Generate dates for current week offset
    private var datesForCurrentWeek: [(day: Int, weekday: String, date: Date)] {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        var dates: [(Int, String, Date)] = []
        let startOffset = currentWeekOffset * 7
        for i in 0..<7 {
            if let date = calendar.date(byAdding: .day, value: startOffset + i, to: today) {
                let day = calendar.component(.day, from: date)
                let weekday = date.formatted(.dateTime.weekday(.abbreviated))
                dates.append((day, weekday, date))
            }
        }
        return dates
    }

    // Month/year label for the current week
    private var currentMonthLabel: String {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        guard let midDate = calendar.date(byAdding: .day, value: currentWeekOffset * 7 + 3, to: today) else {
            return ""
        }
        let f = DateFormatter()
        f.dateFormat = "MMMM yyyy"
        return f.string(from: midDate)
    }

    // Morning / Afternoon / Evening split
    private func morningSlots(for date: Date) -> [String] {
        timeSlotsForDate(date).filter { $0.contains("AM") }
    }

    private func afternoonSlots(for date: Date) -> [String] {
        timeSlotsForDate(date).filter { slot in
            guard slot.contains("PM") else { return false }
            let hourStr = slot.split(separator: ":").first.map(String.init) ?? "0"
            let hour = Int(hourStr) ?? 0
            return hour >= 12 || (hour >= 1 && hour < 5)
        }
    }

    private func eveningSlots(for date: Date) -> [String] {
        timeSlotsForDate(date).filter { slot in
            guard slot.contains("PM") else { return false }
            let hourStr = slot.split(separator: ":").first.map(String.init) ?? "0"
            let hour = Int(hourStr) ?? 0
            return hour >= 5 && hour < 12
        }
    }

    var body: some View {
        VStack(spacing: 0) {
            // Header
            HStack {
                Button(action: { dismiss() }) {
                    Image(systemName: "chevron.left")
                        .font(.title2)
                        .foregroundColor(.primary)
                }
                Spacer()
                Text("Book Appointment")
                    .font(.headline)
                    .fontWeight(.semibold)
                Spacer()
                Color.clear.frame(width: 44, height: 44)
            }
            .padding(.horizontal, 20)
            .padding(.top, 16)
            .padding(.bottom, 8)

            // Doctor info (no Edit button)
            HStack(spacing: 12) {
                Group {
                    if let imageName = doctor.imageName, let uiImage = UIImage(named: imageName) {
                        Image(uiImage: uiImage)
                            .resizable()
                            .scaledToFill()
                    } else {
                        Image(systemName: "person.fill")
                            .resizable()
                            .scaledToFit()
                            .foregroundStyle(.blue)
                            .background(Color.blue.opacity(0.15))
                    }
                }
                .frame(width: 48, height: 48)
                .clipShape(Circle())

                VStack(alignment: .leading, spacing: 2) {
                    Text("Dr. \(doctor.fullName)")
                        .font(.headline)
                    Text(doctor.specialty)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                Spacer()
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 16)

            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 24) {

                    // MARK: - Select Date
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Select Date")
                            .font(.title3)
                            .fontWeight(.semibold)
                            .padding(.horizontal, 20)

                        // Month navigator with arrows
                        HStack {
                            Button(action: {
                                if currentWeekOffset > 0 {
                                    withAnimation { currentWeekOffset -= 1 }
                                    selectedDate = nil
                                    selectedTimeSlot = nil
                                }
                            }) {
                                Image(systemName: "chevron.left")
                                    .font(.title3)
                                    .foregroundColor(currentWeekOffset > 0 ? .blue : .gray.opacity(0.3))
                            }
                            .disabled(currentWeekOffset <= 0)

                            Spacer()
                            Text(currentMonthLabel)
                                .font(.headline)
                                .fontWeight(.semibold)
                            Spacer()

                            Button(action: {
                                withAnimation { currentWeekOffset += 1 }
                                selectedDate = nil
                                selectedTimeSlot = nil
                            }) {
                                Image(systemName: "chevron.right")
                                    .font(.title3)
                                    .foregroundColor(.blue)
                            }
                        }
                        .padding(.horizontal, 24)

                        // Horizontal scrollable date cards
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 12) {
                                ForEach(datesForCurrentWeek, id: \.date) { item in
                                    DateCard(
                                        day: item.day,
                                        weekday: item.weekday,
                                        isSelected: selectedDate != nil && Calendar.current.isDate(item.date, inSameDayAs: selectedDate!),
                                        action: {
                                            withAnimation(.easeInOut(duration: 0.2)) {
                                                selectedDate = item.date
                                                selectedTimeSlot = nil
                                            }
                                        }
                                    )
                                }
                            }
                            .padding(.horizontal, 20)
                        }
                    }

                    // MARK: - Time Slots (only shown after date is selected)
                    if let date = selectedDate {
                        let morning = morningSlots(for: date)
                        let afternoon = afternoonSlots(for: date)
                        let evening = eveningSlots(for: date)

                        VStack(alignment: .leading, spacing: 20) {
                            Text("Select Time")
                                .font(.title3)
                                .fontWeight(.semibold)
                                .padding(.horizontal, 20)

                            if !morning.isEmpty {
                                slotSection(title: "Morning", slots: morning, date: date)
                            }
                            if !afternoon.isEmpty {
                                slotSection(title: "Afternoon", slots: afternoon, date: date)
                            }
                            if !evening.isEmpty {
                                slotSection(title: "Evening", slots: evening, date: date)
                            }
                        }
                        .transition(.opacity.combined(with: .move(edge: .bottom)))
                    } else {
                        // Prompt
                        VStack(spacing: 12) {
                            Image(systemName: "calendar")
                                .font(.system(size: 40))
                                .foregroundColor(.gray.opacity(0.4))
                            Text("Select a date to view available time slots")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                                .multilineTextAlignment(.center)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 40)
                    }
                }
                .padding(.bottom, 140)
            }

            // Confirm button
            VStack {
                Button(action: {
                    if selectedDate != nil && selectedTimeSlot != nil {
                        navigateToConfirm = true
                    }
                }) {
                    Text("Confirm Booking")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 18)
                        .background(selectedDate != nil && selectedTimeSlot != nil ? Color.blue : Color.gray.opacity(0.4))
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                }
                .disabled(selectedDate == nil || selectedTimeSlot == nil)
                .padding(.horizontal, 20)
                .padding(.vertical, 16)
                .background(Color(.systemBackground))
                .shadow(color: .black.opacity(0.12), radius: 10, y: -6)

                NavigationLink(
                    destination: ConfirmDetailsView(
                        doctor: doctor,
                        selectedDate: selectedDate ?? Date(),
                        selectedTimeSlot: selectedTimeSlot ?? "",
                        onFlowComplete: onFlowComplete
                    ),
                    isActive: $navigateToConfirm
                ) {
                    EmptyView()
                }
            }
        }
        .navigationBarHidden(true)
    }

    // MARK: - Slot Section

    func slotSection(title: String, slots: [String], date: Date) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(alignment: .firstTextBaseline, spacing: 8) {
                Text(title)
                    .font(.subheadline)
                    .fontWeight(.semibold)

                let availableCount = slots.filter { !isSlotBooked($0, on: date) }.count
                Text("\(availableCount) available")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            .padding(.horizontal, 20)

            LazyVGrid(columns: [
                GridItem(.flexible()),
                GridItem(.flexible()),
                GridItem(.flexible())
            ], spacing: 10) {
                ForEach(slots, id: \.self) { time in
                    let booked = isSlotBooked(time, on: date)
                    let isSelected = selectedTimeSlot == time

                    Button(action: {
                        if !booked {
                            selectedTimeSlot = time
                        }
                    }) {
                        Text(time)
                            .font(.subheadline)
                            .fontWeight(.medium)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 12)
                            .background(
                                booked ? Color(.systemGray5) :
                                isSelected ? Color.blue :
                                Color(.systemGray6)
                            )
                            .foregroundColor(
                                booked ? Color(.systemGray3) :
                                isSelected ? .white :
                                .primary
                            )
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                            .overlay(
                                booked ?
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(Color(.systemGray4), lineWidth: 1)
                                : nil
                            )
                    }
                    .disabled(booked)
                }
            }
            .padding(.horizontal, 20)
        }
    }
}

#Preview {
    NavigationStack {
        BookingTimeView(doctor: MockData.doctors[0])
    }
}
