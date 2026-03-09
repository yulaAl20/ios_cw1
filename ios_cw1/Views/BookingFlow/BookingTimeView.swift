//
//  BookingTimeView.swift
//  ios_cw1
//
//  Created by COBSCCOMP242P-74 on 2026-03-04.
//

import SwiftUI

struct BookingTimeView: View {
    let doctor: Doctor
    let selectedDate: Date
    var onFlowComplete: (() -> Void)? = nil

    @Environment(\.dismiss) private var dismiss
    @State private var selectedTimeSlot: String? = nil
    @State private var displayedMonth: Date = Date()
    @State private var navigateToConfirm = false

    private func hourFromTime(_ time: String) -> Int? {
        let components = time.split(separator: ":")
        guard let hourStr = components.first, let hour = Int(hourStr) else { return nil }
        return hour
    }

    private var morningSlots: [String] {
        doctor.timeSlots.filter { slot in
            guard let hour = hourFromTime(slot) else { return false }
            return hour >= 0 && hour < 12
        }.sorted()
    }

    private var afternoonSlots: [String] {
        doctor.timeSlots.filter { slot in
            guard let hour = hourFromTime(slot) else { return false }
            return hour >= 12 && hour < 17
        }.sorted()
    }

    private var eveningSlots: [String] {
        doctor.timeSlots.filter { slot in
            guard let hour = hourFromTime(slot) else { return false }
            return hour >= 17
        }.sorted()
    }

    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Button(action: { dismiss() }) {
                    Image(systemName: "chevron.left")
                        .font(.title2)
                        .foregroundColor(.primary)
                }
                Spacer()
                Color.clear.frame(width: 44, height: 44)
            }
            .padding(.horizontal, 20)
            .padding(.top, 16)
            .padding(.bottom, 8)

            HStack(spacing: 12) {
                // Doctor image
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
                        .foregroundStyle(.gray)
                }

                Spacer()

                // Edit button
                Button("Edit") {
                    dismiss()
                }
                .font(.subheadline)
                .fontWeight(.medium)
                .foregroundStyle(.blue)
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 12)

            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 28) {
                    // Selected Date section
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Selected Date")
                            .font(.title3)
                            .fontWeight(.semibold)
                            .padding(.horizontal, 20)

                        // Month navigator
                        HStack {
                            Button(action: {}) {
                                Image(systemName: "chevron.left")
                                    .foregroundStyle(.gray)
                                    .font(.title3)
                            }
                            Spacer()
                            Text(displayedMonth.formatted(.dateTime.month(.wide).year()))
                                .font(.subheadline.bold())
                            Spacer()
                            Button(action: {}) {
                                Image(systemName: "chevron.right")
                                    .foregroundStyle(.gray)
                                    .font(.title3)
                            }
                        }
                        .padding(.horizontal, 20)

                        // Horizontal date cards
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 12) {
                                ForEach(generateDateCards(), id: \.date) { item in
                                    DateCard(
                                        day: item.day,
                                        weekday: item.weekday,
                                        isSelected: Calendar.current.isDate(item.date, inSameDayAs: selectedDate),
                                        action: {}
                                    )
                                }
                            }
                            .padding(.horizontal, 20)
                        }
                    }

                    // Time slots sections
                    if !morningSlots.isEmpty {
                        TimeSlotSection(title: "Morning", slotCount: morningSlots.count, slots: morningSlots, selectedSlot: $selectedTimeSlot)
                    }
                    if !afternoonSlots.isEmpty {
                        TimeSlotSection(title: "Afternoon", slotCount: afternoonSlots.count, slots: afternoonSlots, selectedSlot: $selectedTimeSlot)
                    }
                    if !eveningSlots.isEmpty {
                        TimeSlotSection(title: "Evening", slotCount: eveningSlots.count, slots: eveningSlots, selectedSlot: $selectedTimeSlot)
                    }
                }
                .padding(.bottom, 140)
            }

            // Confirm button
            VStack {
                Button(action: {
                    if selectedTimeSlot != nil {
                        navigateToConfirm = true
                    }
                }) {
                    Text("Confirm Booking")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 18)
                        .background(selectedTimeSlot != nil ? Color.blue : Color.gray)
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                }
                .disabled(selectedTimeSlot == nil)
                .padding(.horizontal, 20)
                .padding(.vertical, 16)
                .background(Color(.systemBackground))
                .shadow(color: .black.opacity(0.12), radius: 10, y: -6)

                NavigationLink(
                    destination: ConfirmDetailsView(
                        doctor: doctor,
                        selectedDate: selectedDate,
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

    private func generateDateCards() -> [(day: Int, weekday: String, date: Date)] {
        let calendar = Calendar.current
        var result: [(Int, String, Date)] = []
        for offset in -2...4 {
            if let date = calendar.date(byAdding: .day, value: offset, to: selectedDate) {
                let day = calendar.component(.day, from: date)
                let weekday = date.formatted(.dateTime.weekday(.abbreviated))
                result.append((day, weekday, date))
            }
        }
        return result
    }
}

struct TimeSlotSection: View {
    let title: String
    let slotCount: Int
    let slots: [String]
    @Binding var selectedSlot: String?

    private var rows: [[String]] {
        stride(from: 0, to: slots.count, by: 3).map {
            Array(slots[$0..<min($0+3, slots.count)])
        }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(alignment: .firstTextBaseline, spacing: 8) {
                Text(title)
                    .font(.title3)
                    .fontWeight(.semibold)
                Text("\(slotCount) slots")
                    .font(.subheadline)
                    .foregroundStyle(.gray)
            }
            .padding(.horizontal, 20)

            ForEach(rows, id: \.self) { row in
                HStack(spacing: 12) {
                    ForEach(row, id: \.self) { time in
                        TimeSlotChip(time: time, isSelected: selectedSlot == time) {
                            selectedSlot = time
                        }
                    }
                    ForEach(0..<(3 - row.count), id: \.self) { _ in
                        Color.clear.frame(maxWidth: .infinity)
                    }
                }
                .padding(.horizontal, 20)
            }
        }
    }
}

struct TimeSlotChip: View {
    let time: String
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(time)
                .font(.subheadline)
                .fontWeight(.medium)
                .padding(.horizontal, 14)
                .padding(.vertical, 10)
                .frame(minWidth: 95)
                .background(isSelected ? Color.blue : Color(.systemGray6))
                .foregroundStyle(isSelected ? .white : .primary)
                .clipShape(RoundedRectangle(cornerRadius: 12))
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    BookingTimeView(doctor: MockData.doctors[0], selectedDate: Date())
}
