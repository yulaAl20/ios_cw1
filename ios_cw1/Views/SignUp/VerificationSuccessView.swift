//
//  VerificationSuccessView.swift
//  ios_cw1
//
//  Created by Yulani Alwis on 2026-03-01.
//

import SwiftUI
import LocalAuthentication

struct VerificationSuccessView: View {
    var onEnableBiometrics: (() -> Void)?
    var onMaybeLater: (() -> Void)?
    @State private var agreeToTerms: Bool = false
    @State private var showFaceIDOverlay: Bool = false
    @State private var faceIDSuccess: Bool = false
    @State private var navigateToHome: Bool = false

    var body: some View {
        ZStack {
            VStack(spacing: 24) {
                Spacer().frame(height: 40)

                Text("Verification\nSuccessful")
                    .font(.system(size: 36, weight: .bold))
                    .multilineTextAlignment(.center)
                    .padding(.top, 10)

                // Check mark
                Image(systemName: "checkmark.circle.fill")
                    .resizable()
                    .frame(width: 96, height: 96)
                    .foregroundColor(Color.green)
                    .padding(.top, 20)

                // Terms checkbox
                HStack(alignment: .top, spacing: 8) {
                    Button(action: { agreeToTerms.toggle() }) {
                        Image(systemName: agreeToTerms ? "checkmark.square.fill" : "square")
                            .foregroundColor(.gray)
                    }
                    VStack(alignment: .leading, spacing: 4) {
                        HStack(spacing: 0) {
                            Text("I agree to the ")
                                .foregroundColor(.gray)
                                .font(.system(size: 14))
                            Text("Terms & Conditions")
                                .foregroundColor(Color.blue)
                                .font(.system(size: 14))
                        }
                        HStack(spacing: 0) {
                            Text("and ")
                                .foregroundColor(.gray)
                                .font(.system(size: 14))
                            Text("Privacy Policy")
                                .foregroundColor(Color.blue)
                                .font(.system(size: 14))
                        }
                    }
                }
                .padding(.horizontal, 30)
                .padding(.top, 10)

                Spacer()

                VStack(spacing: 8) {
                    Text("Enable Biometric Login ?")
                        .font(.system(size: 22, weight: .bold))
                        .foregroundColor(Color.blue)
                        .padding(.bottom, 4)

                    Text("Turn on biometric authentication for faster and secure login.")
                        .font(.system(size: 14))
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 30)
                }
                .padding(.bottom, 10)

                Button(action: {
                    authenticateWithFaceID()
                }) {
                    Text("Enable Biometrics")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(Color(red: 0.03, green: 0.45, blue: 0.8))
                        .cornerRadius(28)
                        .padding(.horizontal, 30)
                }

                Button(action: {
                    navigateToHome = true
                }) {
                    Text("Maybe Later")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.black)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                        .background(
                            RoundedRectangle(cornerRadius: 28)
                                .stroke(Color.blue, lineWidth: 1)
                        )
                        .padding(.horizontal, 30)
                }

                Spacer().frame(height: 30)
            }
            .background(Color(UIColor.systemBackground))
            .edgesIgnoringSafeArea(.all)

            // Face ID scanning overlay
            if showFaceIDOverlay {
                FaceIDOverlayView(isSuccess: $faceIDSuccess)
            }
        }
        .fullScreenCover(isPresented: $navigateToHome) {
            NewCustomerHomeView()
        }
    }

    private func authenticateWithFaceID() {
        showFaceIDOverlay = true

        let context = LAContext()
        var error: NSError?

        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: "Enable biometric login for faster access") { success, _ in
                DispatchQueue.main.async {
                    if success {
                        faceIDSuccess = true
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                            showFaceIDOverlay = false
                            navigateToHome = true
                        }
                    } else {
                        showFaceIDOverlay = false
                    }
                }
            }
        } else {
            // Biometrics not available – simulate animation then navigate
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                faceIDSuccess = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    showFaceIDOverlay = false
                    navigateToHome = true
                }
            }
        }
    }
}

// MARK: - Face ID Scanning Overlay

struct FaceIDOverlayView: View {
    @Binding var isSuccess: Bool
    @State private var scanLineOffset: CGFloat = -60
    @State private var isPulsing: Bool = false

    var body: some View {
        ZStack {
            Color.black.opacity(0.7)
                .ignoresSafeArea()

            VStack(spacing: 30) {
                ZStack {
                    // Face ID icon
                    Image(systemName: isSuccess ? "faceid" : "faceid")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 100, height: 100)
                        .foregroundColor(isSuccess ? .green : .white)
                        .scaleEffect(isPulsing ? 1.1 : 1.0)
                        .animation(
                            isSuccess
                                ? .easeInOut(duration: 0.3)
                                : .easeInOut(duration: 0.8).repeatForever(autoreverses: true),
                            value: isPulsing
                        )

                    // Scanning line animation
                    if !isSuccess {
                        Rectangle()
                            .fill(
                                LinearGradient(
                                    colors: [.clear, .blue.opacity(0.6), .clear],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .frame(width: 100, height: 3)
                            .offset(y: scanLineOffset)
                    }
                }
                .frame(width: 120, height: 120)

                Text(isSuccess ? "Face ID Enabled!" : "Scanning Face ID...")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(.white)

                if isSuccess {
                    Image(systemName: "checkmark.circle.fill")
                        .resizable()
                        .frame(width: 40, height: 40)
                        .foregroundColor(.green)
                        .transition(.scale.combined(with: .opacity))
                }
            }
        }
        .onAppear {
            isPulsing = true
            withAnimation(.easeInOut(duration: 0.8).repeatForever(autoreverses: true)) {
                scanLineOffset = 60
            }
        }
    }
}

#Preview {
    VerificationSuccessView()
}
