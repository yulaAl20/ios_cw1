//
//  OTPViewModel.swift
//  ios_cw1
//
//  Created by Yulani Alwis on 2026-03-01.
//

import Foundation
import Combine

@MainActor
final class OTPViewModel: ObservableObject {
    @Published var otpDigits: [String]
    @Published var isLoading = false
    @Published var secondsRemaining = 60
    @Published var showingError = false
    @Published var errorMessage: String?
    @Published var infoMessage: String?

    private var timer: Timer?
    private let phoneNumber: String
    let digitCount: Int

    init(phoneNumber: String, digitCount: Int = 4) {
        self.phoneNumber = phoneNumber
        self.digitCount = digitCount
        self.otpDigits = Array(repeating: "", count: digitCount)
        startTimer()
    }

    // MARK: - Timer

    func startTimer() {
        secondsRemaining = 60
        stopTimer()
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            guard let self else { return }
            if self.secondsRemaining > 0 {
                self.secondsRemaining -= 1
            } else {
                self.stopTimer()
            }
        }
    }

    func stopTimer() {
        timer?.invalidate()
        timer = nil
    }

    // MARK: - Resend

    func resend() {
        guard secondsRemaining == 0 else { return }
        infoMessage = "OTP resent"
        startTimer()
    }

    // MARK: - Verify

    private let correctOTP = "6666"

    func verify(completion: @escaping (Bool) -> Void) {
        let code = otpDigits.joined()
        guard code.count == digitCount else {
            errorMessage = "Please enter the complete code"
            showingError = true
            completion(false)
            return
        }

        if code == correctOTP {
            stopTimer()
            completion(true)
        } else {
            errorMessage = "Wrong OTP. Please try again."
            showingError = true
            otpDigits = Array(repeating: "", count: digitCount)
            completion(false)
        }
    }
}
