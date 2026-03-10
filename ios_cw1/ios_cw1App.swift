//
//  ios_cw1App.swift
//  ios_cw1
//
//  Created by Yulani Alwis on 2026-03-01.
//

import SwiftUI

@main
struct ios_cw1App: App {
    @AppStorage("hasSeenOnboarding") private var hasSeenOnboarding = false
    @AppStorage("isLoggedIn") private var isLoggedIn = false
    @StateObject private var appointmentStore = AppointmentStore()

    var body: some Scene {
        WindowGroup {
            HomeView()
                        .environmentObject(appointmentStore)
//            if !hasSeenOnboarding {
//                OnboardingView()
//                    .environmentObject(appointmentStore)
//            } else if !isLoggedIn {
//                LoginView()
//                    .environmentObject(appointmentStore)
//            } else {
//                HomeView()
//                    .environmentObject(appointmentStore)
//            }
        }
    }
}
