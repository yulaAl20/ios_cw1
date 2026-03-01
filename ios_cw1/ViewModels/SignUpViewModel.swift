//
//  SignUpViewModel.swift
//  ios_cw1
//
//  Created by Yulani Alwis on 2026-03-01.
//

import SwiftUI
import Foundation
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

        isLoading = true

        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [weak self] in
            self?.isLoading = false
            print("Account created for: \(self?.callingName ?? "") with phone: \(self?.countryCode ?? "")\(self?.phoneNumber ?? "")")
            self?.showingSuccessAlert = true
        }
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
                self.isLoading = false

                if let error = error as? ASWebAuthenticationSessionError,
                   error.code == .canceledLogin {
                    return
                }

                if let error = error {
                    self.showError("Google Sign Up failed: \(error.localizedDescription)")
                    return
                }

                guard let callbackURL = callbackURL,
                      let queryItems = URLComponents(url: callbackURL, resolvingAgainstBaseURL: false)?.queryItems,
                      let _ = queryItems.first(where: { $0.name == "code" })?.value else {
                    self.showError("Google Sign Up failed: No authorization code received")
                    return
                }

                self.currentUser = User(
                    id: UUID().uuidString,
                    name: "Google User",
                    email: "user@gmail.com",
                    phoneNumber: nil,
                    loginMethod: .google
                )
                self.isAuthenticated = true
                self.showingSuccessAlert = true
            }
        }

        session.presentationContextProvider = self
        session.prefersEphemeralWebBrowserSession = true
        session.start()
        self.webAuthSession = session
    }

    // MARK: - Facebook Sign Up
    func signUpWithFacebook() {
        isLoading = true

        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
            self?.isLoading = false
            self?.currentUser = User(
                id: UUID().uuidString,
                name: "Facebook User",
                email: "user@facebook.com",
                phoneNumber: nil,
                loginMethod: .facebook
            )
            self?.isAuthenticated = true
            self?.showingSuccessAlert = true
        }
    }

    private func showError(_ message: String) {
        errorMessage = message
        showingAlert = true
    }
}

// MARK: - ASAuthorizationControllerDelegate
extension SignUpViewModel: ASAuthorizationControllerDelegate {
    nonisolated func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        Task { @MainActor in
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
    }

    nonisolated func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        Task { @MainActor in
            isLoading = false

            let authError = error as NSError
            if authError.code == ASAuthorizationError.canceled.rawValue {
                return
            }

            errorMessage = "Apple Sign Up failed: \(error.localizedDescription)"
            showingAlert = true
        }
    }
}

// MARK: - ASAuthorizationControllerPresentationContextProviding & ASWebAuthenticationPresentationContextProviding
extension SignUpViewModel: ASAuthorizationControllerPresentationContextProviding {
    nonisolated func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return MainActor.assumeIsolated {
            let scenes = UIApplication.shared.connectedScenes
            if let windowScene = scenes.first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene,
               let window = windowScene.windows.first(where: { $0.isKeyWindow }) {
                return window
            }
            let fallbackScene = scenes.compactMap { $0 as? UIWindowScene }.first!
            return UIWindow(windowScene: fallbackScene)
        }
    }
}

extension SignUpViewModel: ASWebAuthenticationPresentationContextProviding {
    nonisolated func presentationAnchor(for session: ASWebAuthenticationSession) -> ASPresentationAnchor {
        return MainActor.assumeIsolated {
            let scenes = UIApplication.shared.connectedScenes
            if let windowScene = scenes.first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene,
               let window = windowScene.windows.first(where: { $0.isKeyWindow }) {
                return window
            }
            let fallbackScene = scenes.compactMap { $0 as? UIWindowScene }.first!
            return UIWindow(windowScene: fallbackScene)
        }
    }
}
