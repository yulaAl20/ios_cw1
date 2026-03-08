//
//  AddCardView.swift
//  ios_cw1
//
//  Created by Yulani Alwis on 2026-03-08.
//

import SwiftUI

struct AddCardSheet: View {
    @Binding var isPresented: Bool
    var onCardAdded: (SavedCard, Bool) -> Void
    
    @StateObject private var viewModel = AddCardViewModel()
    @FocusState private var focusedField: CardField?
    
    enum CardField {
        case number, name, expiry, cvv
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color(.systemGroupedBackground)
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 24) {
                        cardPreview
                        cardDetailsForm
                        saveCardToggle
                        Spacer().frame(height: 80)
                    }
                    .padding(.top, 20)
                }
                
                VStack {
                    Spacer()
                    addCardButton
                }
            }
            .navigationTitle("Add Card")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        isPresented = false
                    }
                }
            }
        }
    }
    
    // Card Preview
    
    var cardPreview: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 16)
                .fill(
                    LinearGradient(
                        colors: [
                            Color(red: 0.1, green: 0.1, blue: 0.3),
                            Color(red: 0.2, green: 0.2, blue: 0.5)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(height: 200)
            
            VStack(alignment: .leading, spacing: 20) {
                HStack {
                    Text(viewModel.cardType)
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(.white)
                    Spacer()
                    Image(systemName: "wave.3.right")
                        .font(.system(size: 24))
                        .foregroundColor(.white.opacity(0.7))
                }
                
                Spacer()
                
                Text(viewModel.cardNumber.isEmpty ? "•••• •••• •••• ••••" : viewModel.formatCardNumber(viewModel.cardNumber))
                    .font(.system(size: 22, weight: .medium, design: .monospaced))
                    .foregroundColor(.white)
                
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("CARD HOLDER")
                            .font(.system(size: 10))
                            .foregroundColor(.white.opacity(0.6))
                        Text(viewModel.cardholderName.isEmpty ? "YOUR NAME" : viewModel.cardholderName.uppercased())
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(.white)
                    }
                    
                    Spacer()
                    
                    VStack(alignment: .trailing, spacing: 4) {
                        Text("EXPIRES")
                            .font(.system(size: 10))
                            .foregroundColor(.white.opacity(0.6))
                        Text(viewModel.expiryDate.isEmpty ? "MM/YY" : viewModel.expiryDate)
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(.white)
                    }
                }
            }
            .padding(24)
        }
        .padding(.horizontal, 20)
    }
    
    // Card Details Form
    
    var cardDetailsForm: some View {
        VStack(spacing: 0) {
            VStack(alignment: .leading, spacing: 8) {
                Text("Card Number")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.gray)
                
                HStack {
                    TextField("1234 5678 9012 3456", text: $viewModel.cardNumber)
                        .keyboardType(.numberPad)
                        .focused($focusedField, equals: .number)
                        .onChange(of: viewModel.cardNumber) { _, newValue in
                            viewModel.cardNumber = viewModel.formatCardNumberInput(newValue)
                        }
                    
                    if !viewModel.cardNumber.isEmpty {
                        Image(systemName: viewModel.cardTypeIcon)
                            .foregroundColor(.blue)
                    }
                }
                .padding()
                .background(Color.white)
                .cornerRadius(10)
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 16)
            
            VStack(alignment: .leading, spacing: 8) {
                Text("Cardholder Name")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.gray)
                
                TextField("John Doe", text: $viewModel.cardholderName)
                    .textContentType(.name)
                    .focused($focusedField, equals: .name)
                    .padding()
                    .background(Color.white)
                    .cornerRadius(10)
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 16)
            
            HStack(spacing: 16) {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Expiry Date")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.gray)
                    
                    TextField("MM/YY", text: $viewModel.expiryDate)
                        .keyboardType(.numberPad)
                        .focused($focusedField, equals: .expiry)
                        .onChange(of: viewModel.expiryDate) { _, newValue in
                            viewModel.expiryDate = viewModel.formatExpiryDate(newValue)
                        }
                        .padding()
                        .background(Color.white)
                        .cornerRadius(10)
                }
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("CVV")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.gray)
                    
                    HStack {
                        SecureField("123", text: $viewModel.cvv)
                            .keyboardType(.numberPad)
                            .focused($focusedField, equals: .cvv)
                            .onChange(of: viewModel.cvv) { _, newValue in
                                viewModel.cvv = viewModel.limitCVV(newValue)
                            }
                        
                        Image(systemName: "questionmark.circle")
                            .foregroundColor(.gray)
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(10)
                }
            }
            .padding(.horizontal, 20)
        }
    }
    
    //  Save Card Toggle
    
    var saveCardToggle: some View {
        HStack {
            Toggle(isOn: $viewModel.saveCard) {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Save card for future payments")
                        .font(.system(size: 15, weight: .medium))
                    Text("Your card details are encrypted and secure")
                        .font(.system(size: 12))
                        .foregroundColor(.gray)
                }
            }
            .tint(.blue)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
        .padding(.horizontal, 20)
    }
    
    //  Add Card Button
    
    var addCardButton: some View {
        Button(action: {
            viewModel.addCard { card, save in
                onCardAdded(card, save)
                isPresented = false
            }
        }) {
            HStack {
                if viewModel.isProcessing {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        .padding(.trailing, 8)
                }
                Text(viewModel.isProcessing ? "Adding Card..." : "Add Card")
                    .font(.system(size: 17, weight: .semibold))
            }
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background(viewModel.isFormValid ? Color.blue : Color.gray)
            .cornerRadius(30)
        }
        .disabled(!viewModel.isFormValid || viewModel.isProcessing)
        .padding(.horizontal, 20)
        .padding(.vertical, 16)
        .background(Color(.systemBackground))
    }
}
