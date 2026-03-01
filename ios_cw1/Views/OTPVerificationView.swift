//
//  OTPVerificationView.swift
//  ios_cw1
//
//  Created by Yulani Alwis on 2026-03-01.
//
import SwiftUI
import UIKit
import Combine

struct OTPVerificationView: View {
    let phoneNumber: String
    var onVerified: (() -> Void)?

    @StateObject private var vm: OTPViewModel
    @Environment(\.dismiss) private var dismiss
    @FocusState private var isTextFieldFocused: Bool
    @State private var showSuccess = false
    @State private var otpText = ""

    init(phoneNumber: String, onVerified: (() -> Void)? = nil) {
        self.phoneNumber = phoneNumber
        self.onVerified = onVerified
        _vm = StateObject(wrappedValue: OTPViewModel(phoneNumber: phoneNumber))
    }

    var body: some View {
        VStack(spacing: 24) {
            backButton
            Spacer().frame(height: 10)
            titleSection
            otpBoxes
            infoSection
            Spacer()
            verifyButton
            resendButton
            Spacer()
        }
        .fullScreenCover(isPresented: $showSuccess) {
            VerificationSuccessView(
                onEnableBiometrics: { showSuccess = false; dismiss() },
                onMaybeLater: { showSuccess = false; dismiss() }
            )
        }
        .alert("Error", isPresented: $vm.showingError) {
            Button("OK", role: .cancel) {}
        } message: {
            if let msg = vm.errorMessage { Text(msg) }
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                isTextFieldFocused = true
            }
        }
    }

    // MARK: - Back Button

    private var backButton: some View {
        HStack {
            Button(action: { dismiss() }) {
                Image(systemName: "chevron.left")
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(.black)
            }
            Spacer()
        }
        .padding()
    }

    // MARK: - Title

    private var titleSection: some View {
        VStack(spacing: 12) {
            Text("Verify Your\nPhone Number")
                .font(.system(size: 34, weight: .bold))
                .multilineTextAlignment(.center)

            Text("Enter the 4-digit code sent to\n\(phoneNumber).")
                .font(.system(size: 14))
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
        }
    }

    // MARK: - OTP Boxes (single hidden TextField + visual boxes)

    private var otpBoxes: some View {
        ZStack {
            // Hidden TextField that captures all keyboard input
            TextField("", text: $otpText)
                .keyboardType(.numberPad)
                .textContentType(.oneTimeCode)
                .focused($isTextFieldFocused)
                .frame(width: 1, height: 1)
                .opacity(0.01)
                .onChange(of: otpText) { _, newValue in
                    let filtered = newValue.filter { $0.isNumber }
                    let limited = String(filtered.prefix(4))
                    if otpText != limited {
                        otpText = limited
                    }
                    syncDigits(from: limited)

                    // Auto-verify when all 4 digits entered
                    if limited.count == 4 {
                        vm.verify { success in
                            if success {
                                showSuccess = true
                                onVerified?()
                            } else {
                                // Clear input on wrong OTP
                                otpText = ""
                            }
                        }
                    }
                }

            // Visual digit boxes
            HStack(spacing: 18) {
                ForEach(0..<4, id: \.self) { index in
                    digitBox(index: index)
                }
            }
            .contentShape(Rectangle())
            .onTapGesture {
                isTextFieldFocused = true
            }
        }
        .padding(.top, 10)
    }

    private func digitBox(index: Int) -> some View {
        let digit: String = index < vm.otpDigits.count ? vm.otpDigits[index] : ""
        let isCurrent: Bool = otpText.count == index && isTextFieldFocused

        return Text(digit)
            .font(.system(size: 24, weight: .semibold))
            .frame(width: 64, height: 64)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(isCurrent ? Color.blue : Color.gray.opacity(0.4), lineWidth: isCurrent ? 2 : 1)
            )
    }

    private func syncDigits(from text: String) {
        for i in 0..<4 {
            if i < text.count {
                let idx = text.index(text.startIndex, offsetBy: i)
                vm.otpDigits[i] = String(text[idx])
            } else {
                vm.otpDigits[i] = ""
            }
        }
    }

    // MARK: - Info Section

    private var infoSection: some View {
        VStack(spacing: 8) {
            if let info = vm.infoMessage {
                Text(info)
                    .font(.system(size: 14))
                    .foregroundColor(.green)
            }

            if vm.isLoading {
                ProgressView()
            }

            let mins: Int = vm.secondsRemaining / 60
            let secs: Int = vm.secondsRemaining % 60
            Text(String(format: "%02d:%02d seconds remaining", mins, secs))
                .foregroundColor(.blue)
        }
    }

    // MARK: - Verify Button

    private var verifyButton: some View {
        Button(action: {
            vm.verify { success in
                if success {
                    showSuccess = true
                    onVerified?()
                }
            }
        }) {
            Text("Verify")
                .font(.system(size: 18, weight: .semibold))
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 14)
                .background(Color.blue)
                .cornerRadius(12)
                .padding(.horizontal, 40)
        }
        .disabled(vm.isLoading)
    }

    // MARK: - Resend Button

    private var resendButton: some View {
        VStack(spacing: 8) {
            Text("Didn't receive the code?")
                .font(.system(size: 14))
                .foregroundColor(.gray)

            Button(action: {
                otpText = ""
                vm.resend()
            }) {
                Text("Resend New Code")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(vm.secondsRemaining == 0 ? Color.blue : Color.gray)
            }
            .disabled(vm.secondsRemaining != 0 || vm.isLoading)
        }
    }
}

#Preview {
    OTPVerificationView(phoneNumber: "+94 72 222 3333")
}

