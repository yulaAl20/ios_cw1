//
//  HomeSearchView.swift
//  ios_cw1
//

import SwiftUI

struct HomeSearchView: View {

    @EnvironmentObject var router: AppRouter

    @Environment(\.dismiss) private var dismiss

    @State private var query: String = ""

    private var candidates: [SmartSearch.Result] {
        [
            .init(title: "Find Doctor", subtitle: "Book an appointment", score: 0, payload: .findDoctor),
            .init(title: "Lab Reports", subtitle: "Past tests & lab reports", score: 0, payload: .labReports),
            .init(title: "Scans", subtitle: "Imaging reports (MRI, X-Ray)", score: 0, payload: .scans),
            .init(title: "Pharmacy", subtitle: "Medicines & prescriptions", score: 0, payload: .pharmacy),
            .init(title: "Indoor Navigation", subtitle: "Find directions inside the clinic", score: 0, payload: .indoorNavigation),
            .init(title: "Services", subtitle: "Browse clinic services", score: 0, payload: .services),
            .init(title: "Appointments", subtitle: "Upcoming and past appointments", score: 0, payload: .appointments)
        ]
    }

    private var results: [SmartSearch.Result] {
        SmartSearch.search(query: query, in: candidates)
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {

                // Search field row
                HStack(spacing: 10) {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.secondary)

                    TextField("Search doctors, reports, scans...", text: $query)
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled()

                    if !query.isEmpty {
                        Button {
                            query = ""
                        } label: {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundColor(.secondary)
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .background(Color(.systemGray6))
                .cornerRadius(14)
                .padding(.horizontal, 20)
                .padding(.top, 16)

                // Results
                List {
                    if query.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                        Section {
                            Text("Type to search. Matches letters and words.")
                                .foregroundColor(.secondary)
                        }
                    } else if results.isEmpty {
                        Section {
                            Text("No results")
                                .foregroundColor(.secondary)
                        }
                    } else {
                        Section("Results") {
                            ForEach(results.prefix(20)) { item in
                                Button {
                                    handleSelection(item)
                                } label: {
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text(item.title)
                                            .font(.system(size: 16, weight: .semibold))
                                            .foregroundColor(.primary)

                                        if let subtitle = item.subtitle {
                                            Text(subtitle)
                                                .font(.system(size: 13))
                                                .foregroundColor(.secondary)
                                        }
                                    }
                                    .padding(.vertical, 4)
                                }
                            }
                        }
                    }
                }
                .listStyle(.insetGrouped)
            }
            .navigationTitle("Search")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Close") { dismiss() }
                }
            }
        }
    }

    private func handleSelection(_ item: SmartSearch.Result) {
        switch item.payload {
        case .findDoctor:
            // Switch to appointments tab and let user book
            router.currentTab = 0
        case .labReports:
            router.currentTab = 1
        case .scans:
            router.currentTab = 1
        case .pharmacy:
            router.currentTab = 1
        case .indoorNavigation:
            router.currentTab = 3
        case .services:
            router.currentTab = 1
        case .appointments:
            router.currentTab = 2
        }
        dismiss()
    }
}

#Preview {
    HomeSearchView()
        .environmentObject(AppRouter())
}
