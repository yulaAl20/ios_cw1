//
//  AppRouter.swift
//  ios_cw1
//

import Foundation
import SwiftUI
import Combine

class AppRouter: ObservableObject {
    @Published var currentTab: Int = 0
    @Published var isNewUser: Bool = false
    @Published var appointmentsInitialTab: String? = nil
}
