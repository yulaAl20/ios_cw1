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
    @AppStorage("isNewUser") private var isNewUser = false
    @StateObject private var appointmentStore = AppointmentStore()
    @StateObject private var router = AppRouter()

    var body: some Scene {
        WindowGroup {
            Group {
                if !hasSeenOnboarding {
                    OnboardingView()
                } else if !isLoggedIn {
                    LoginView()
                } else {
                    Group {
                        switch router.currentTab {
                        case 0:
                            if isNewUser {
                                NewCustomerHomeView()
                            } else {
                                HomeView()
                            }
                        case 1:
                            ServicesView()
                        case 2:
                            AppointmentsView()
                        case 3:
                            IndoorNavigationView()
                        default:
                            HomeView()
                        }
                    }
                }
            }
            .environmentObject(appointmentStore)
            .environmentObject(router)
        }
    }
}
