//
//  User.swift
//  ios_cw1
//
//  Created by Yulani Alwis on 2026-03-01.
//

import Foundation

struct User: Identifiable, Codable {
    let id: String
    var name: String
    var email: String?
    var phoneNumber: String?
    var countryCode: String
    var isVerified: Bool
    var loginMethod: LoginMethod
    var createdAt: Date
    
    init(
        id: String = UUID().uuidString,
        name: String,
        email: String? = nil,
        phoneNumber: String? = nil,
        countryCode: String = "+94",
        isVerified: Bool = false,
        loginMethod: LoginMethod = .phone,
        createdAt: Date = Date()
    ) {
        self.id = id
        self.name = name
        self.email = email
        self.phoneNumber = phoneNumber
        self.countryCode = countryCode
        self.isVerified = isVerified
        self.loginMethod = loginMethod
        self.createdAt = createdAt
    }
}

enum LoginMethod: String, Codable {
    case phone
    case faceID
    case apple
    case google
    case facebook
    case guest
}
