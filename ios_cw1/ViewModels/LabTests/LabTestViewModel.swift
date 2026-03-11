//
//  Untitled.swift
//  ios_cw1
//
//  Created by Yulani Alwis on 2026-03-07.
//

import Foundation
import SwiftUI
import Combine

class LabTestViewModel: ObservableObject {
    
    //  Filters
    @Published var selectedCategory: TestCategory = .all
    @Published var searchText: String = ""
    
    //  Selected Tests
    @Published var selectedTests: [LabTest] = []
    
    //  All Tests
    @Published var tests: [LabTest] = [
        
        // BLOOD TESTS
        LabTest(name: "Lipid Profile", description: "Cholesterol, HDL, LDL", price: 2000, category: .blood),
        LabTest(name: "Thyroid Function Test", description: "T3, T4, TSH levels", price: 2200, category: .blood),
        LabTest(name: "Complete Blood Count", description: "RBC, WBC, Platelets", price: 1500, category: .blood),
        LabTest(name: "Blood Glucose Test", description: "Fasting sugar level", price: 800, category: .blood),
        LabTest(name: "Liver Function Test", description: "ALT, AST, Bilirubin", price: 2500, category: .blood),
        LabTest(name: "Kidney Function Test", description: "Creatinine, Urea", price: 2300, category: .blood),
        LabTest(name: "Vitamin D Test", description: "Vitamin D deficiency check", price: 3200, category: .blood),
        LabTest(name: "Vitamin B12 Test", description: "Vitamin B12 levels", price: 2800, category: .blood),
        
        // URINE TESTS
        LabTest(name: "Urine Routine Test", description: "Urine analysis", price: 900, category: .urine),
        LabTest(name: "Urine Culture Test", description: "Detect urinary infection", price: 1200, category: .urine),
        LabTest(name: "Protein Urine Test", description: "Protein levels in urine", price: 1000, category: .urine),
        LabTest(name: "Urine Pregnancy Test", description: "hCG hormone detection", price: 700, category: .urine),
        
        // RADIOLOGY
        LabTest(name: "Chest X-Ray", description: "Radiology chest scan", price: 3500, category: .radiology),
        LabTest(name: "MRI Scan", description: "Magnetic resonance imaging", price: 18000, category: .radiology),
        LabTest(name: "CT Scan", description: "Computed tomography scan", price: 15000, category: .radiology),
        LabTest(name: "Ultrasound Scan", description: "Internal organ imaging", price: 5000, category: .radiology)
    ]
    
    
    // Filtered Tests
    var filteredTests: [LabTest] {
        
        tests.filter { test in
            
            let matchesCategory =
                selectedCategory == .all ||
                test.category == selectedCategory
            
            if searchText.isEmpty {
                return matchesCategory
            }
            
            let query = searchText.lowercased()
            
            let matchesSearch =
                test.name.lowercased().contains(query) ||
                test.description.lowercased().contains(query) ||
                test.category.rawValue.lowercased().contains(query)
            
            return matchesCategory && matchesSearch
        }
    }
    
    
    //  Selection Logic
    
    func toggleTest(_ test: LabTest) {
        
        if selectedTests.contains(where: { $0.id == test.id }) {
            selectedTests.removeAll { $0.id == test.id }
        } else {
            selectedTests.append(test)
        }
    }
    
    
    func isSelected(_ test: LabTest) -> Bool {
        selectedTests.contains(where: { $0.id == test.id })
    }
    
    
    //  Total Price
    
    var totalPrice: Double {
        selectedTests.reduce(0) { $0 + $1.price }
    }
    
    
    //  Formatted Total
    
    var formattedTotalPrice: String {
        "LKR \(String(format: "%.2f", totalPrice))"
    }
}
