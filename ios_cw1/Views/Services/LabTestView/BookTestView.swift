//
//  Untitled.swift
//  ios_cw1
//
//  Created by Yulani Alwis on 2026-03-07.
//


import SwiftUI

struct BookTestView: View {
    
    @StateObject private var viewModel: LabTestViewModel
    @Environment(\.dismiss) var dismiss
    @State private var showLabVisitDetails = false
    
    init(initialCategory: TestCategory = .all) {
        let vm = LabTestViewModel()
        vm.selectedCategory = initialCategory
        self._viewModel = StateObject(wrappedValue: vm)
    }
    
    var body: some View {
        
        VStack {
            
            // HEADER
            ZStack {
                
                Text("Book a Test")
                    .font(.system(size: 20, weight: .semibold))
                  //  .padding(.top)
            }
            .padding(.horizontal)
            
            
            // SEARCH BAR
            HStack {
                
                Image(systemName: "magnifyingglass")
                
                TextField(
                    "Search name, specialty...",
                    text: $viewModel.searchText
                )
            }
            .padding(10)
            .background(Color(.systemGray6))
            .cornerRadius(20)
            .padding()
            
            
            // CATEGORY FILTER
            ScrollView(.horizontal, showsIndicators: false) {
                
                HStack(spacing: 12) {
                    
                    ForEach(TestCategory.allCases) { category in
                        
                        Button {
                            viewModel.selectedCategory = category
                        } label: {
                            
                            Text(category.rawValue)
                                .font(.system(size: 14))
                                .padding(.horizontal, 16)
                                .padding(.vertical, 8)
                                .background(
                                    viewModel.selectedCategory == category ?
                                    Color.blue :
                                    Color(.systemGray5)
                                )
                                .foregroundColor(
                                    viewModel.selectedCategory == category ?
                                    .white : .black
                                )
                                .clipShape(Capsule())
                        }
                    }
                }
                .padding(.horizontal)
            }
            
            
            // TEST LIST
            ScrollView {
                
                VStack(alignment: .leading, spacing: 16) {
                    
                    Text("Popular Tests")
                        .font(.system(size: 20, weight: .bold))
                        .padding(.horizontal)
                    
                    
                    // EMPTY STATE
                    if viewModel.filteredTests.isEmpty {
                        
                        VStack(spacing: 12) {
                            
                            Image(systemName: "magnifyingglass")
                                .font(.system(size: 40))
                                .foregroundColor(.gray.opacity(0.6))
                            
                            Text("No tests found")
                                .font(.system(size: 18, weight: .semibold))
                            
                            Text("Try another keyword or filter")
                                .font(.system(size: 14))
                                .foregroundColor(.gray)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.top, 10)
                    }
                    
                    
                    // TEST RESULTS
                    else {
                        
                        ForEach(viewModel.filteredTests) { test in
                            
                            HStack {
                                
                                VStack(alignment: .leading, spacing: 6) {
                                    
                                    Text(test.name)
                                        .font(.system(size: 16, weight: .semibold))
                                    
                                    Text(test.description)
                                        .font(.system(size: 12))
                                        .foregroundColor(.gray)
                                    
                                    Text("LKR \(String(format: "%.2f", test.price))")
                                        .font(.system(size: 14, weight: .medium))
                                }
                                
                                Spacer()
                                
                                Button {
                                    viewModel.toggleTest(test)
                                } label: {
                                    
                                    Text(viewModel.isSelected(test) ? "ADDED" : "ADD")
                                        .font(.system(size: 12, weight: .semibold))
                                        .padding(.horizontal, 14)
                                        .padding(.vertical, 6)
                                        .background(
                                            viewModel.isSelected(test) ?
                                            Color.blue :
                                            Color.blue.opacity(0.2)
                                        )
                                        .foregroundColor(
                                            viewModel.isSelected(test) ?
                                            .white : .blue
                                        )
                                        .cornerRadius(12)
                                }
                            }
                            .padding()
                            .background(Color.white)
                            .cornerRadius(12)
                            .shadow(color: .black.opacity(0.05), radius: 4)
                            .padding(.horizontal)
                        }
                    }
                }
                .padding(.top)
            }
            
            Spacer()
        }
        .background(Color(.systemGroupedBackground))
        
        
        // BOTTOM CHECKOUT BAR
        .safeAreaInset(edge: .bottom) {
            
            if viewModel.totalPrice > 0 {
                
                HStack {
                    
                    Text("LKR \(String(format: "%.2f", viewModel.totalPrice))")
                        .font(.system(size: 18, weight: .bold))
                    
                    Spacer()
                    
                    NavigationLink(destination: LabVisitDetailsView(
                        selectedTests: viewModel.selectedTests,
                        totalPrice: viewModel.totalPrice
                    )) {
                        Text("Continue")
                            .font(.system(size: 16, weight: .semibold))
                            .padding(.horizontal, 40)
                            .padding(.vertical, 14)
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(30)
                    }
                }
                .padding()
                .background(.ultraThinMaterial)
            }
        }
    }
}

#Preview {
    BookTestView()
}
