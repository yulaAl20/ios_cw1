//
//  SmartSearch.swift
//  ios_cw1
//
//  Lightweight fuzzy-ish matcher used by Home search.
//

import Foundation

struct SmartSearch {

    struct Result: Identifiable {
        let id = UUID()
        let title: String
        let subtitle: String?
        let score: Double
        let payload: Payload

        enum Payload {
            case findDoctor
            case labReports
            case scans
            case pharmacy
            case indoorNavigation
            case services
            case appointments
        }
    }

    static func search(query: String, in candidates: [Result]) -> [Result] {
        let q = normalize(query)
        guard !q.isEmpty else { return [] }

        return candidates
            .compactMap { candidate in
                let haystack = normalize([candidate.title, candidate.subtitle].compactMap { $0 }.joined(separator: " "))
                let s = score(query: q, against: haystack)
                guard s > 0 else { return nil }
                return Result(title: candidate.title, subtitle: candidate.subtitle, score: s, payload: candidate.payload)
            }
            .sorted {
                if $0.score == $1.score { return $0.title < $1.title }
                return $0.score > $1.score
            }
    }

    // MARK: - Scoring

    /// A simple scoring model:
    /// - Very high score when query is a prefix of a word.
    /// - Medium score when query is a substring.
    /// - Lower score for "letters in order" match (subsequence).
    private static func score(query: String, against text: String) -> Double {
        guard !query.isEmpty, !text.isEmpty else { return 0 }

        let words = text.split(separator: " ").map(String.init)

        // Exact word / prefix match
        if words.contains(query) { return 120 }
        if words.contains(where: { $0.hasPrefix(query) }) { return 100 }

        // Substring in full text
        if text.contains(query) {
            // reward earlier matches slightly
            let idx = text.range(of: query)?.lowerBound
            let distance = idx.map { text.distance(from: text.startIndex, to: $0) } ?? 50
            return 70 - min(30, Double(distance) * 0.2)
        }

        // Multi-token: all tokens must match somehow
        let tokens = query.split(separator: " ").map(String.init)
        if tokens.count > 1 {
            let tokenScores = tokens.map { t in
                if words.contains(t) { return 40.0 }
                if words.contains(where: { $0.hasPrefix(t) }) { return 30.0 }
                if text.contains(t) { return 18.0 }
                if isSubsequence(t, of: text) { return 8.0 }
                return 0.0
            }
            if tokenScores.allSatisfy({ $0 > 0 }) { return tokenScores.reduce(0, +) }
        }

        // Fallback: letters-in-order match
        if isSubsequence(query, of: text) {
            // shorter query should score higher
            return max(5, 30 - Double(query.count))
        }

        return 0
    }

    private static func isSubsequence(_ pattern: String, of text: String) -> Bool {
        var i = pattern.startIndex
        for c in text {
            if i == pattern.endIndex { return true }
            if c == pattern[i] {
                i = pattern.index(after: i)
            }
        }
        return i == pattern.endIndex
    }

    private static func normalize(_ s: String) -> String {
        s.folding(options: [.diacriticInsensitive, .caseInsensitive], locale: .current)
            .replacingOccurrences(of: "[^a-z0-9 ]", with: " ", options: .regularExpression)
            .split(separator: " ")
            .joined(separator: " ")
    }
}
