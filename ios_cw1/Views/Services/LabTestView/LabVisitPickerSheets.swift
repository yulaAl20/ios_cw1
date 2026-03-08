//
//  LabVisitPickerSheets.swift
//  ios_cw1
//
//  Created by Yulani Alwis on 2026-03-08.
//

import SwiftUI

// Location Picker Sheet

struct LocationPickerSheet: View {
    let locations: [LabLocation]
    @Binding var selectedLocation: LabLocation
    @Binding var isPresented: Bool
    
    var body: some View {
        NavigationStack {
            List(locations) { location in
                Button(action: {
                    selectedLocation = location
                    isPresented = false
                }) {
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(location.name)
                                .font(.system(size: 16, weight: .medium))
                                .foregroundColor(.black)
                            
                            Text(location.address)
                                .font(.system(size: 14))
                                .foregroundColor(.gray)
                        }
                        
                        Spacer()
                        
                        if selectedLocation.name == location.name {
                            Image(systemName: "checkmark")
                                .foregroundColor(.blue)
                        }
                    }
                    .padding(.vertical, 4)
                }
            }
            .navigationTitle("Select Lab Location")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        isPresented = false
                    }
                }
            }
        }
    }
}


// Date Picker Sheet

struct DatePickerSheet: View {
    @Binding var selectedDate: Date
    @Binding var isPresented: Bool
    
    var body: some View {
        NavigationStack {
            VStack {
                DatePicker(
                    "Select Date",
                    selection: $selectedDate,
                    in: Date()...,
                    displayedComponents: .date
                )
                .datePickerStyle(.graphical)
                .padding()
                
                Spacer()
            }
            .navigationTitle("Select Date")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        isPresented = false
                    }
                }
            }
        }
    }
}


// Time Picker Sheet

struct TimePickerSheet: View {
    let timeSlots: [TimeSlot]
    @Binding var selectedTimeSlot: TimeSlot
    @Binding var isPresented: Bool
    
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVGrid(columns: columns, spacing: 12) {
                    ForEach(timeSlots) { slot in
                        Button(action: {
                            selectedTimeSlot = slot
                            isPresented = false
                        }) {
                            Text(slot.displayText)
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(selectedTimeSlot.id == slot.id ? .white : .blue)
                                .padding(.horizontal, 12)
                                .padding(.vertical, 14)
                                .frame(maxWidth: .infinity)
                                .background(
                                    selectedTimeSlot.id == slot.id ?
                                    Color.blue :
                                    Color.blue.opacity(0.1)
                                )
                                .cornerRadius(10)
                        }
                    }
                }
                .padding()
            }
            .navigationTitle("Select Time Slot")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        isPresented = false
                    }
                }
            }
        }
    }
}


//  Patient Picker Sheet

struct PatientPickerSheet: View {
    let patients: [String]
    @Binding var selectedPatient: String
    @Binding var isPresented: Bool
    
    var body: some View {
        NavigationStack {
            List(patients, id: \.self) { patient in
                Button(action: {
                    if patient != "+ Add Family Member" {
                        selectedPatient = patient
                    }
                    isPresented = false
                }) {
                    HStack {
                        Text(patient)
                            .font(.system(size: 16))
                            .foregroundColor(patient == "+ Add Family Member" ? .blue : .black)
                        
                        Spacer()
                        
                        if selectedPatient == patient {
                            Image(systemName: "checkmark")
                                .foregroundColor(.blue)
                        }
                    }
                }
            }
            .navigationTitle("Select Patient")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        isPresented = false
                    }
                }
            }
        }
    }
}
