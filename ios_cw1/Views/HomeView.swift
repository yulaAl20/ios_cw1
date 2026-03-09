//
//  HomeView.swift
//  ios_cw1
//
//  Created by Yulani Alwis on 2026-03-01.
//

import SwiftUI
import UIKit

struct HomeView: View {
    
    @State private var selectedTab: Int = 0
    @State private var animatePulse: Bool = false
    
    var body: some View {
        ZStack(alignment: .bottom) {
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
                    
                    Spacer()
                        .frame(height: 30) // content below header
                    
                    activeQueueCard
                    quickServicesSection
                    bookAppointmentCard
                    topDoctorsSection
                    
                    Spacer(minLength: 160)
                }
                .padding(.horizontal, 20)
            }
            
            
            // header - sticky
            HeaderView()
                .padding(.top, 0)
                .padding(.horizontal, 20)
                .padding(.bottom, 0.5)
                .background(Color.white)
        }
        .safeAreaInset(edge: .bottom) {
            VStack(spacing: 8) {
                DirectionsBarView()
                    .padding(.horizontal, 16)
                FloatingNavBarView(selectedTab: $selectedTab)
            }
        }
    }
}


extension HomeView {
    
    var activeQueueCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Your Turn in 10 minutes")
                        .font(.headline)
                    
                    Text("OPD Room 2\nCurrent Queue 3 of 17")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                
                Spacer()
                
                VStack {
                    Text("Queue no.")
                        .font(.subheadline)
                        .foregroundColor(.blue)
                    Text("#6")
                        .font(.title)
                        .bold()
                        .foregroundColor(.blue)
                }
            }
            
            HStack {
                Button("Leave Queue") {}
                    .font(.subheadline)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                    .background(Color(.systemGray5))
                    .cornerRadius(20)
                
                Spacer()
                
                Button("Reschedule") {}
                    .font(.subheadline)
                    .foregroundColor(.white)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 8)
                    .background(Color.blue)
                    .cornerRadius(20)
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(24)
        .shadow(radius: 4)
        .offset(y: 6)
    }
    
    var bookAppointmentCard: some View {
        VStack(spacing: 12) {
            
            Button(action: {}) {
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
            .scaleEffect(animatePulse ? 1.02 : 1.0)
            .animation(.easeInOut(duration: 1.2).repeatForever(autoreverses: true), value: animatePulse)
            
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
                quickServiceItem(icon: "stethoscope", title: "Find\nDoctor", color: .blue)
                quickServiceItem(icon: "cross.case.fill", title: "Lab\nReports", color: .green)
                quickServiceItem(icon: "pills.fill", title: "Pharmacy", color: .orange)
                quickServiceItem(icon: "waveform.path.ecg", title: "Scans", color: .purple)
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
                    doctorCard
                    doctorCard
                }
            }
        }
    }
    
    var doctorCard: some View {
        VStack(alignment: .leading, spacing: 8) {
            
            ZStack(alignment: .topLeading) {
                //  image doctor
                if UIImage(named: "doctor_placeholder") != nil {
                    Image("doctor_placeholder")
                        .resizable()
                        .scaledToFill()
                        .frame(width: 220, height: 220)
                        .clipped()
                        .cornerRadius(24)
                } else {
                    RoundedRectangle(cornerRadius: 24)
                        .fill(Color(#colorLiteral(red: 0.88, green: 0.94, blue: 0.98, alpha: 1)))
                        .frame(width: 220, height: 220)
                        .overlay(
                            Image(systemName: "person.fill")
                                .font(.system(size: 60))
                                .foregroundColor(Color(#colorLiteral(red: 0.36, green: 0.62, blue: 0.86, alpha: 1)))
                        )
                }
                
                Text("⭐ 5.0")
                    .font(.caption)
                    .padding(6)
                    .background(Color.white.opacity(0.9))
                    .cornerRadius(10)
                    .padding(8)
            }
            
            Text("Dr. Emma Wilson")
                .font(.headline)
            
            Text("Neurologist")
                .font(.subheadline)
                .foregroundColor(.gray)
        }
        .frame(width: 220)
    }
}


#Preview {
    HomeView()
}
