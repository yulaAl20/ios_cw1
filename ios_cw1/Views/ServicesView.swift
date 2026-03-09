//
//  ServicesView.swift
//  ios_cw1
//
//  Created by Yulani Alwis on 2026-03-04.
//

import SwiftUI

struct ServicesView: View {
    
    @State private var selectedTab: Int = 1  // Services tab selected
    
    private let queueNumber: Int = 15
    private let queueTime: String = "9.15 AM"
    
    private let clinicServices: [ClinicService] = [
        ClinicService(
            icon: "link",
            title: "Pharmacy",
            subtitle: "Medicines & prescriptions",
            iconColorRed: 0.38, iconColorGreen: 0.35, iconColorBlue: 0.85,
            bgColorRed: 0.91, bgColorGreen: 0.90, bgColorBlue: 1.0
        ),
        ClinicService(
            icon: "viewfinder",
            title: "Image Scanning",
            subtitle: "X-Ray, MRI, CT Scan",
            iconColorRed: 0.0, iconColorGreen: 0.48, iconColorBlue: 0.78,
            bgColorRed: 0.88, bgColorGreen: 0.94, bgColorBlue: 0.98
        ),
        ClinicService(
            icon: "drop.fill",
            title: "Blood Tests",
            subtitle: "CBC, Lipid Profile",
            iconColorRed: 0.85, iconColorGreen: 0.25, iconColorBlue: 0.25,
            bgColorRed: 1.0, bgColorGreen: 0.91, bgColorBlue: 0.91
        ),
        ClinicService(
            icon: "waveform.path.ecg",
            title: "Other Tests",
            subtitle: "Urine, Stool, Swabs",
            iconColorRed: 0.85, iconColorGreen: 0.65, iconColorBlue: 0.15,
            bgColorRed: 1.0, bgColorGreen: 0.96, bgColorBlue: 0.88
        )
    ]
    
    var body: some View {
        ZStack(alignment: .top) {
            
            // Background
            Color(red: 0.90, green: 0.93, blue: 0.98)
                .ignoresSafeArea()
            
            // SCROLLABLE CONTENT
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 20) {
                    
                    Spacer().frame(height: 110) // space for sticky header
                    
                    // Quick Action – Book a Test / Lab
                    quickActionCard
                    
                    // Clinic Services grid
                    clinicServicesSection
                    
                    Spacer(minLength: 120)
                }
                .padding(.horizontal, 20)
            }
            
            // Sticky header area (notification bar + header)
            /*VStack(spacing: 0) {
                
                HeaderView(title: "ClinicFlow Services", searchPlaceholder: "Search Labs/Scans")
                    .padding(.horizontal, 20)
                    .padding(.bottom, 8)
            }*/
            .background(Color(red: 0.82, green: 0.88, blue: 0.96))
        }
        .safeAreaInset(edge: .bottom) {
            FloatingNavBarView(selectedTab: $selectedTab)
        }
    }
}





// Quick Action Card

extension ServicesView {
    
    var quickActionCard: some View {
        ZStack(alignment: .bottomTrailing) {
            // Card background
            RoundedRectangle(cornerRadius: 20)
                .fill(
                    LinearGradient(
                        colors: [
                            Color(red: 0.15, green: 0.35, blue: 0.75),
                            Color(red: 0.25, green: 0.50, blue: 0.88)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
            
            // Decorative microscope icon
            Image(systemName: "microscope")
                .font(.system(size: 80))
                .foregroundColor(.white.opacity(0.15))
                .padding(.trailing, 20)
                .padding(.bottom, 10)
            
            // Dashed border
            RoundedRectangle(cornerRadius: 20)
                .strokeBorder(style: StrokeStyle(lineWidth: 1.5, dash: [6, 4]))
                .foregroundColor(.white.opacity(0.3))
            
            // Content
            VStack(alignment: .leading, spacing: 12) {
                Text("QUICK ACTION")
                    .font(.system(size: 11, weight: .semibold))
                    .foregroundColor(.white.opacity(0.8))
                    .tracking(1.5)
                
                Text("Book a Test / Lab")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(.white)
                
                Button(action: {}) {
                    HStack(spacing: 6) {
                        Image(systemName: "calendar.badge.clock")
                            .font(.system(size: 14))
                        Text("Book Now")
                            .font(.system(size: 14, weight: .semibold))
                    }
                    .foregroundColor(Color(red: 0.15, green: 0.35, blue: 0.75))
                    .padding(.horizontal, 18)
                    .padding(.vertical, 10)
                    .background(Color.white)
                    .cornerRadius(14)
                }
            }
            .padding(20)
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .frame(height: 170)
    }
}


// Clinic Services

extension ServicesView {
    
    var clinicServicesSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Clinic Services")
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(.black)
            
            // 2-column grid
            LazyVGrid(
                columns: [
                    GridItem(.flexible(), spacing: 16),
                    GridItem(.flexible(), spacing: 16)
                ],
                spacing: 16
            ) {
                ForEach(clinicServices) { service in
                    serviceCard(service)
                }
            }
        }
    }
    
    func serviceCard(_ service: ClinicService) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            // Icon circle
            ZStack {
                Circle()
                    .fill(service.iconBackground)
                    .frame(width: 50, height: 50)
                
                Image(systemName: service.icon)
                    .font(.system(size: 22))
                    .foregroundColor(service.iconColor)
            }
            
            Text(service.title)
                .font(.system(size: 16, weight: .bold))
                .foregroundColor(.black)
            
            Text(service.subtitle)
                .font(.system(size: 12))
                .foregroundColor(.gray)
                .lineLimit(2)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(16)
        .background(Color.white)
        .cornerRadius(20)
        .shadow(color: .black.opacity(0.04), radius: 8, x: 0, y: 4)
    }
}


#Preview("Services Screen") {
    ServicesView()
        .preferredColorScheme(.light)
}
