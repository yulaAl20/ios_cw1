//
//  SelectLocationView.swift
//  ios_cw1
//
//  Created by Oshadha Samarasinghe on 2026-03-05.
//

import SwiftUI

struct SelectLocationView: View {
    
    @Environment(\.dismiss) var dismiss
    @Binding var selectedLocation: String
    let isStartLocation: Bool
    
    @State private var searchText: String = ""
    @State private var selectedFloorFilter: String = "Floor 1"
    @State private var selectedCategoryFilter: String = "All"
    @State private var showQRScanner: Bool = false
    
    var allLocations: [LocationItem] {
        var locations: [LocationItem] = []
        
        locations.append(contentsOf: [
            LocationItem(name: "Reception", floor: "Floor 1", category: "Services"),
            LocationItem(name: "Registration", floor: "Floor 1", category: "Services"),
            LocationItem(name: "Records", floor: "Floor 1", category: "Services"),
            LocationItem(name: "Waiting Area", floor: "Floor 1", category: "Services"),
            LocationItem(name: "Restroom", floor: "Floor 1", category: "Services"),
            LocationItem(name: "Emergency Dept", floor: "Floor 1", category: "Emergency"),
            LocationItem(name: "Nurse Stn", floor: "Floor 1", category: "Services"),
            LocationItem(name: "Elevator", floor: "Floor 1", category: "Services"),
            LocationItem(name: "Pharmacy", floor: "Floor 1", category: "Services"),
            LocationItem(name: "Billing", floor: "Floor 1", category: "Services")
        ])
        
        locations.append(contentsOf: [
            LocationItem(name: "Room 201", floor: "Floor 2", category: "Consultation"),
            LocationItem(name: "Room 202", floor: "Floor 2", category: "Consultation"),
            LocationItem(name: "Room 203", floor: "Floor 2", category: "Consultation"),
            LocationItem(name: "Vitals", floor: "Floor 2", category: "Services"),
            LocationItem(name: "Cardiology", floor: "Floor 2", category: "Consultation"),
            LocationItem(name: "Nurses' Stn", floor: "Floor 2", category: "Services"),
            LocationItem(name: "Pediatrics", floor: "Floor 2", category: "Consultation"),
            LocationItem(name: "Neurology", floor: "Floor 2", category: "Consultation"),
            LocationItem(name: "Waiting Area", floor: "Floor 2", category: "Services"),
            LocationItem(name: "Orthopedics", floor: "Floor 2", category: "Consultation"),
            LocationItem(name: "Elevator", floor: "Floor 2", category: "Services")
        ])
        
        locations.append(contentsOf: [
            LocationItem(name: "Main Lab", floor: "Floor 3", category: "Diagnostics"),
            LocationItem(name: "X-Ray", floor: "Floor 3", category: "Diagnostics"),
            LocationItem(name: "MRI Scan", floor: "Floor 3", category: "Diagnostics"),
            LocationItem(name: "Records", floor: "Floor 3", category: "Services"),
            LocationItem(name: "Blood Bank", floor: "Floor 3", category: "Diagnostics"),
            LocationItem(name: "Sample Room", floor: "Floor 3", category: "Diagnostics"),
            LocationItem(name: "CT Scan", floor: "Floor 3", category: "Diagnostics"),
            LocationItem(name: "Ultrasound", floor: "Floor 3", category: "Diagnostics"),
            LocationItem(name: "Pathology", floor: "Floor 3", category: "Diagnostics"),
            LocationItem(name: "Restroom", floor: "Floor 3", category: "Services"),
            LocationItem(name: "Cafeteria", floor: "Floor 3", category: "Services"),
            LocationItem(name: "Billing", floor: "Floor 3", category: "Services"),
            LocationItem(name: "Elevator", floor: "Floor 3", category: "Services")
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
        
        return filtered
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
                        
                        Button(action: {
                            showQRScanner = true
                        }) {
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
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 12)
                    .background(Color(.systemGray6).opacity(0.5))
                }
                
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
                
                HStack(spacing: 12) {
                    Menu {
                        Button("All") { selectedFloorFilter = "All" }
                        Button("Floor 1") { selectedFloorFilter = "Floor 1" }
                        Button("Floor 2") { selectedFloorFilter = "Floor 2" }
                        Button("Floor 3") { selectedFloorFilter = "Floor 3" }
                    } label: {
                        HStack(spacing: 6) {
                            Image(systemName: "building.2")
                                .font(.system(size: 14))
                            Text(selectedFloorFilter)
                                .font(.system(size: 14, weight: .medium))
                            Image(systemName: "chevron.down")
                                .font(.system(size: 10, weight: .semibold))
                        }
                        .foregroundColor(.primary)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 8)
                        .background(Color(.systemGray6))
                        .cornerRadius(8)
                    }
                    
                    Menu {
                        Button("All") { selectedCategoryFilter = "All" }
                        Button("Services") { selectedCategoryFilter = "Services" }
                        Button("Consultation") { selectedCategoryFilter = "Consultation" }
                        Button("Diagnostics") { selectedCategoryFilter = "Diagnostics" }
                        Button("Emergency") { selectedCategoryFilter = "Emergency" }
                    } label: {
                        HStack(spacing: 6) {
                            Image(systemName: "line.3.horizontal.decrease")
                                .font(.system(size: 14))
                            Text(selectedCategoryFilter)
                                .font(.system(size: 14, weight: .medium))
                            Image(systemName: "chevron.down")
                                .font(.system(size: 10, weight: .semibold))
                        }
                        .foregroundColor(.primary)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 8)
                        .background(Color(.systemGray6))
                        .cornerRadius(8)
                    }
                    
                    Spacer()
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 12)
                
                ScrollView {
                    VStack(spacing: 0) {
                        ForEach(filteredLocations) { location in
                            Button(action: {
                                selectedLocation = location.name
                                dismiss()
                            }) {
                                HStack(spacing: 12) {
                                    Image(systemName: "mappin.circle.fill")
                                        .font(.system(size: 24))
                                        .foregroundColor(.primary)
                                    
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text(location.name)
                                            .font(.system(size: 16, weight: .medium))
                                            .foregroundColor(.primary)
                                        Text(location.floor)
                                            .font(.system(size: 13))
                                            .foregroundColor(.secondary)
                                    }
                                    
                                    Spacer()
                                }
                                .padding(.horizontal, 20)
                                .padding(.vertical, 16)
                                .background(Color.white)
                            }
                            
                            Divider()
                                .padding(.leading, 56)
                        }
                    }
                }
                
                Spacer()
            }
            .navigationTitle(isStartLocation ? "Select Starting Location" : "Select Destination")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        dismiss()
                    }) {
                        Image(systemName: "arrow.left")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(.primary)
                    }
                }
            }
        }
        .sheet(isPresented: $showQRScanner) {
            NavigationQRscan(selectedLocation: $selectedLocation)
                .onDisappear {
                    if !selectedLocation.isEmpty {
                        dismiss()
                    }
                }
        }
    }
}

struct LocationItem: Identifiable {
    let id = UUID()
    let name: String
    let floor: String
    let category: String
}

#Preview {
    SelectLocationView(selectedLocation: .constant(""), isStartLocation: true)
}
