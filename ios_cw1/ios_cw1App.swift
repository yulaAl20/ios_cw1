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
    @AppStorage("isLoggedIn")        private var isLoggedIn = false
    @AppStorage("isNewUser")         private var isNewUser  = false

    @StateObject private var appointmentStore:   AppointmentStore
    @StateObject private var router:             AppRouter
    @StateObject private var flowViewModel:      AppointmentFlowViewModel
    @StateObject private var accessibilityVM:    AccessibilityViewModel

    init() {
        let store  = AppointmentStore()
        let routerObj = AppRouter()
        let flow   = AppointmentFlowViewModel(appointmentStore: store)
        let a11y   = AccessibilityViewModel()
        _appointmentStore  = StateObject(wrappedValue: store)
        _router            = StateObject(wrappedValue: routerObj)
        _flowViewModel     = StateObject(wrappedValue: flow)
        _accessibilityVM   = StateObject(wrappedValue: a11y)
    }

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
                            if isNewUser { NewCustomerHomeView() } else { HomeView() }
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
            .environmentObject(flowViewModel)
            .environmentObject(accessibilityVM)
            // Mirror the in-app reduce-motion setting onto SwiftUI's transaction system
            .transaction { t in
                if accessibilityVM.isReduceMotionEnabled { t.animation = nil }
            }
        }
    }
}
