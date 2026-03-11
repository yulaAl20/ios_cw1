//
//  AppointmentsView.swift
//  ios_cw1
//

import SwiftUI

struct AppointmentsView: View {
    
    @EnvironmentObject var router: AppRouter
    
    var body: some View {
        ZStack(alignment: .bottom) {
            Color(.systemGroupedBackground)
                .ignoresSafeArea()
            
            VStack(spacing: 24) {
                Spacer()
                
                Image(systemName: "calendar.badge.clock")
                    .font(.system(size: 64))
                    .foregroundColor(.blue.opacity(0.6))
                
                Text("Appointments")
                    .font(.title.bold())
                
                Text("Your upcoming appointments will appear here.")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
                
                Spacer()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .safeAreaInset(edge: .bottom) {
            VStack(spacing: 8) {
                DirectionsBarView()
                    .padding(.horizontal, 16)
                FloatingNavBarView(selectedTab: $router.currentTab)
            }
        }
    }
}

#Preview {
    AppointmentsView()
        .environmentObject(AppRouter())
}
