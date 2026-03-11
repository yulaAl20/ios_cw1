//
//  LoginView.swift
//  ios_cw1
//
//  Created by Yulani Alwis on 2026-03-01.
//

import SwiftUI

struct LoginView: View {
    @AppStorage("isLoggedIn") private var isLoggedIn = false
    @AppStorage("isNewUser") private var isNewUser = false
    @StateObject private var viewModel = LoginViewModel()
    @State private var selectedCountryCode = "+94"
    @State private var showHomeView = false
    @State private var showSignUpView = false
    @State private var showOTP = false
    @State private var otpPhoneNumber: String = ""
    
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
                
                // Login card with overlapping button
                ZStack(alignment: .top) {
                    // White card background
                    VStack(spacing: 25) {
                        // Welcome Back title - add top padding to account for button
                        VStack(spacing: 5) {
                            Text("Welcome Back")
                                .font(.system(size: 36, weight: .bold))
                                .foregroundColor(.black)
                            
                            Text("Log in to continue your visit")
                                .font(.system(size: 16))
                                .foregroundColor(.gray)
                        }
                        .padding(.top, 40)
                    
                    // Phone number input
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
                    .padding(.horizontal, 25)
                    
                    // Verify button
                    Button(action: {
                        // Validate phone number is registered before showing OTP
                        guard viewModel.validatePhoneNumber() else { return }
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
                    .disabled(viewModel.isLoading)
                    
                    // Face ID section
                    VStack(spacing: 12) {
                        Text("Use Face ID to Login")
                            .font(.system(size: 14))
                            .foregroundColor(.gray)
                        
                        Button(action: {
                            viewModel.authenticateWithFaceID()
                        }) {
                            Image(systemName: "faceid")
                                .font(.system(size: 45))
                                .foregroundColor(.gray.opacity(0.6))
                        }
                    }
                    .padding(.top, 5)
                    
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
                            viewModel.loginWithApple()
                        }
                        
                        SocialLoginButton(icon: "g.circle.fill") {
                            viewModel.loginWithGoogle()
                        }
                        
                        SocialLoginButton(icon: "f.circle.fill") {
                            viewModel.loginWithFacebook()
                        }
                    }
                    .padding(.top, 10)
                    
                    // Sign up link
                    HStack(spacing: 5) {
                        Text("Don't have an account?")
                            .font(.system(size: 14))
                            .foregroundColor(.gray)
                        
                        Button(action: {
                            showSignUpView = true
                        }) {
                            Text("Sign Up")
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
                
                // Continue as Guest button - positioned at top overlapping the card
//                Button(action: {
//                    viewModel.continueAsGuest()
//                }) {
//                    Text("Continue as a Guest")
//                        .font(.system(size: 16, weight: .medium))
//                        .foregroundColor(Color(red: 0.3, green: 0.5, blue: 0.8))
//                        .padding(.horizontal, 30)
//                        .padding(.vertical, 12)
//                        .background(Color.white)
//                        .cornerRadius(25)
//                        .shadow(color: Color.black.opacity(0.15), radius: 8, x: 0, y: 4)
//                }
               .offset(y: -25)
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
        
        .fullScreenCover(isPresented: $showSignUpView) {
            SignUpView()
        }
        .sheet(isPresented: $showOTP) {
            OTPVerificationView(phoneNumber: otpPhoneNumber, isLogin: true) {
                // Existing user login: go directly to HomeView
                showOTP = false
                isNewUser = false
                isLoggedIn = true
            }
        }
        
    }
}

// MARK: - Social Login Button Component
struct SocialLoginButton: View {
    let icon: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Image(systemName: icon)
                .font(.system(size: 28))
                .foregroundColor(.black)
                .frame(width: 60, height: 60)
                .background(Color.white)
                .clipShape(Circle())
                .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
                .overlay(
                    Circle()
                        .stroke(Color.gray.opacity(0.2), lineWidth: 1)
                )
        }
    }
}

// MARK: - Heartbeat Shape
struct HeartbeatShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let width = rect.width
        let height = rect.height
        let midY = height / 2
        
        path.move(to: CGPoint(x: 0, y: midY))
        path.addLine(to: CGPoint(x: width * 0.3, y: midY))
        path.addLine(to: CGPoint(x: width * 0.35, y: midY - 15))
        path.addLine(to: CGPoint(x: width * 0.4, y: midY + 20))
        path.addLine(to: CGPoint(x: width * 0.45, y: midY - 10))
        path.addLine(to: CGPoint(x: width * 0.5, y: midY))
        path.addLine(to: CGPoint(x: width * 0.65, y: midY))
        path.addLine(to: CGPoint(x: width * 0.7, y: midY - 8))
        path.addLine(to: CGPoint(x: width * 0.75, y: midY))
        path.addLine(to: CGPoint(x: width, y: midY))
        
        return path
    }
}

#Preview {
    LoginView()
}
