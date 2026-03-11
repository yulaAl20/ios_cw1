//
//  SignUpViewModel.swift
//  ios_cw1
//
//  Created by Yulani Alwis on 2026-03-01.
//

import SwiftUI
import Foundation
import UIKit
import LocalAuthentication
import Combine
import AuthenticationServices

@MainActor
class SignUpViewModel: NSObject, ObservableObject {
    @Published var callingName: String = ""
    @Published var phoneNumber: String = ""
    @Published var countryCode: String = "+94"
    @Published var isLoading: Bool = false
    @Published var showingAlert: Bool = false
    @Published var showingSuccessAlert: Bool = false
    @Published var errorMessage: String?
    @Published var isAuthenticated: Bool = false
    @Published var currentUser: User?

    private var webAuthSession: ASWebAuthenticationSession?

    override init() {
        super.init()
    }

    func createAccount() {
        guard !callingName.isEmpty else {
            showError("Please enter your calling name")
            return
        }

        guard !phoneNumber.isEmpty else {
            showError("Please enter your phone number")
            return
        }

        guard phoneNumber.count >= 9 else {
            showError("Please enter a valid phone number")
            return
        }

        isLoading = false
        
        // Persist user data for profile
        UserDefaults.standard.set(callingName, forKey: "userName")
        UserDefaults.standard.set("\(countryCode) \(phoneNumber)", forKey: "userPhoneNumber")
        
        showingSuccessAlert = true
    }

    func continueAsGuest() {
        currentUser = User(
            id: UUID().uuidString,
            name: "Guest",
            phoneNumber: nil,
            loginMethod: .guest
        )
        isAuthenticated = true
    }

    // MARK: - Apple Sign In
    func signUpWithApple() {
        let provider = ASAuthorizationAppleIDProvider()
        let request = provider.createRequest()
        request.requestedScopes = [.fullName, .email]

        let controller = ASAuthorizationController(authorizationRequests: [request])
        controller.delegate = self
        controller.presentationContextProvider = self
        controller.performRequests()

        isLoading = true
    }

    // MARK: - Google Sign In (via ASWebAuthenticationSession)
    func signUpWithGoogle() {
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
            showError("Failed to create Google authentication URL")
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
            return
        }

        if let error = error {
            showError("Google Sign Up failed: \(error.localizedDescription)")
            return
        }

        guard let callbackURL = callbackURL,
              let queryItems = URLComponents(url: callbackURL, resolvingAgainstBaseURL: false)?.queryItems,
              let _ = queryItems.first(where: { $0.name == "code" })?.value else {
            showError("Google Sign Up failed: No authorization code received")
            return
        }

        currentUser = User(
            id: UUID().uuidString,
            name: "Google User",
            email: "user@gmail.com",
            phoneNumber: nil,
            loginMethod: .google
        )
        isAuthenticated = true
        showingSuccessAlert = true
    }

    // MARK: - Facebook Sign Up
    func signUpWithFacebook() {
        isLoading = false
        currentUser = User(
            id: UUID().uuidString,
            name: "Facebook User",
            email: "user@facebook.com",
            phoneNumber: nil,
            loginMethod: .facebook
        )
        isAuthenticated = true
        showingSuccessAlert = true
    }

    private func showError(_ message: String) {
        errorMessage = message
        showingAlert = true
    }
}

// MARK: - ASAuthorizationControllerDelegate
extension SignUpViewModel: ASAuthorizationControllerDelegate {
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
            showingSuccessAlert = true
        }
    }

    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        isLoading = false

        let authError = error as NSError
        if authError.code == ASAuthorizationError.canceled.rawValue {
            return
        }

        errorMessage = "Apple Sign Up failed: \(error.localizedDescription)"
        showingAlert = true
    }
}

// MARK: - ASAuthorizationControllerPresentationContextProviding & ASWebAuthenticationPresentationContextProviding
extension SignUpViewModel: ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        let scene = UIApplication.shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .first { $0.activationState == .foregroundActive }
            ?? UIApplication.shared.connectedScenes.compactMap({ $0 as? UIWindowScene }).first!
        return scene.windows.first(where: { $0.isKeyWindow }) ?? UIWindow(windowScene: scene)
    }
}

extension SignUpViewModel: ASWebAuthenticationPresentationContextProviding {
    func presentationAnchor(for session: ASWebAuthenticationSession) -> ASPresentationAnchor {
        let scene = UIApplication.shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .first { $0.activationState == .foregroundActive }
            ?? UIApplication.shared.connectedScenes.compactMap({ $0 as? UIWindowScene }).first!
        return scene.windows.first(where: { $0.isKeyWindow }) ?? UIWindow(windowScene: scene)
    }
}
