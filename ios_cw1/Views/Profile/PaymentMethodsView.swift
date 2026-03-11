//
//  PaymentMethodsView.swift
//  ios_cw1
//
//  Created by COBSCCOMP242P-74 on 2026-03-11.
//

import SwiftUI

struct PaymentMethodsView: View {

    @StateObject private var viewModel = PaymentMethodsViewModel()
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        VStack(spacing: 0) {
            headerSection

            if viewModel.cards.isEmpty {
                emptyStateView
            } else {
                cardListView
            }
        }
        .background(Color(.systemGroupedBackground).ignoresSafeArea())
        .navigationBarHidden(true)
        .sheet(isPresented: $viewModel.showAddCardSheet) {
            AddCardSheet(
                isPresented: $viewModel.showAddCardSheet,
                onCardAdded: { card, _ in
                    viewModel.addNewCard(card)
                }
            )
            .presentationDetents([.large])
        }
        .sheet(isPresented: $viewModel.showEditSheet) {
            if let card = viewModel.cardToEdit {
                EditCardSheet(
                    card: card,
                    isPresented: $viewModel.showEditSheet,
                    onSave: { updated in
                        viewModel.saveEdit(updatedCard: updated)
                    }
                )
                .presentationDetents([.medium])
            }
        }
    }

    // MARK: - Header

    private var headerSection: some View {
        HStack {
            Button(action: { dismiss() }) {
                Image(systemName: "chevron.left")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(.black)
            }
            Spacer()
            Text("Payment Methods")
                .font(.system(size: 18, weight: .semibold))
            Spacer()
            Button(action: { viewModel.showAddCardSheet = true }) {
                Image(systemName: "plus")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(Color(red: 0.15, green: 0.35, blue: 0.75))
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 14)
        .background(Color.white)
    }

    // MARK: - Empty State

    private var emptyStateView: some View {
        VStack(spacing: 20) {
            Spacer()
            ZStack {
                Circle()
                    .fill(Color.blue.opacity(0.08))
                    .frame(width: 90, height: 90)
                Image(systemName: "creditcard")
                    .font(.system(size: 36))
                    .foregroundColor(Color(red: 0.15, green: 0.35, blue: 0.75))
            }
            Text("No Saved Cards")
                .font(.system(size: 20, weight: .semibold))
            Text("Add a card to speed up payments\nacross appointments, tests and pharmacy orders.")
                .font(.system(size: 14))
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
            Button(action: { viewModel.showAddCardSheet = true }) {
                HStack(spacing: 8) {
                    Image(systemName: "plus.circle.fill")
                    Text("Add a Card")
                        .font(.system(size: 15, weight: .semibold))
                }
                .foregroundColor(.white)
                .padding(.horizontal, 32)
                .padding(.vertical, 14)
                .background(Color(red: 0.15, green: 0.35, blue: 0.75))
                .cornerRadius(14)
            }
            Spacer()
        }
        .padding(.horizontal, 24)
    }

    // MARK: - Card List

    private var cardListView: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 12) {
                ForEach(viewModel.cards) { card in
                    SavedCardRow(
                        card: card,
                        onEdit:   { viewModel.beginEdit(card)   },
                        onDelete: { viewModel.deleteCard(card)  }
                    )
                }
                addCardButton
            }
            .padding(.horizontal, 20)
            .padding(.top, 16)
            .padding(.bottom, 40)
        }
    }

    private var addCardButton: some View {
        Button(action: { viewModel.showAddCardSheet = true }) {
            HStack(spacing: 10) {
                Image(systemName: "plus.circle.fill")
                    .font(.system(size: 20))
                    .foregroundColor(Color(red: 0.15, green: 0.35, blue: 0.75))
                Text("Add New Card")
                    .font(.system(size: 15, weight: .medium))
                    .foregroundColor(Color(red: 0.15, green: 0.35, blue: 0.75))
                Spacer()
            }
            .padding(16)
            .background(Color.white)
            .cornerRadius(14)
        }
    }
}


// MARK: - Saved Card Row

struct SavedCardRow: View {
    let card: SavedCard
    let onEdit:   () -> Void
    let onDelete: () -> Void

    @State private var showDeleteAlert = false

    var cardGradient: LinearGradient {
        let colors: [Color]
        switch card.cardType {
        case "Visa":
            colors = [Color(red: 0.10, green: 0.22, blue: 0.60), Color(red: 0.20, green: 0.40, blue: 0.82)]
        case "Mastercard":
            colors = [Color(red: 0.65, green: 0.08, blue: 0.08), Color(red: 0.90, green: 0.28, blue: 0.10)]
        case "Amex":
            colors = [Color(red: 0.05, green: 0.45, blue: 0.35), Color(red: 0.10, green: 0.65, blue: 0.50)]
        default:
            colors = [Color(red: 0.25, green: 0.25, blue: 0.30), Color(red: 0.40, green: 0.40, blue: 0.45)]
        }
        return LinearGradient(colors: colors, startPoint: .topLeading, endPoint: .bottomTrailing)
    }

    var body: some View {
        VStack(spacing: 0) {
            ZStack {
                RoundedRectangle(cornerRadius: 16)
                    .fill(cardGradient)
                    .frame(height: 130)

                VStack(alignment: .leading, spacing: 12) {
                    HStack {
                        Text(card.cardType)
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(.white)
                        Spacer()
                        Image(systemName: "wave.3.right")
                            .font(.system(size: 18))
                            .foregroundColor(.white.opacity(0.7))
                    }
                    Spacer()
                    Text("•••• •••• •••• \(card.lastFourDigits)")
                        .font(.system(size: 18, weight: .medium, design: .monospaced))
                        .foregroundColor(.white)
                    HStack {
                        VStack(alignment: .leading, spacing: 2) {
                            Text("CARD HOLDER")
                                .font(.system(size: 9))
                                .foregroundColor(.white.opacity(0.6))
                            Text(card.cardholderName.isEmpty ? "—" : card.cardholderName.uppercased())
                                .font(.system(size: 13, weight: .medium))
                                .foregroundColor(.white)
                                .lineLimit(1)
                        }
                        Spacer()
                        VStack(alignment: .trailing, spacing: 2) {
                            Text("EXPIRES")
                                .font(.system(size: 9))
                                .foregroundColor(.white.opacity(0.6))
                            Text(card.expiryDate)
                                .font(.system(size: 13, weight: .medium))
                                .foregroundColor(.white)
                        }
                    }
                }
                .padding(20)
            }

            HStack(spacing: 0) {
                Button(action: onEdit) {
                    HStack(spacing: 6) {
                        Image(systemName: "pencil")
                            .font(.system(size: 14))
                        Text("Edit")
                            .font(.system(size: 14, weight: .medium))
                    }
                    .foregroundColor(Color(red: 0.15, green: 0.35, blue: 0.75))
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
                }

                Divider().frame(height: 24)

                Button(action: { showDeleteAlert = true }) {
                    HStack(spacing: 6) {
                        Image(systemName: "trash")
                            .font(.system(size: 14))
                        Text("Delete")
                            .font(.system(size: 14, weight: .medium))
                    }
                    .foregroundColor(.red)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
                }
            }
            .background(Color.white)
            .cornerRadius(14, corners: [.bottomLeft, .bottomRight])
        }
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(color: .black.opacity(0.07), radius: 8, x: 0, y: 4)
        .alert("Delete Card", isPresented: $showDeleteAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Delete", role: .destructive) { onDelete() }
        } message: {
            Text("Remove •••• \(card.lastFourDigits) from saved cards?")
        }
    }
}


// MARK: - Edit Card Sheet

struct EditCardSheet: View {
    let card: SavedCard
    @Binding var isPresented: Bool
    let onSave: (SavedCard) -> Void

    @State private var cardholderName: String
    @State private var expiryDate: String
    @FocusState private var focused: Bool

    init(card: SavedCard, isPresented: Binding<Bool>, onSave: @escaping (SavedCard) -> Void) {
        self.card       = card
        self._isPresented   = isPresented
        self.onSave     = onSave
        _cardholderName = State(initialValue: card.cardholderName)
        _expiryDate     = State(initialValue: card.expiryDate)
    }

    private var isValid: Bool {
        cardholderName.count >= 3 && expiryDate.count == 5
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 24) {
                Text("•••• •••• •••• \(card.lastFourDigits)")
                    .font(.system(size: 20, weight: .semibold, design: .monospaced))
                    .padding(.top, 8)

                VStack(spacing: 16) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Cardholder Name")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(.gray)
                        TextField("Full name on card", text: $cardholderName)
                            .textContentType(.name)
                            .focused($focused)
                            .padding()
                            .background(Color(.systemGray6))
                            .cornerRadius(10)
                    }

                    VStack(alignment: .leading, spacing: 8) {
                        Text("Expiry Date")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(.gray)
                        TextField("MM/YY", text: $expiryDate)
                            .keyboardType(.numberPad)
                            .onChange(of: expiryDate) { _, v in
                                expiryDate = formatExpiry(v)
                            }
                            .padding()
                            .background(Color(.systemGray6))
                            .cornerRadius(10)
                    }
                }
                .padding(.horizontal, 20)

                Spacer()

                Button(action: {
                    let updated = SavedCard(
                        id: card.id,
                        lastFourDigits: card.lastFourDigits,
                        cardType: card.cardType,
                        expiryDate: expiryDate,
                        cardholderName: cardholderName
                    )
                    onSave(updated)
                }) {
                    Text("Save Changes")
                        .font(.system(size: 17, weight: .semibold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(isValid ? Color(red: 0.15, green: 0.35, blue: 0.75) : Color.gray)
                        .cornerRadius(14)
                }
                .disabled(!isValid)
                .padding(.horizontal, 20)
                .padding(.bottom, 24)
            }
            .navigationTitle("Edit Card")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") { isPresented = false }
                }
            }
        }
    }

    private func formatExpiry(_ input: String) -> String {
        let cleaned = input.replacingOccurrences(of: "/", with: "").prefix(4)
        if cleaned.count > 2 {
            return "\(cleaned.prefix(2))/\(cleaned.suffix(cleaned.count - 2))"
        }
        return String(cleaned)
    }
}


// MARK: - Corner Radius Helper

extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCornerShape(radius: radius, corners: corners))
    }
}

struct RoundedCornerShape: Shape {
    var radius: CGFloat
    var corners: UIRectCorner

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        return Path(path.cgPath)
    }
}
