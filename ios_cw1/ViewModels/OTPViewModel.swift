//
//  OTPViewModel.swift
//  ios_cw1
//
//  Created by Yulani Alwis on 2026-03-01.
//

import Foundation
import Combine

final class OTPViewModel: ObservableObject {
    @Published var otpDigits: [String]
    @Published var isLoading = false
    @Published var secondsRemaining = 60
    @Published var showingError = false
    @Published var errorMessage: String?
    @Published var infoMessage: String?

    private var timerCancellable: AnyCancellable?
    private let phoneNumber: String
    let digitCount: Int

    init(phoneNumber: String, digitCount: Int = 4) {
        self.phoneNumber = phoneNumber
        self.digitCount = digitCount
        self.otpDigits = Array(repeating: "", count: digitCount)
        startTimer()
    }

    deinit {
        stopTimer()
    }

    // MARK: - Timer (Combine-based, runs on main RunLoop — no background threads)

    func startTimer() {
        secondsRemaining = 60
        stopTimer()
        timerCancellable = Timer.publish(every: 1, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                guard let self else { return }
                if self.secondsRemaining > 0 {
                    self.secondsRemaining -= 1
                } else {
                    self.stopTimer()
                }
            }
    }

    func stopTimer() {
        timerCancellable?.cancel()
        timerCancellable = nil
    }

    // MARK: - Resend

    func resend() {
        guard secondsRemaining == 0 else { return }
        isLoading = true

        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            guard let self else { return }
            self.isLoading = false
            self.infoMessage = "OTP resent"
            self.startTimer()

            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) { [weak self] in
                self?.infoMessage = nil
            }
        }
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

        isLoading = true

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
            guard let self else { return }
            self.isLoading = false

            if code == self.correctOTP {
                self.stopTimer()
                completion(true)
            } else {
                self.errorMessage = "Wrong OTP. Please try again."
                self.showingError = true
                // Clear entered digits
                self.otpDigits = Array(repeating: "", count: self.digitCount)
                completion(false)
            }
        }
    }
}
