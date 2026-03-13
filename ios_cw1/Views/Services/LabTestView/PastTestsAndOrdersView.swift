//
//  PastTestsAndOrdersView.swift
//  ios_cw1
//
//  Created by Yulani Alwis on 2026-03-08.
//

import SwiftUI

struct PastTestsAndOrdersView: View {

    @Environment(\.dismiss) var dismiss
    @State private var selectedFilter: TestCategory? = nil

    // Date range filter (tiles)
    @State private var fromDate: Date? = nil
    @State private var toDate: Date? = nil

    private enum ActiveDatePicker: Identifiable {
        case from
        case to

        var id: String {
            switch self {
            case .from: return "from"
            case .to: return "to"
            }
        }
    }

    @State private var activeDatePicker: ActiveDatePicker? = nil

    init(initialFilter: TestCategory? = nil) {
        _selectedFilter = State(initialValue: initialFilter)
    }

    // test data
    private let testResults: [TestResult] = [
        TestResult(
            testName: "Blood Test",
            category: .blood,
            place: "ClinicFlow Central Lab",
            date: Calendar.current.date(byAdding: .day, value: -2, to: Date())!,
            doctorName: "Dr. Sarah Johnson",
            status: "Completed",
            reportAvailable: true,
            reportURL: "sample-report-url",
            icon: "drop.fill"
        ),
        TestResult(
            testName: "MRI Scan",
            category: .radiology,
            place: "ClinicFlow Imaging Center",
            date: Calendar.current.date(byAdding: .day, value: -7, to: Date())!,
            doctorName: "Dr. Michael Chen",
            status: "Report Ready",
            reportAvailable: true,
            reportURL: "sample-report-url",
            icon: "viewfinder"
        ),
        TestResult(
            testName: "Pharmacy Order",
            category: .pharmacy,
            place: "ClinicFlow Pharmacy",
            date: Calendar.current.date(byAdding: .day, value: -11, to: Date())!,
            doctorName: "Pharmacist Jane Smith",
            status: "Delivered",
            reportAvailable: false,
            icon: "pills.fill"
        ),
        TestResult(
            testName: "CBC Test",
            category: .blood,
            place: "ClinicFlow Central Lab",
            date: Calendar.current.date(byAdding: .day, value: -15, to: Date())!,
            doctorName: "Dr. Sarah Johnson",
            status: "Completed",
            reportAvailable: true,
            reportURL: "sample-report-url",
            icon: "drop.fill"
        ),
        TestResult(
            testName: "X-Ray",
            category: .radiology,
            place: "ClinicFlow Imaging Center",
            date: Calendar.current.date(byAdding: .day, value: -20, to: Date())!,
            doctorName: "Dr. Michael Chen",
            status: "Completed",
            reportAvailable: true,
            reportURL: "sample-report-url",
            icon: "viewfinder"
        ),
        TestResult(
            testName: "Urine Test",
            category: .urine,
            place: "ClinicFlow Central Lab",
            date: Calendar.current.date(byAdding: .day, value: -25, to: Date())!,
            doctorName: "Dr. Sarah Johnson",
            status: "Completed",
            reportAvailable: true,
            reportURL: "sample-report-url",
            icon: "waveform.path.ecg"
        )
    ]

    private var normalizedDateRange: (from: Date, toInclusive: Date)? {
        guard fromDate != nil || toDate != nil else { return nil }

        let calendar = Calendar.current
        let rawFrom = fromDate ?? toDate ?? Date()
        let rawTo = toDate ?? fromDate ?? Date()

        let minDate = min(rawFrom, rawTo)
        let maxDate = max(rawFrom, rawTo)

        let from = calendar.startOfDay(for: minDate)
        let toInclusive = calendar.date(byAdding: DateComponents(day: 1, second: -1), to: calendar.startOfDay(for: maxDate)) ?? maxDate
        return (from, toInclusive)
    }

    var filteredResults: [TestResult] {
        var results = testResults

        // Category filter
        if let filter = selectedFilter {
            results = results.filter { $0.category == filter }
        }

        // Date range filter (inclusive)
        if let range = normalizedDateRange {
            results = results.filter { result in
                let d = result.date
                return d >= range.from && d <= range.toInclusive
            }
        }

        return results.sorted { $0.date > $1.date }
    }

    var body: some View {
        ZStack(alignment: .top) {

            // Background
            Color(red: 0.90, green: 0.93, blue: 0.98)
                .ignoresSafeArea()

            VStack(spacing: 0) {

                // Header
                header

                // Date Tiles (From/To) ABOVE category filter chips
                VStack(spacing: 12) {
                    dateFilterTiles

                    filterChips
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 16)

                // Test List
                ScrollView(showsIndicators: false) {
                    LazyVStack(spacing: 12) {
                        ForEach(filteredResults) { result in
                            testCard(result)
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 40)
                }
            }
        }
        .navigationBarHidden(true)
        .sheet(item: $activeDatePicker) { picker in
            datePickerSheet(for: picker)
        }
    }
}


// HEADER

extension PastTestsAndOrdersView {

    var header: some View {
        HStack {
            Button(action: { dismiss() }) {
                Image(systemName: "chevron.left")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(Color(red: 0.15, green: 0.35, blue: 0.75))
                    .frame(width: 40, height: 40)
                    .background(Color.white)
                    .clipShape(Circle())
            }

            VStack(alignment: .leading, spacing: 2) {
                Text("Past Tests and Lab Reports")
                    .font(.system(size: 22, weight: .bold))
                    .foregroundColor(.black)

                Text("\(filteredResults.count) records found")
                    .font(.system(size: 13))
                    .foregroundColor(.gray)
            }

            Spacer()
        }
        .padding(.horizontal, 20)
        .padding(.top, 10)
        .padding(.bottom, 16)
        .background(Color(red: 0.82, green: 0.88, blue: 0.96))
    }
}


// DATE FILTER TILES

extension PastTestsAndOrdersView {

    private var dateFilterTiles: some View {
        HStack(spacing: 12) {
            dateTile(title: "From", date: fromDate, isActive: fromDate != nil) {
                activeDatePicker = .from
            } onClear: {
                fromDate = nil
            }

            dateTile(title: "To", date: toDate, isActive: toDate != nil) {
                activeDatePicker = .to
            } onClear: {
                toDate = nil
            }
        }
    }

    private func dateTile(
        title: String,
        date: Date?,
        isActive: Bool,
        onTap: @escaping () -> Void,
        onClear: @escaping () -> Void
    ) -> some View {
        Button(action: onTap) {
            HStack(spacing: 10) {
                ZStack {
                    Circle()
                        .fill(isActive ? Color(red: 0.15, green: 0.35, blue: 0.75) : Color.white)
                        .frame(width: 34, height: 34)
                        .shadow(color: .black.opacity(0.04), radius: 4, x: 0, y: 2)

                    Image(systemName: "calendar")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(isActive ? .white : Color(red: 0.15, green: 0.35, blue: 0.75))
                }

                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundColor(.gray)

                    Text(formattedTileDate(date))
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(.black)
                        .lineLimit(1)
                }

                Spacer(minLength: 0)

                if date != nil {
                    Button(role: .destructive, action: onClear) {
                        Image(systemName: "xmark.circle.fill")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(.gray.opacity(0.7))
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 10)
            .background(Color.white)
            .cornerRadius(16)
            .shadow(color: .black.opacity(0.04), radius: 6, x: 0, y: 3)
        }
        .buttonStyle(.plain)
    }

    private func formattedTileDate(_ date: Date?) -> String {
        guard let date else { return "Select date" }
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter.string(from: date)
    }

    @ViewBuilder
    private func datePickerSheet(for picker: ActiveDatePicker) -> some View {
        let title = (picker == .from) ? "From date" : "To date"

        NavigationStack {
            VStack(spacing: 16) {
                DatePicker(
                    "",
                    selection: Binding(
                        get: {
                            switch picker {
                            case .from:
                                return fromDate ?? Date()
                            case .to:
                                return toDate ?? Date()
                            }
                        },
                        set: { newValue in
                            switch picker {
                            case .from:
                                fromDate = newValue
                            case .to:
                                toDate = newValue
                            }
                        }
                    ),
                    displayedComponents: [.date]
                )
                .datePickerStyle(.graphical)
                .padding(.horizontal, 16)

                Spacer()
            }
            .navigationTitle(title)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Close") {
                        activeDatePicker = nil
                    }
                }

                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") {
                        activeDatePicker = nil
                    }
                }
            }
        }
    }
}


// FILTER CHIPS

extension PastTestsAndOrdersView {

    var filterChips: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 10) {
                filterChip(title: "All", category: nil)
                filterChip(title: "Blood Tests", category: .blood)
                filterChip(title: "Imaging", category: .radiology)
                filterChip(title: "Other Tests", category: .urine)
                filterChip(title: "Pharmacy", category: .pharmacy)
            }
        }
    }

    func filterChip(title: String, category: TestCategory?) -> some View {
        Button(action: {
            withAnimation(.easeInOut(duration: 0.2)) {
                selectedFilter = category
            }
        }) {
            Text(title)
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(selectedFilter == category ? .white : Color(red: 0.15, green: 0.35, blue: 0.75))
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(
                    selectedFilter == category ?
                    Color(red: 0.15, green: 0.35, blue: 0.75) :
                    Color.white
                )
                .cornerRadius(20)
                .shadow(color: .black.opacity(0.04), radius: 4, x: 0, y: 2)
        }
    }
}


// TEST CARD

extension PastTestsAndOrdersView {

    func testCard(_ result: TestResult) -> some View {
        NavigationLink(destination: TestResultView(testResult: result)) {
            HStack(spacing: 14) {

                // Icon
                ZStack {
                    Circle()
                        .fill(categoryColor(result.category).opacity(0.12))
                        .frame(width: 50, height: 50)

                    Image(systemName: result.icon)
                        .font(.system(size: 20))
                        .foregroundColor(categoryColor(result.category))
                }

                // Info
                VStack(alignment: .leading, spacing: 4) {
                    Text(result.testName)
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.black)

                    HStack(spacing: 4) {
                        Image(systemName: "checkmark.circle.fill")
                            .font(.system(size: 10))

                        Text(result.status)
                            .font(.system(size: 13))

                        Text("•")
                            .font(.system(size: 13))

                        Text(result.formattedDate)
                            .font(.system(size: 13))
                    }
                    .foregroundColor(.gray)

                    if result.reportAvailable {
                        Text("Report Available")
                            .font(.system(size: 11, weight: .semibold))
                            .foregroundColor(.green)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 3)
                            .background(Color.green.opacity(0.1))
                            .cornerRadius(8)
                    }
                }

                Spacer()

                // Arrow
                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.gray.opacity(0.5))
            }
            .padding(16)
            .background(Color.white)
            .cornerRadius(16)
            .shadow(color: .black.opacity(0.04), radius: 6, x: 0, y: 3)
        }
        .buttonStyle(.plain)
    }

    func categoryColor(_ category: TestCategory) -> Color {
        switch category {
        case .blood:
            return Color(red: 0.85, green: 0.25, blue: 0.25)
        case .radiology:
            return Color(red: 0.0, green: 0.48, blue: 0.78)
        case .urine:
            return Color(red: 0.85, green: 0.65, blue: 0.15)
        case .pharmacy:
            return Color(red: 0.38, green: 0.35, blue: 0.85)
        case .all:
            return Color(red: 0.15, green: 0.35, blue: 0.75)
        }
    }
}

#Preview {
    NavigationStack {
        PastTestsAndOrdersView()
    }
}
