//
//  LoginViewModel.swift
//  ios_cw1
//
//  Created by Yulani Alwis on 2026-03-01.
//

import Foundation
import UIKit
import LocalAuthentication
import Combine
import AuthenticationServices

@MainActor
class LoginViewModel: NSObject, ObservableObject {
    @Published var phoneNumber: String = ""
    @Published var countryCode: String = "+94"
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    @Published var isAuthenticated: Bool = false
    @Published var showingAlert: Bool = false
    @Published var isFaceIDAvailable: Bool = false
    @Published var currentUser: User?
    
    private var webAuthSession: ASWebAuthenticationSession?
    
    override init() {
        super.init()
        checkBiometricAvailability()
    }
    
    // MARK: - Phone Verification
    
    // List of registered numbers
    private let registeredNumbers = [
        "0762182199",
        "0771234567",
        "0719876543",
        "0777777777"
    ]
    
    /// Validates the phone number is registered. Returns true if valid, false otherwise (shows alert).
    func validatePhoneNumber() -> Bool {
        guard !phoneNumber.isEmpty else {
            errorMessage = "Please enter a valid phone number"
            showingAlert = true
            return false
        }
        
        guard registeredNumbers.contains(phoneNumber) else {
            errorMessage = "This mobile number is not registered"
            showingAlert = true
            return false
        }
        
        return true
    }
    
    func verifyPhoneNumber() {
        guard !phoneNumber.isEmpty else {
            errorMessage = "Please enter a valid phone number"
            showingAlert = true
            return
        }
        
        // List of registered numbers
        let registeredNumbers = [
            "0762182199",
            "0771234567",
            "0719876543",
            "0777777777"
        ]
        
        guard registeredNumbers.contains(phoneNumber) else {
            errorMessage = "This mobile number is not registered"
            showingAlert = true
            return
        }
        
        isLoading = false
        
        currentUser = User(
            id: UUID().uuidString,
            name: "Registered User",
            phoneNumber: "\(countryCode)\(phoneNumber)",
            loginMethod: .phone
        )
        
        isAuthenticated = true
    }
    
    // MARK: - Face ID Authentication
    func authenticateWithFaceID() {
        let context = LAContext()
        var error: NSError?
        
        // Check if biometric authentication is available
        guard context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) else {
            if let error = error {
                switch error.code {
                case LAError.biometryNotAvailable.rawValue:
                    errorMessage = "Biometric authentication is not available on this device"
                case LAError.biometryNotEnrolled.rawValue:
                    errorMessage = "No biometric data is enrolled. Please set up Face ID in Settings"
                case LAError.biometryLockout.rawValue:
                    errorMessage = "Biometric authentication is locked. Please try again later"
                default:
                    errorMessage = "Face ID is not available: \(error.localizedDescription)"
                }
            } else {
                errorMessage = "Face ID is not available on this device"
            }
            showingAlert = true
            return
        }
        
        isLoading = true
        
        // Set up context
        context.localizedCancelTitle = "Use Phone Number"
        context.localizedFallbackTitle = "Enter Password"
        
        // Evaluate policy
        context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: "Log in to Clinic Flow") { [weak self] success, authenticationError in
            DispatchQueue.main.async {
                guard let self else { return }
                self.handleFaceIDResult(success: success, error: authenticationError)
            }
        }
    }
    
    private func handleFaceIDResult(success: Bool, error: Error?) {
        isLoading = false
        
        if success {
            // Create user with Face ID authentication
            currentUser = User(
                id: UUID().uuidString,
                name: "Face ID User",
                phoneNumber: nil,
                loginMethod: .faceID
            )
            
            isAuthenticated = true
            print("Face ID authentication successful")
        } else {
            if let error = error as? LAError {
                switch error.code {
                case .authenticationFailed:
                    errorMessage = "Authentication failed. Please try again"
                case .userCancel:
                    print("⚠️ User cancelled Face ID authentication")
                    return // Don't show error for user cancellation
                case .userFallback:
                    errorMessage = "User selected fallback authentication"
                case .systemCancel:
                    print("⚠️ System cancelled Face ID authentication")
                    return
                case .passcodeNotSet:
                    errorMessage = "Passcode is not set on this device"
                case .biometryNotAvailable:
                    errorMessage = "Biometric authentication is not available"
                case .biometryNotEnrolled:
                    errorMessage = "No biometric data enrolled"
                case .biometryLockout:
                    errorMessage = "Too many failed attempts. Please try again later"
                default:
                    errorMessage = error.localizedDescription
                }
            } else {
                errorMessage = error?.localizedDescription ?? "Authentication failed"
            }
            showingAlert = true
        }
    }
    
    // MARK: - Apple Sign In
    func loginWithApple() {
        let provider = ASAuthorizationAppleIDProvider()
        let request = provider.createRequest()
        request.requestedScopes = [.fullName, .email]
        
        let controller = ASAuthorizationController(authorizationRequests: [request])
        controller.delegate = self
        controller.presentationContextProvider = self
        controller.performRequests()
        
        isLoading = true
        print("🍎 Initiating Apple Sign In...")
    }
    
    // MARK: - Google Sign In (via ASWebAuthenticationSession)
    func loginWithGoogle() {
        // Google OAuth 2.0 parameters
        // NOTE: Replace these with your actual Google OAuth client ID and redirect URI
        let clientID = "YOUR_GOOGLE_CLIENT_ID.apps.googleusercontent.com"
        let redirectURI = "com.googleusercontent.apps.YOUR_GOOGLE_CLIENT_ID:/oauthredirect"
        let scope = "openid profile email"
        
        var components = URLComponents(string: "https://accounts.google.com/o/oauth2/v2/auth")!
        components.queryItems = [
            URLQueryItem(name: "client_id", value: clientID),
            URLQueryItem(name: "redirect_uri", value: redirectURI),
            URLQueryItem(name: "response_type", value: "code"),
            URLQueryItem(name: "scope", value: scope)
        ]
        
        guard let authURL = components.url else {
            errorMessage = "Failed to create Google authentication URL"
            showingAlert = true
            return
        }
        
        let callbackScheme = redirectURI.components(separatedBy: ":").first ?? ""
        
        isLoading = true
        
        let session = ASWebAuthenticationSession(url: authURL, callbackURLScheme: callbackScheme) { [weak self] callbackURL, error in
            DispatchQueue.main.async {
                guard let self else { return }
                self.handleGoogleResult(callbackURL: callbackURL, error: error)
            }
        }
        
        session.presentationContextProvider = self
        session.prefersEphemeralWebBrowserSession = true
        session.start()
        self.webAuthSession = session
    }
    
    private func handleGoogleResult(callbackURL: URL?, error: Error?) {
        isLoading = false
        
        if let error = error as? ASWebAuthenticationSessionError,
           error.code == .canceledLogin {
            // User cancelled — don't show error
            return
        }
        
        if let error = error {
            errorMessage = "Google Sign In failed: \(error.localizedDescription)"
            showingAlert = true
            return
        }
        
        guard let callbackURL = callbackURL,
              let queryItems = URLComponents(url: callbackURL, resolvingAgainstBaseURL: false)?.queryItems,
              let _ = queryItems.first(where: { $0.name == "code" })?.value else {
            errorMessage = "Google Sign In failed: No authorization code received"
            showingAlert = true
            return
        }
        
        // Successfully received auth code — create user
        currentUser = User(
            id: UUID().uuidString,
            name: "Google User",
            email: "user@gmail.com",
            phoneNumber: nil,
            loginMethod: .google
        )
        isAuthenticated = true
    }
    
    // MARK: - Facebook Login
    func loginWithFacebook() {
        isLoading = false
        
        currentUser = User(
            id: UUID().uuidString,
            name: "Facebook User",
            email: "user@facebook.com",
            phoneNumber: nil,
            loginMethod: .facebook
        )
        
        isAuthenticated = true
    }
    
    // MARK: - Guest Mode
    func continueAsGuest() {
        currentUser = User(
            id: UUID().uuidString,
            name: "Guest",
            phoneNumber: nil,
            loginMethod: .guest
        )
        
        isAuthenticated = true
    }
    
    // MARK: - Logout
    func logout() {
        isAuthenticated = false
        currentUser = nil
        phoneNumber = ""
    }
    
    // MARK: - Helper Methods
    private func checkBiometricAvailability() {
        let context = LAContext()
        var error: NSError?
        isFaceIDAvailable = context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error)
    }
}

// MARK: - ASAuthorizationControllerDelegate
extension LoginViewModel: ASAuthorizationControllerDelegate {
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        isLoading = false
        
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            let userID = appleIDCredential.user
            let fullName = appleIDCredential.fullName
            let email = appleIDCredential.email
            
            let userName = [fullName?.givenName, fullName?.familyName]
                .compactMap { $0 }
                .joined(separator: " ")
            
            currentUser = User(
                id: userID,
                name: userName.isEmpty ? "Apple User" : userName,
                email: email,
                phoneNumber: nil,
                loginMethod: .apple
            )
            
            isAuthenticated = true
            print("Apple Sign In successful - User ID: \(userID)")
            print("   Name: \(userName)")
            print("   Email: \(email ?? "Not provided")")
        }
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        isLoading = false
        
        let authError = error as NSError
        if authError.code == ASAuthorizationError.canceled.rawValue {
            print("⚠️ Apple Sign In cancelled by user")
            return
        }
        
        errorMessage = "Apple Sign In failed: \(error.localizedDescription)"
        showingAlert = true
        print("Apple Sign In error: \(error.localizedDescription)")
    }
}

// MARK: - ASAuthorizationControllerPresentationContextProviding & ASWebAuthenticationPresentationContextProviding
extension LoginViewModel: ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        let scene = UIApplication.shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .first { $0.activationState == .foregroundActive }
            ?? UIApplication.shared.connectedScenes.compactMap({ $0 as? UIWindowScene }).first!
        return scene.windows.first(where: { $0.isKeyWindow }) ?? UIWindow(windowScene: scene)
    }
}

extension LoginViewModel: ASWebAuthenticationPresentationContextProviding {
    func presentationAnchor(for session: ASWebAuthenticationSession) -> ASPresentationAnchor {
        let scene = UIApplication.shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .first { $0.activationState == .foregroundActive }
            ?? UIApplication.shared.connectedScenes.compactMap({ $0 as? UIWindowScene }).first!
        return scene.windows.first(where: { $0.isKeyWindow }) ?? UIWindow(windowScene: scene)
    }
}
