//
//  PastVisitCard.swift
//  ios_cw1
//
//  Created by COBSCCOMP242P-74 on 2026-03-11.
//

import SwiftUI

struct PastVisitCard: View {
    let title: String
    let subtitle: String?
    let date: String
    let isTest: Bool

    init(title: String, subtitle: String? = nil, date: String, isTest: Bool = false) {
        self.title = title
        self.subtitle = subtitle
        self.date = date
        self.isTest = isTest
    }

    var body: some View {
        HStack(spacing: 14) {
            // Avatar / Icon
            ZStack {
                Circle()
                    .fill(Color(red: 0.87, green: 0.93, blue: 1.0))
                    .frame(width: 50, height: 50)
                if isTest {
                    Image(systemName: "flask.fill")
                        .font(.system(size: 20))
                        .foregroundColor(Color(red: 0.15, green: 0.35, blue: 0.75))
                } else {
                    Image(systemName: "stethoscope")
                        .font(.system(size: 20))
                        .foregroundColor(Color(red: 0.15, green: 0.35, blue: 0.75))
                }
            }

            // Text info
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.primary)

                if let subtitle = subtitle, !isTest {
                    Text(subtitle)
                        .font(.system(size: 13))
                        .foregroundColor(Color(.systemGray))
                }

                HStack(spacing: 4) {
                    Image(systemName: "calendar")
                        .font(.system(size: 12))
                        .foregroundColor(Color(.systemGray2))
                    Text(date)
                        .font(.system(size: 13))
                        .foregroundColor(Color(.systemGray))
                }
            }

            Spacer()
        }
        .padding(14)
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 3)
    }
}

#Preview {
    VStack(spacing: 12) {
        PastVisitCard(title: "Dr. Sarah Perera", subtitle: "General Physician", date: "10th February 2025")
        PastVisitCard(title: "Blood Test", date: "10th February 2025", isTest: true)
    }
    .padding()
    .background(Color(.systemGroupedBackground))
}
