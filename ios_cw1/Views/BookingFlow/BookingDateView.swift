//
//  BookingDateView.swift
//  ios_cw1
//
//  Created by COBSCCOMP242P-74 on 2026-03-04.
//

import SwiftUI

struct BookingDateView: View {
    let doctor: Doctor
    var onFlowComplete: (() -> Void)? = nil

    @Environment(\.dismiss) private var dismiss
    @State private var selectedDate: Date? = nil
    @State private var currentMonth = Date()
    @State private var showFullProfile = false

    private var datesForWeek: [(day: Int, weekday: String, date: Date)] {
        let calendar = Calendar.current
        let today = Date()
        guard let weekRange = calendar.dateInterval(of: .weekOfMonth, for: today) else { return [] }
        var dates: [(Int, String, Date)] = []
        for offset in 0..<7 {
            if let date = calendar.date(byAdding: .day, value: offset, to: weekRange.start) {
                let day = calendar.component(.day, from: date)
                let weekday = date.formatted(.dateTime.weekday(.abbreviated))
                dates.append((day, weekday, date))
            }
        }
        return dates
    }

    var body: some View {
        ZStack(alignment: .bottom) {
            ScrollView(showsIndicators: false) {
                VStack(spacing: 24) {
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
                    .padding(.horizontal, 24)
                    .padding(.top, 16)

                    DoctorHeader(doctor: doctor)

                    HStack {
                        Spacer()
                        Button(action: {
                            showFullProfile = true
                        }) {
                            Text("View More")
                                .font(.subheadline)
                                .fontWeight(.medium)
                                .foregroundColor(.blue)
                        }
                    }
                    .padding(.horizontal, 24)
                    .padding(.top, -8)

                    // Select Date section
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Select Date")
                            .font(.title3)
                            .fontWeight(.semibold)
                            .padding(.horizontal, 24)

                        MonthNavigator(
                            currentMonth: $currentMonth,
                            onPrev: { },
                            onNext: { }
                        )

                        // Horizontal date cards
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 12) {
                                ForEach(datesForWeek, id: \.date) { item in
                                    DateCard(
                                        day: item.day,
                                        weekday: item.weekday,
                                        isSelected: selectedDate == item.date,
                                        action: {
                                            selectedDate = item.date
                                        }
                                    )
                                }
                            }
                            .padding(.horizontal, 24)
                        }
                    }

                    Spacer(minLength: 100)
                }
            }
            .background(Color(.systemBackground))

            // Continue button
            VStack {
                NavigationLink(destination: BookingTimeView(doctor: doctor, selectedDate: selectedDate ?? Date(), onFlowComplete: onFlowComplete)) {
                    Text("Continue")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 18)
                        .background(selectedDate != nil ? Color.blue : Color.gray)
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                }
                .disabled(selectedDate == nil)
                .padding(.horizontal, 24)
                .padding(.vertical, 16)
                .background(Color(.systemBackground))
                .shadow(color: .black.opacity(0.1), radius: 12, y: -6)
            }
        }
        .navigationBarHidden(true)
        .sheet(isPresented: $showFullProfile) {
            FullDoctorProfileView(doctor: doctor)
        }
    }
}

#Preview {
    BookingDateView(doctor: MockData.doctors[0])
}
