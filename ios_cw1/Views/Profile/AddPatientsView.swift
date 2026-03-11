//
//  AddPatientsView.swift
//  ios_cw1
//

import SwiftUI

struct AddPatientsView: View {
    @Environment(\.dismiss) var dismiss
    @State private var patients: [LinkedPatient] = []
    @State private var showAddSheet = false
    @State private var newName = ""
    @State private var newRelationship = "Family"
    @State private var newPhone = ""
    
    let relationships = ["Family", "Friend", "Spouse", "Parent", "Child", "Sibling", "Other"]
    
    var body: some View {
        VStack(spacing: 0) {
            // Top bar
            HStack {
                Button(action: { dismiss() }) {
                    Image(systemName: "chevron.left")
                        .font(.title2)
                        .foregroundColor(.primary)
                }
                Spacer()
                Text("Add Patients")
                    .font(.headline)
                    .fontWeight(.semibold)
                Spacer()
                Button(action: { showAddSheet = true }) {
                    Image(systemName: "plus.circle.fill")
                        .font(.title2)
                        .foregroundColor(.blue)
                }
            }
            .padding(.horizontal, 24)
            .padding(.top, 16)
            .padding(.bottom, 8)
            
            if patients.isEmpty {
                VStack(spacing: 20) {
                    Spacer()
                    
                    Image(systemName: "person.2.circle")
                        .font(.system(size: 64))
                        .foregroundColor(.blue.opacity(0.5))
                    
                    Text("No Patients Added")
                        .font(.title3.bold())
                    
                    Text("Add family members or friends\nto book appointments on their behalf.")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 40)
                    
                    Button(action: { showAddSheet = true }) {
                        Text("Add Patient")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding(.horizontal, 32)
                            .padding(.vertical, 14)
                            .background(Color.blue)
                            .cornerRadius(25)
                    }
                    .padding(.top, 8)
                    
                    Spacer()
                }
            } else {
                ScrollView {
                    VStack(spacing: 12) {
                        ForEach(patients) { patient in
                            HStack(spacing: 14) {
                                ZStack {
                                    Circle()
                                        .fill(Color.blue.opacity(0.12))
                                        .frame(width: 48, height: 48)
                                    Text(String(patient.name.prefix(1)).uppercased())
                                        .font(.headline)
                                        .foregroundColor(.blue)
                                }
                                
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(patient.name)
                                        .font(.body.weight(.medium))
                                    Text(patient.relationship)
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                }
                                
                                Spacer()
                                
                                if !patient.phone.isEmpty {
                                    Text(patient.phone)
                                        .font(.caption)
                                        .foregroundColor(.gray)
                                }
                            }
                            .padding()
                            .background(Color(.systemGray6))
                            .cornerRadius(14)
                        }
                    }
                    .padding(.horizontal, 24)
                    .padding(.top, 16)
                }
            }
        }
        .navigationBarHidden(true)
        .sheet(isPresented: $showAddSheet) {
            NavigationStack {
                Form {
                    Section("Patient Details") {
                        TextField("Full Name", text: $newName)
                        
                        Picker("Relationship", selection: $newRelationship) {
                            ForEach(relationships, id: \.self) { rel in
                                Text(rel).tag(rel)
                            }
                        }
                        
                        TextField("Phone Number (optional)", text: $newPhone)
                            .keyboardType(.phonePad)
                    }
                }
                .navigationTitle("New Patient")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .cancellationAction) {
                        Button("Cancel") {
                            resetForm()
                            showAddSheet = false
                        }
                    }
                    ToolbarItem(placement: .confirmationAction) {
                        Button("Add") {
                            let patient = LinkedPatient(
                                name: newName,
                                relationship: newRelationship,
                                phone: newPhone
                            )
                            patients.append(patient)
                            resetForm()
                            showAddSheet = false
                        }
                        .disabled(newName.trimmingCharacters(in: .whitespaces).isEmpty)
                    }
                }
            }
            .presentationDetents([.medium])
        }
    }
    
    private func resetForm() {
        newName = ""
        newRelationship = "Family"
        newPhone = ""
    }
}

struct LinkedPatient: Identifiable {
    let id = UUID()
    let name: String
    let relationship: String
    let phone: String
}

#Preview {
    NavigationStack {
        AddPatientsView()
    }
}
