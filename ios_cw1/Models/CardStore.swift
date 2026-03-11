//
//  CardStore.swift
//  ios_cw1
//
//  Created by COBSCCOMP242P-74 on 2026-03-11.
//

import Foundation
import Combine

class CardStore: ObservableObject {

    static let shared = CardStore()

    @Published private(set) var savedCards: [SavedCard] = []

    private let storageKey = "saved_payment_cards_v1"

    private init() {
        loadCards()
    }

    // MARK: - Public Actions

    func addCard(_ card: SavedCard) {
        guard !savedCards.contains(where: { $0.id == card.id }) else { return }
        savedCards.append(card)
        persistCards()
    }

    func deleteCard(_ card: SavedCard) {
        savedCards.removeAll { $0.id == card.id }
        persistCards()
    }

    func updateCard(_ updated: SavedCard) {
        guard let index = savedCards.firstIndex(where: { $0.id == updated.id }) else { return }
        savedCards[index] = updated
        persistCards()
    }

    // MARK: - Persistence

    private func persistCards() {
        do {
            let data = try JSONEncoder().encode(savedCards)
            UserDefaults.standard.set(data, forKey: storageKey)
        } catch {
            print("CardStore: failed to encode cards – \(error)")
        }
    }

    private func loadCards() {
        guard let data = UserDefaults.standard.data(forKey: storageKey) else { return }
        do {
            savedCards = try JSONDecoder().decode([SavedCard].self, from: data)
        } catch {
            print("CardStore: failed to decode cards – \(error)")
            savedCards = []
        }
    }
}
