//
//  HomeView.swift
//  ios_cw1
//
//  Created by Yulani Alwis on 2026-03-01.
//

import SwiftUI
import UIKit

struct HomeView: View {
    
    @EnvironmentObject var router: AppRouter
    @State private var animatePulse: Bool = false
    
    var body: some View {
        NavigationStack {
            ZStack(alignment: .top) {
                
                // Background
                VStack(spacing: 0) {
                    Color(.systemGroupedBackground)
                    
                    LinearGradient(
                        colors: [
                            Color.blue.opacity(0.35),
                            Color.blue.opacity(0.20)
                        ],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                    .frame(height: 420)
                    .clipShape(
                        RoundedCorner(radius: 40,
                                      corners: [.topLeft, .topRight])
                    )
                }
                .ignoresSafeArea()
                
                
                // SCROLLABLE CONTENT
                ScrollView(showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 24) {
                        
                        // Space for header (header height + safe area + padding)
                        Color.clear
                            .frame(height: 120)
                        
                        activeQueueCard
                        quickServicesSection
                        bookAppointmentCard
                        topDoctorsSection
                        
                        Spacer(minLength: 160)
                    }
                    .padding(.horizontal, 20)
                }
                
                
                // header - sticky at top with safe area
                VStack(spacing: 0) {
                    HeaderView(title: "Clinic Flow")
                        .padding(.horizontal, 20)
                        .padding(.bottom, 10)
                }
                .background(Color.white)
            }
            .safeAreaInset(edge: .bottom) {
                VStack(spacing: 8) {
                    DirectionsBarView()
                        .padding(.horizontal, 16)
                    FloatingNavBarView(selectedTab: $router.currentTab)
                }
            }
            .navigationBarHidden(true)
        }
    }
}


extension HomeView {
    
    var activeQueueCard: some View {
        Button(action: {
            router.appointmentsInitialTab = "Ongoing"
            router.currentTab = 2
        }) {
            VStack(alignment: .leading, spacing: 14) {
                
                HStack(alignment: .top) {
                    VStack(alignment: .leading, spacing: 6) {
                        Text("Your Turn in 10 minutes")
                            .font(.system(size: 17, weight: .semibold))
                            .foregroundColor(.primary)
                        
                        Text("OPD Room 2")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                        
                        Text("Current Queue 3 of 17")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                    
                    Spacer()
                    
                    VStack(spacing: 4) {
                        Text("Queue no.")
                            .font(.system(size: 13))
                            .foregroundColor(.blue)
                        Text("#6")
                            .font(.system(size: 28, weight: .bold))
                            .foregroundColor(.blue)
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 10)
                    .background(Color.blue.opacity(0.08))
                    .cornerRadius(14)
                }
            }
            .padding(18)
            .background(Color.white)
            .cornerRadius(24)
            .shadow(color: .black.opacity(0.06), radius: 8, x: 0, y: 4)
            .offset(y: 6)
        }
        .buttonStyle(.plain)
    }
    
    var bookAppointmentCard: some View {
        VStack(spacing: 12) {
            NavigationLink(destination: ChooseDoctorView(selectedTab: $router.currentTab)) {
                Text("Book Appointment")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(
                        LinearGradient(colors: [Color(#colorLiteral(red: 0.0, green: 0.48, blue: 0.78, alpha: 1)), Color(#colorLiteral(red: 0.09, green: 0.59, blue: 0.83, alpha: 1))], startPoint: .topLeading, endPoint: .bottomTrailing)
                    )
                    .cornerRadius(20)
            }
            

            Text("Find a doctor and schedule your visit instantly")
                .font(.subheadline)
                .foregroundColor(.gray)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(24)
        .shadow(radius: 4)
    }
    
    var quickServicesSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            
            Text("Quick Services")
                .font(.headline)
            
            HStack(spacing: 0) {
                // Find Doctor
                NavigationLink(destination: ChooseDoctorView(selectedTab: $router.currentTab)) {
                    VStack(spacing: 6) {
                        ZStack {
                            Circle()
                                .fill(Color.blue.opacity(0.12))
                                .frame(width: 50, height: 50)
                            Image(systemName: "stethoscope")
                                .font(.system(size: 20))
                                .foregroundColor(.blue)
                        }
                        Text("Find\nDoctor")
                            .font(.system(size: 10))
                            .foregroundColor(.gray)
                            .multilineTextAlignment(.center)
                            .lineLimit(2)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                    .frame(maxWidth: .infinity)
                }
                .buttonStyle(.plain)
                
                // Lab Reports
                NavigationLink(destination: PastTestsAndOrdersView()) {
                    VStack(spacing: 6) {
                        ZStack {
                            Circle()
                                .fill(Color.green.opacity(0.12))
                                .frame(width: 50, height: 50)
                            Image(systemName: "cross.case.fill")
                                .font(.system(size: 20))
                                .foregroundColor(.green)
                        }
                        Text("Lab\nReports")
                            .font(.system(size: 10))
                            .foregroundColor(.gray)
                            .multilineTextAlignment(.center)
                            .lineLimit(2)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                    .frame(maxWidth: .infinity)
                }
                .buttonStyle(.plain)
                
                // Pharmacy
                NavigationLink(destination: PharmacyView()) {
                    VStack(spacing: 6) {
                        ZStack {
                            Circle()
                                .fill(Color.orange.opacity(0.12))
                                .frame(width: 50, height: 50)
                            Image(systemName: "pills.fill")
                                .font(.system(size: 20))
                                .foregroundColor(.orange)
                        }
                        Text("Pharmacy")
                            .font(.system(size: 10))
                            .foregroundColor(.gray)
                            .multilineTextAlignment(.center)
                            .lineLimit(2)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                    .frame(maxWidth: .infinity)
                }
                .buttonStyle(.plain)
                
                // Scans
                NavigationLink(destination: PastTestsAndOrdersView(initialFilter: .radiology)) {
                    VStack(spacing: 6) {
                        ZStack {
                            Circle()
                                .fill(Color.purple.opacity(0.12))
                                .frame(width: 50, height: 50)
                            Image(systemName: "waveform.path.ecg")
                                .font(.system(size: 20))
                                .foregroundColor(.purple)
                        }
                        Text("Scans")
                            .font(.system(size: 10))
                            .foregroundColor(.gray)
                            .multilineTextAlignment(.center)
                            .lineLimit(2)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                    .frame(maxWidth: .infinity)
                }
                .buttonStyle(.plain)
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 24)
                .fill(Color.white)
        )
        .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 4)
    
    }
    
    func quickServiceItem(icon: String, title: String, color: Color) -> some View {
        VStack(spacing: 6) {
            ZStack {
                Circle()
                    .fill(color.opacity(0.12))
                    .frame(width: 50, height: 50)
                
                Image(systemName: icon)
                    .font(.system(size: 20))
                    .foregroundColor(color)
            }
            
            Text(title)
                .font(.system(size: 10))
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
                .lineLimit(2)
                .fixedSize(horizontal: false, vertical: true)
        }
        .frame(maxWidth: .infinity)
    }
    
    var topDoctorsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            
            Text("Top Doctors")
                .font(.headline)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    
                    doctorCard(
                        image: "doctor1",
                        name: "Dr. Emma Wilson",
                        specialty: "Neurologist"
                    )
                    
                    doctorCard(
                        image: "jenny_wilson",
                        name: "Dr. Michael Lee",
                        specialty: "Cardiologist"
                    )
                    
                    doctorCard(
                        image: "doctor3",
                        name: "Dr. Sarah Parker",
                        specialty: "Dermatologist"
                    )
                }            }
        }
    }
    
    func doctorCard(image: String, name: String, specialty: String) -> some View {
        
        VStack(alignment: .leading, spacing: 8) {
            
            ZStack(alignment: .topLeading) {
                
                Image(image)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 220, height: 220)
                    .clipped()
                    .cornerRadius(24)
                
                Text("⭐ 5.0")
                    .font(.caption)
                    .padding(6)
                    .background(Color.white.opacity(0.9))
                    .cornerRadius(10)
                    .padding(8)
            }
            
            Text(name)
                .font(.headline)
            
            Text(specialty)
                .font(.subheadline)
                .foregroundColor(.gray)
        }
        .frame(width: 220)
    }
}


#Preview {
    HomeView()
        .environmentObject(AppRouter())
}
