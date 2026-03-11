//
//  PaymentMethodsViewModel.swift
//  ios_cw1
//
//  Created by COBSCCOMP242P-74 on 2026-03-11.
//

import Foundation
import Combine

class PaymentMethodsViewModel: ObservableObject {

    @Published var cards: [SavedCard]       = []
    @Published var showAddCardSheet: Bool   = false
    @Published var cardToEdit: SavedCard?   = nil
    @Published var showEditSheet: Bool      = false

    private var cancellables = Set<AnyCancellable>()

    init() {
        // Mirror CardStore into this VM so views stay reactive
        CardStore.shared.$savedCards
            .receive(on: DispatchQueue.main)
            .assign(to: \.cards, on: self)
            .store(in: &cancellables)
    }

    func deleteCard(_ card: SavedCard) {
        CardStore.shared.deleteCard(card)
    }

    func deleteCards(at offsets: IndexSet) {
        offsets.forEach { index in
            guard index < cards.count else { return }
            CardStore.shared.deleteCard(cards[index])
        }
    }

    func beginEdit(_ card: SavedCard) {
        cardToEdit  = card
        showEditSheet = true
    }

    func saveEdit(updatedCard: SavedCard) {
        CardStore.shared.updateCard(updatedCard)
        showEditSheet = false
        cardToEdit    = nil
    }

    func addNewCard(_ card: SavedCard) {
        CardStore.shared.addCard(card)
        showAddCardSheet = false
    }
}
