//
//  NotificationsPageView.swift
//  ios_cw1
//

import SwiftUI

struct NotificationsPageView: View {

    @Environment(\.dismiss) private var dismiss

    @State private var selectedCategory: AppNotificationCategory? = nil
    @State private var notifications: [AppNotification] = AppNotification.sample

    private var filtered: [AppNotification] {
        let list = notifications.sorted { $0.date > $1.date }
        guard let selectedCategory else { return list }
        return list.filter { $0.category == selectedCategory }
    }

    var body: some View {
        NavigationStack {
            ZStack {
                Color(red: 0.90, green: 0.93, blue: 0.98)
                    .ignoresSafeArea()

                VStack(spacing: 14) {
                    header

                    filterChips

                    ScrollView(showsIndicators: false) {
                        VStack(spacing: 12) {
                            ForEach(filtered) { n in
                                notificationCard(n)
                            }

                            if filtered.isEmpty {
                                Text("No notifications")
                                    .font(.system(size: 14, weight: .medium))
                                    .foregroundColor(.secondary)
                                    .padding(.top, 24)
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.bottom, 24)
                    }
                }
                .padding(.top, 10)
            }
        }
    }

    private var header: some View {
        HStack {
            Button(action: { dismiss() }) {
                Image(systemName: "chevron.left")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(.black)
                    .frame(width: 40, height: 40)
                    .background(Color.white)
                    .clipShape(Circle())
            }

            Spacer()

            Text("Notifications")
                .font(.system(size: 18, weight: .semibold))
                .foregroundColor(.black)

            Spacer()

            Button {
                // mark all as read (simple UI state)
                for idx in notifications.indices {
                    notifications[idx].isRead = true
                }
            } label: {
                Text("Read")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundColor(Color(red: 0.15, green: 0.35, blue: 0.75))
                    .padding(.horizontal, 14)
                    .padding(.vertical, 10)
                    .background(Color.white)
                    .cornerRadius(14)
            }
        }
        .padding(.horizontal, 20)
    }

    private var filterChips: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 10) {
                chip(title: "All", isSelected: selectedCategory == nil) {
                    selectedCategory = nil
                }

                ForEach(AppNotificationCategory.allCases) { cat in
                    chip(title: cat.rawValue, isSelected: selectedCategory == cat) {
                        selectedCategory = cat
                    }
                }
            }
            .padding(.horizontal, 20)
        }
    }

    private func chip(title: String, isSelected: Bool, action: @escaping () -> Void) -> some View {
        Button {
            withAnimation(.easeInOut(duration: 0.2)) { action() }
        } label: {
            Text(title)
                .font(.system(size: 13, weight: .semibold))
                .foregroundColor(isSelected ? .white : .black)
                .padding(.horizontal, 14)
                .padding(.vertical, 10)
                .background(isSelected ? Color(red: 0.15, green: 0.35, blue: 0.75) : Color.white)
                .cornerRadius(16)
                .shadow(color: .black.opacity(0.04), radius: 6, x: 0, y: 3)
        }
        .buttonStyle(.plain)
    }

    private func notificationCard(_ n: AppNotification) -> some View {
        HStack(alignment: .top, spacing: 12) {
            ZStack {
                Circle()
                    .fill(iconBg(for: n.category))
                    .frame(width: 40, height: 40)

                Image(systemName: icon(for: n.category))
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(iconColor(for: n.category))
            }

            VStack(alignment: .leading, spacing: 6) {
                HStack(alignment: .top) {
                    Text(n.title)
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundColor(.black)

                    Spacer()

                    if !n.isRead {
                        Circle()
                            .fill(Color(red: 0.15, green: 0.35, blue: 0.75))
                            .frame(width: 8, height: 8)
                            .padding(.top, 4)
                    }
                }

                Text(n.message)
                    .font(.system(size: 13))
                    .foregroundColor(.gray)

                Text(relativeDate(n.date))
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(.secondary)
            }
        }
        .padding(14)
        .background(Color.white)
        .cornerRadius(18)
        .shadow(color: .black.opacity(0.04), radius: 8, x: 0, y: 4)
    }

    private func relativeDate(_ date: Date) -> String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .abbreviated
        return formatter.localizedString(for: date, relativeTo: Date())
    }

    private func icon(for category: AppNotificationCategory) -> String {
        switch category {
        case .appointment: return "calendar.badge.clock"
        case .pharmacy: return "pills.fill"
        case .labs: return "testtube.2"
        case .cancellations: return "xmark.circle.fill"
        }
    }

    private func iconColor(for category: AppNotificationCategory) -> Color {
        switch category {
        case .appointment: return Color(red: 0.15, green: 0.35, blue: 0.75)
        case .pharmacy: return .orange
        case .labs: return .green
        case .cancellations: return .red
        }
    }

    private func iconBg(for category: AppNotificationCategory) -> Color {
        iconColor(for: category).opacity(0.12)
    }
}

#Preview {
    NotificationsPageView()
}
