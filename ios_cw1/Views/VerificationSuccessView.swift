//
//  VerificationSuccessView.swift
//  ios_cw1
//
//  Created by Yulani Alwis on 2026-03-01.
//

import SwiftUI

struct VerificationSuccessView: View {
    var onEnableBiometrics: (() -> Void)?
    var onMaybeLater: (() -> Void)?
    @State private var agreeToTerms: Bool = false

    var body: some View {
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
                onEnableBiometrics?()
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
                onMaybeLater?()
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
    }
}

#Preview {
    VerificationSuccessView()
}
