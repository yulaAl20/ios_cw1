//
//  AppRouter.swift
//  ios_cw1
//

import Foundation
import SwiftUI
import Combine

class AppRouter: ObservableObject {
    @Published var currentTab: Int = 0
}
