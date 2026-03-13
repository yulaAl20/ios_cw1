//
//  SignUpView.swift
//  ios_cw1
//
//  Created by Yulani Alwis on 2026-03-01.
//

import SwiftUI

struct SignUpView: View {
    @StateObject private var viewModel = SignUpViewModel()
    @State private var selectedCountryCode = "+94"
    @Environment(\.dismiss) private var dismiss
    @State private var showOTP = false
    @State private var otpPhoneNumber: String = ""
    // Show the success/biometrics screen after OTP verification
    @State private var showVerificationSuccess = false
    
    let countryCodes = ["+94", "+1", "+44", "+91", "+61"]

    var body: some View {
        ZStack {
            // Background gradient
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(red: 0.68, green: 0.85, blue: 0.95),
                    Color(red: 0.85, green: 0.92, blue: 0.98)
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Top section with logo
                VStack(spacing: 20) {
                    Spacer()
                    
                    // Logo and Title
                    VStack(spacing: 8) {
                        // Stethoscope icon with heartbeat line
                        ZStack {
                            // Heartbeat line
                            HeartbeatShape()
                                .stroke(Color.blue.opacity(0.4), lineWidth: 2)
                                .frame(width: 200, height: 50)
                            
                            // Stethoscope icon
                            Image(systemName: "stethoscope")
                                .font(.system(size: 50))
                                .foregroundColor(Color(red: 0.2, green: 0.4, blue: 0.7))
                        }
                        .padding(.bottom, 5)
                        
                        Text("Clinic Flow")
                            .font(.system(size: 28, weight: .semibold))
                            .foregroundColor(Color(red: 0.2, green: 0.4, blue: 0.7))
                    }
                    .frame(maxWidth: .infinity)
                    
                    Spacer()
                }
                .frame(maxHeight: .infinity)
                
                // Sign up card with overlapping button
                ZStack(alignment: .top) {
                    // White card background
                    VStack(spacing: 25) {
                        // Create Account title
                        VStack(spacing: 8) {
                            Text("Create Account")
                                .font(.system(size: 36, weight: .bold))
                                .foregroundColor(.black)
                            
                            Text("Register for a smoother clinic visit")
                                .font(.system(size: 16))
                                .foregroundColor(.gray)
                        }
                        .padding(.top, 40)
                        
                        // Calling Name input
                        HStack(spacing: 0) {
                            // User icon
                            Image(systemName: "person.fill")
                                .foregroundColor(Color(red: 0.3, green: 0.5, blue: 0.8))
                                .font(.system(size: 18))
                                .padding(.leading, 20)
                            
                            // Name text field
                            TextField("Calling Name", text: $viewModel.callingName)
                                .font(.system(size: 16))
                                .padding(.leading, 15)
                                .padding(.trailing, 20)
                        }
                        .padding(.vertical, 15)
                        .background(Color.white)
                        .cornerRadius(30)
                        .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
                        .overlay(
                            RoundedRectangle(cornerRadius: 30)
                                .stroke(Color.gray.opacity(0.2), lineWidth: 1)
                        )
                        .padding(.horizontal, 25)
                        
                        // Phone number input
                        VStack(spacing: 8) {
                            HStack(spacing: 0) {
                                // Country code picker
                                Menu {
                                    ForEach(countryCodes, id: \.self) { code in
                                        Button(action: {
                                            selectedCountryCode = code
                                            viewModel.countryCode = code
                                        }) {
                                            Text(code)
                                        }
                                    }
                                } label: {
                                    HStack(spacing: 4) {
                                        Text(selectedCountryCode)
                                            .font(.system(size: 16))
                                            .foregroundColor(.gray)
                                        Image(systemName: "chevron.down")
                                            .font(.system(size: 12))
                                            .foregroundColor(.gray)
                                    }
                                    .padding(.horizontal, 15)
                                }
                                
                                Divider()
                                    .frame(height: 25)
                                    .padding(.horizontal, 8)
                                
                                // Phone icon
                                Image(systemName: "phone.fill")
                                    .foregroundColor(Color(red: 0.3, green: 0.5, blue: 0.8))
                                    .font(.system(size: 18))
                                
                                // Phone number text field
                                TextField("Phone Number", text: $viewModel.phoneNumber)
                                    .font(.system(size: 16))
                                    .keyboardType(.numberPad)
                                    .padding(.leading, 12)
                                    .onChange(of: viewModel.phoneNumber) { _, newValue in
                                        let filtered = newValue.filter { $0.isNumber }
                                        let limited = String(filtered.prefix(10))
                                        if viewModel.phoneNumber != limited {
                                            viewModel.phoneNumber = limited
                                        }
                                    }
                            }
                            .padding(.horizontal, 15)
                            .padding(.vertical, 15)
                            .background(Color.white)
                            .cornerRadius(30)
                            .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
                            .overlay(
                                RoundedRectangle(cornerRadius: 30)
                                    .stroke(Color.gray.opacity(0.2), lineWidth: 1)
                            )
                            
                            // Helper text
                            Text("This number will be used for appointment updates.")
                                .font(.system(size: 12))
                                .foregroundColor(.gray)
                                .padding(.horizontal, 10)
                        }
                        .padding(.horizontal, 25)
                        
                        // Verify button
                        Button(action: {
                            // Show OTP sheet before finalizing account creation
                            otpPhoneNumber = "\(selectedCountryCode) \(viewModel.phoneNumber)"
                            showOTP = true
                        }) {
                            Text("Verify")
                                .font(.system(size: 18, weight: .semibold))
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 16)
                                .background(
                                    Color(red: 0.25, green: 0.47, blue: 0.75)
                                )
                                .cornerRadius(30)
                                .shadow(color: Color.blue.opacity(0.3), radius: 8, x: 0, y: 4)
                        }
                        .padding(.horizontal, 30)
                        .disabled(viewModel.isLoading || viewModel.callingName.trimmingCharacters(in: .whitespaces).isEmpty || viewModel.phoneNumber.trimmingCharacters(in: .whitespaces).isEmpty)
                        .opacity((viewModel.callingName.trimmingCharacters(in: .whitespaces).isEmpty || viewModel.phoneNumber.trimmingCharacters(in: .whitespaces).isEmpty) ? 0.5 : 1.0)
                        
                        // Divider with text
                        HStack {
                            Rectangle()
                                .fill(Color.gray.opacity(0.3))
                                .frame(height: 1)
                            
                            Text("Or Continue with")
                                .font(.system(size: 13))
                                .foregroundColor(.gray)
                                .padding(.horizontal, 8)
                            
                            Rectangle()
                                .fill(Color.gray.opacity(0.3))
                                .frame(height: 1)
                        }
                        .padding(.horizontal, 40)
                        .padding(.top, 5)
                        
                        // Social login buttons
                        HStack(spacing: 35) {
                            SocialLoginButton(icon: "apple.logo") {
                                viewModel.signUpWithApple()
                            }
                            
                            SocialLoginButton(icon: "g.circle.fill") {
                                viewModel.signUpWithGoogle()
                            }
                            
                            SocialLoginButton(icon: "f.circle.fill") {
                                viewModel.signUpWithFacebook()
                            }
                        }
                        .padding(.top, 10)
                        
                        // Log in link
                        HStack(spacing: 5) {
                            Text("Already have an account?")
                                .font(.system(size: 14))
                                .foregroundColor(.gray)
                            
                            Button(action: {
                                dismiss()
                            }) {
                                Text("Log In")
                                    .font(.system(size: 14, weight: .semibold))
                                    .foregroundColor(Color(red: 0.3, green: 0.5, blue: 0.8))
                            }
                        }
                        .padding(.top, 15)
                        .padding(.bottom, 25)
                    }
                    .frame(maxWidth: .infinity)
                    .background(
                        RoundedRectangle(cornerRadius: 30)
                            .fill(Color.white.opacity(0.95))
                            .shadow(color: Color.black.opacity(0.1), radius: 20, x: 0, y: -5)
                    )
                    
                    // ...existing code...
                }
            }
            .ignoresSafeArea(edges: .bottom)
            
            // Loading overlay
            if viewModel.isLoading {
                Color.black.opacity(0.3)
                    .ignoresSafeArea()
                
                ProgressView()
                    .scaleEffect(1.5)
                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
            }
        }
        .alert("Error", isPresented: $viewModel.showingAlert) {
            Button("OK", role: .cancel) {}
        } message: {
            if let errorMessage = viewModel.errorMessage {
                Text(errorMessage)
            }
        }
        .alert("Success", isPresented: $viewModel.showingSuccessAlert) {
            Button("OK", role: .cancel) {
                // No explicit dismiss here; the app root will update to the authenticated UI.
                // Avoid calling dismiss() because SignUpView may be deallocated when the root changes.
            }
        } message: {
            Text("Account created successfully!")
        }
        .sheet(isPresented: $showOTP) {
            OTPVerificationView(phoneNumber: otpPhoneNumber) {
                // After OTP verified in the OTP sheet, present the VerificationSuccessView from the SignUp view
                showOTP = false
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.22) {
                    showVerificationSuccess = true
                }
            }
        }
        .fullScreenCover(isPresented: $showVerificationSuccess) {
            VerificationSuccessView(
                onEnableBiometrics: {
                    // User enabled biometrics in the verification screen -> create account and dismiss sign up
                    viewModel.createAccount()
                    showVerificationSuccess = false
                    // The createAccount flow sets isLoggedIn/isNewUser and showingSuccessAlert which will dismiss the view on OK
                },
                onMaybeLater: {
                    // User skipped biometrics -> still create account and dismiss
                    viewModel.createAccount()
                    showVerificationSuccess = false
                }
            )
         }
    }
}

#Preview {
    SignUpView()
}
