//
//  SelectLocationView.swift
//  ios_cw1
//
//  Created by Oshadha Samarasinghe on 2026-03-05.
//

import SwiftUI

struct SelectLocationView: View {

    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var accessibilityVM: AccessibilityViewModel
    @Binding var selectedLocation: String
    let isStartLocation: Bool

    @State private var searchText:               String = ""
    @State private var selectedFloorFilter:      String = "Floor 1"
    @State private var selectedCategoryFilter:   String = "All"
    @State private var showQRScanner:            Bool   = false
    @State private var showWheelchairAccessOnly: Bool   = false

    // Locations that are step-free (ground floor or reachable via elevator without needing stairs)
    private let wheelchairAccessibleNames: Set<String> = [
        "Reception", "Registration", "Records", "Waiting Area", "Restroom",
        "Emergency Dept", "Nurse Stn", "Elevator", "Pharmacy", "Billing"
    ]

    var allLocations: [LocationItem] {
        var locations: [LocationItem] = []
        locations.append(contentsOf: [
            LocationItem(name: "Reception",      floor: "Floor 1", category: "Services"),
            LocationItem(name: "Registration",   floor: "Floor 1", category: "Services"),
            LocationItem(name: "Records",        floor: "Floor 1", category: "Services"),
            LocationItem(name: "Waiting Area",   floor: "Floor 1", category: "Services"),
            LocationItem(name: "Restroom",       floor: "Floor 1", category: "Services"),
            LocationItem(name: "Emergency Dept", floor: "Floor 1", category: "Emergency"),
            LocationItem(name: "Nurse Stn",      floor: "Floor 1", category: "Services"),
            LocationItem(name: "Elevator",       floor: "Floor 1", category: "Services"),
            LocationItem(name: "Pharmacy",       floor: "Floor 1", category: "Services"),
            LocationItem(name: "Billing",        floor: "Floor 1", category: "Services")
        ])
        locations.append(contentsOf: [
            LocationItem(name: "Room 201",    floor: "Floor 2", category: "Consultation"),
            LocationItem(name: "Room 202",    floor: "Floor 2", category: "Consultation"),
            LocationItem(name: "Room 203",    floor: "Floor 2", category: "Consultation"),
            LocationItem(name: "Vitals",      floor: "Floor 2", category: "Services"),
            LocationItem(name: "Cardiology",  floor: "Floor 2", category: "Consultation"),
            LocationItem(name: "Nurses' Stn", floor: "Floor 2", category: "Services"),
            LocationItem(name: "Pediatrics",  floor: "Floor 2", category: "Consultation"),
            LocationItem(name: "Neurology",   floor: "Floor 2", category: "Consultation"),
            LocationItem(name: "Waiting Area",floor: "Floor 2", category: "Services"),
            LocationItem(name: "Orthopedics", floor: "Floor 2", category: "Consultation"),
            LocationItem(name: "Elevator",    floor: "Floor 2", category: "Services")
        ])
        locations.append(contentsOf: [
            LocationItem(name: "Main Lab",    floor: "Floor 3", category: "Diagnostics"),
            LocationItem(name: "X-Ray",       floor: "Floor 3", category: "Diagnostics"),
            LocationItem(name: "MRI Scan",    floor: "Floor 3", category: "Diagnostics"),
            LocationItem(name: "Records",     floor: "Floor 3", category: "Services"),
            LocationItem(name: "Blood Bank",  floor: "Floor 3", category: "Diagnostics"),
            LocationItem(name: "Sample Room", floor: "Floor 3", category: "Diagnostics"),
            LocationItem(name: "CT Scan",     floor: "Floor 3", category: "Diagnostics"),
            LocationItem(name: "Ultrasound",  floor: "Floor 3", category: "Diagnostics"),
            LocationItem(name: "Pathology",   floor: "Floor 3", category: "Diagnostics"),
            LocationItem(name: "Restroom",    floor: "Floor 3", category: "Services"),
            LocationItem(name: "Cafeteria",   floor: "Floor 3", category: "Services"),
            LocationItem(name: "Billing",     floor: "Floor 3", category: "Services"),
            LocationItem(name: "Elevator",    floor: "Floor 3", category: "Services")
        ])
        return locations
    }

    var filteredLocations: [LocationItem] {
        var filtered = allLocations

        if selectedFloorFilter != "All" {
            filtered = filtered.filter { $0.floor == selectedFloorFilter }
        }
        if selectedCategoryFilter != "All" {
            filtered = filtered.filter { $0.category == selectedCategoryFilter }
        }
        if !searchText.isEmpty {
            filtered = filtered.filter { $0.name.lowercased().contains(searchText.lowercased()) }
        }
        if showWheelchairAccessOnly {
            filtered = filtered.filter { isWheelchairAccessible($0) }
        }
        return filtered
    }

    private func isWheelchairAccessible(_ location: LocationItem) -> Bool {
        location.floor == "Floor 1" ||
        wheelchairAccessibleNames.contains(location.name)
    }

    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                if isStartLocation {
                    HStack(spacing: 12) {
                        HStack(spacing: 8) {
                            Image(systemName: "location.circle")
                                .font(.system(size: 20))
                                .foregroundColor(.blue)
                            Text("Verify Location")
                                .font(.system(size: 15, weight: .medium))
                                .foregroundColor(.primary)
                        }
                        Spacer()
                        Button(action: { showQRScanner = true }) {
                            HStack(spacing: 6) {
                                Image(systemName: "qrcode.viewfinder")
                                    .font(.system(size: 14, weight: .semibold))
                                Text("Scan QR")
                                    .font(.system(size: 14, weight: .semibold))
                            }
                            .foregroundColor(.white)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 10)
                            .background(Color.blue)
                            .cornerRadius(10)
                        }
                        .accessibilityLabel("Scan QR code to verify location")
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 12)
                    .background(Color(.systemGray6).opacity(0.5))
                }

                // Search bar
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.secondary)
                        .font(.system(size: 16))
                    TextField("Search name, specialty...", text: $searchText)
                        .font(.system(size: 15))
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .background(Color(.systemGray6))
                .cornerRadius(25)
                .padding(.horizontal, 20)
                .padding(.vertical, 16)
                .accessibilityLabel("Search locations")

                // Filters row
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 10) {
                        // Floor filter
                        Menu {
                            Button("All")     { selectedFloorFilter = "All" }
                            Button("Floor 1") { selectedFloorFilter = "Floor 1" }
                            Button("Floor 2") { selectedFloorFilter = "Floor 2" }
                            Button("Floor 3") { selectedFloorFilter = "Floor 3" }
                        } label: {
                            filterChip(
                                icon: "building.2",
                                label: selectedFloorFilter,
                                isActive: selectedFloorFilter != "All"
                            )
                        }
                        .accessibilityLabel("Floor filter: \(selectedFloorFilter)")

                        // Category filter
                        Menu {
                            Button("All")            { selectedCategoryFilter = "All" }
                            Button("Services")       { selectedCategoryFilter = "Services" }
                            Button("Consultation")   { selectedCategoryFilter = "Consultation" }
                            Button("Diagnostics")    { selectedCategoryFilter = "Diagnostics" }
                            Button("Emergency")      { selectedCategoryFilter = "Emergency" }
                        } label: {
                            filterChip(
                                icon: "line.3.horizontal.decrease",
                                label: selectedCategoryFilter,
                                isActive: selectedCategoryFilter != "All"
                            )
                        }
                        .accessibilityLabel("Category filter: \(selectedCategoryFilter)")

                        // Wheelchair accessible filter
                        Button(action: {
                            withAnimation(.easeInOut(duration: 0.2)) {
                                showWheelchairAccessOnly.toggle()
                            }
                        }) {
                            filterChip(
                                icon: "figure.roll",
                                label: "Accessible",
                                isActive: showWheelchairAccessOnly
                            )
                        }
                        .accessibilityLabel("Wheelchair accessible only")
                        .accessibilityValue(showWheelchairAccessOnly ? "On" : "Off")
                        .accessibilityHint("Filters to show only step-free, wheelchair accessible locations")
                    }
                    .padding(.horizontal, 20)
                }
                .padding(.bottom, 12)

                // Location list
                ScrollView {
                    VStack(spacing: 0) {
                        ForEach(filteredLocations) { location in
                            let accessible = isWheelchairAccessible(location)

                            Button(action: {
                                selectedLocation = location.name
                                dismiss()
                            }) {
                                HStack(spacing: 12) {
                                    Image(systemName: "mappin.circle.fill")
                                        .font(.system(size: 24))
                                        .foregroundColor(.primary)
                                        .accessibilityHidden(true)

                                    VStack(alignment: .leading, spacing: 4) {
                                        Text(location.name)
                                            .font(.system(size: 16, weight: .medium))
                                            .foregroundColor(.primary)
                                        Text(location.floor)
                                            .font(.system(size: 13))
                                            .foregroundColor(.secondary)
                                    }

                                    Spacer()

                                    // Wheelchair accessible badge
                                    if accessible {
                                        Image(systemName: "figure.roll")
                                            .font(.system(size: 14))
                                            .foregroundColor(.blue)
                                            .padding(6)
                                            .background(Color.blue.opacity(0.1))
                                            .clipShape(Circle())
                                            .accessibilityHidden(true)
                                    }
                                }
                                .padding(.horizontal, 20)
                                .padding(.vertical, 16)
                                .frame(minHeight: accessibilityVM.minimumTapTarget)
                                .background(Color.white)
                            }
                            .accessibilityLabel(
                                "\(location.name), \(location.floor)" +
                                (accessible ? ", wheelchair accessible" : "")
                            )
                            .accessibilityHint("Double-tap to select this location")

                            Divider()
                                .padding(.leading, 56)
                        }

                        if filteredLocations.isEmpty {
                            VStack(spacing: 10) {
                                Image(systemName: showWheelchairAccessOnly ? "figure.roll" : "magnifyingglass")
                                    .font(.system(size: 32))
                                    .foregroundColor(.gray.opacity(0.5))
                                Text(showWheelchairAccessOnly
                                        ? "No wheelchair accessible locations match your search."
                                        : "No locations found.")
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                                    .multilineTextAlignment(.center)
                                    .padding(.horizontal, 40)
                            }
                            .padding(.top, 60)
                        }
                    }
                }

                Spacer()
            }
            .navigationTitle(isStartLocation ? "Select Starting Location" : "Select Destination")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: { dismiss() }) {
                        Image(systemName: "arrow.left")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(.primary)
                    }
                    .accessibilityLabel("Back")
                }
            }
        }
        .sheet(isPresented: $showQRScanner) {
            NavigationQRscan(selectedLocation: $selectedLocation)
                .onDisappear {
                    if !selectedLocation.isEmpty { dismiss() }
                }
        }
        .onAppear {
            if accessibilityVM.isWheelchairModeEnabled {
                showWheelchairAccessOnly = true
            }
        }
    }

    private func filterChip(icon: String, label: String, isActive: Bool) -> some View {
        HStack(spacing: 6) {
            Image(systemName: icon)
                .font(.system(size: 14))
            Text(label)
                .font(.system(size: 14, weight: .medium))
            if !isActive {
                Image(systemName: "chevron.down")
                    .font(.system(size: 10, weight: .semibold))
            }
        }
        .foregroundColor(isActive ? .white : .primary)
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background(isActive ? Color.blue : Color(.systemGray6))
        .cornerRadius(8)
    }
}

struct LocationItem: Identifiable {
    let id    = UUID()
    let name:     String
    let floor:    String
    let category: String
}

#Preview {
    SelectLocationView(selectedLocation: .constant(""), isStartLocation: true)
        .environmentObject(AccessibilityViewModel())
}
