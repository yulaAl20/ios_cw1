//
//  SpeechSynthesizer.swift
//  ios_cw1
//
//  Created by Yulani Alwis on 2026-03-05.
//

import SwiftUI
import Foundation
import AVFoundation
import Combine

@MainActor
final class SpeechSynthesizer: ObservableObject {

    @Published private(set) var isSpeaking: Bool = false

    private let synthesizer = AVSpeechSynthesizer()
    private var delegateProxy: DelegateProxy? = nil

    init() {
        let proxy = DelegateProxy()
        proxy.onFinishOrCancel = { [weak self] in
            Task { @MainActor in
                self?.isSpeaking = false
            }
        }
        self.delegateProxy = proxy
        synthesizer.delegate = proxy
    }

    func toggleSpeak(_ text: String) {
        let trimmed = text.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else {
            stop()
            return
        }

        if synthesizer.isSpeaking {
            stop()
        } else {
            speak(trimmed)
        }
    }

    func speak(_ text: String) {
        let trimmed = text.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }

        if synthesizer.isSpeaking {
            synthesizer.stopSpeaking(at: .immediate)
        }

        let utterance = AVSpeechUtterance(string: trimmed)
        utterance.voice = AVSpeechSynthesisVoice(language: AVSpeechSynthesisVoice.currentLanguageCode())
        utterance.rate = AVSpeechUtteranceDefaultSpeechRate
        synthesizer.speak(utterance)

        isSpeaking = true
    }

    func stop() {
        synthesizer.stopSpeaking(at: .immediate)
        isSpeaking = false
    }
}

// Non-actor delegate proxy to satisfy Swift 6 actor isolation rules.
private final class DelegateProxy: NSObject, AVSpeechSynthesizerDelegate {
    var onFinishOrCancel: (() -> Void)?

    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        onFinishOrCancel?()
    }

    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didCancel utterance: AVSpeechUtterance) {
        onFinishOrCancel?()
    }
}
