//
//  HomeView.swift
//  ios_cw1
//
//  Created by Yulani Alwis on 2026-03-01.
//

import SwiftUI

struct HomeView: View {
    
    @State private var selectedTab: Int = 0
    
    var body: some View {
        ZStack {
            Color(.systemGroupedBackground)
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                
                ScrollView(showsIndicators: false) {
                    
                    VStack(alignment: .leading, spacing: 24) {
                        
                        headerSection
                        
                        activeQueueCard
                        
                        bookAppointmentCard
                        
                        quickServicesSection
                        
                        topDoctorsSection
                        
                        Spacer(minLength: 160)
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 10)
                }

                Spacer(minLength: 0)
            }

            // Fixed bottom overlays
            VStack(spacing: 0) {
                Spacer()
                directionsBar
                floatingNavBar
            }
        }
    }
}


extension HomeView {
    
    var headerSection: some View {
        HStack(spacing: 12) {
            
            Image(systemName: "person.circle")
                .font(.system(size: 28))
            
            HStack {
                Image(systemName: "magnifyingglass")
                Text("Search")
                    .foregroundColor(.gray)
                Spacer()
                Image(systemName: "mic.fill")
                    .foregroundColor(.gray)
            }
            .padding(10)
            .background(Color(.systemGray6))
            .cornerRadius(20)
            
            Image(systemName: "bell")
                .font(.system(size: 20))
        }
    }
    
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
    }
    
    var bookAppointmentCard: some View {
        VStack(spacing: 12) {
            
            Button(action: {}) {
                Text("Book Appointment")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
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
            
            HStack(spacing: 16) {
                quickServiceItem(icon: "cross.case.fill", title: "Lab Reports", color: .green)
                quickServiceItem(icon: "pills.fill", title: "Pharmacy", color: .orange)
                quickServiceItem(icon: "waveform.path.ecg", title: "Scans / X-Ray", color: .purple)
            }
        }
    }
    
    func quickServiceItem(icon: String, title: String, color: Color) -> some View {
        VStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 24))
                .foregroundColor(color)
                .padding()
                .background(color.opacity(0.1))
                .cornerRadius(16)
            
            Text(title)
                .font(.caption)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color.white)
        .cornerRadius(20)
        .shadow(radius: 3)
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
                
                Image("doctor_placeholder")
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
            
            Text("Dr. Emma Wilson")
                .font(.headline)
            
            Text("Neurologist")
                .font(.subheadline)
                .foregroundColor(.gray)
        }
        .frame(width: 220)
    }
}

// MARK: - Fixed Bottom Overlays
extension HomeView {

    // Dark "Need directions?" bar — fixed, not scrolling
    var directionsBar: some View {
        HStack(spacing: 12) {
            Image(systemName: "paperplane.fill")
                .font(.system(size: 18))
                .foregroundColor(.white)
                .padding(10)
                .background(Color.blue)
                .clipShape(Circle())

            VStack(alignment: .leading, spacing: 1) {
                Text("Need directions?")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.white)
                Text("Find your way inside the clinic")
                    .font(.system(size: 11))
                    .foregroundColor(.white.opacity(0.6))
            }

            Spacer()

            Image(systemName: "arrow.right")
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(.white.opacity(0.7))
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(Color.black.opacity(0.85))
        .cornerRadius(20)
        .padding(.horizontal, 16)
        .padding(.bottom, 2)
    }

    // Floating glass nav bar — near phone edge
    var floatingNavBar: some View {
        HStack(spacing: 0) {
            navItem(icon: "house.fill", label: "Home", index: 0)
            navItem(icon: "square.grid.2x2.fill", label: "Services", index: 1)
            navItem(icon: "calendar", label: "Appointments", index: 2)
            navItem(icon: "location.fill", label: "Navigation", index: 3)
        }
        .padding(.horizontal, 16)
        .padding(.top, 10)
        .padding(.bottom, 6)
        .background(
            .ultraThinMaterial,
            in: RoundedRectangle(cornerRadius: 30)
        )
        .shadow(color: Color.black.opacity(0.12), radius: 20, x: 0, y: 4)
        .padding(.horizontal, 8)
        .padding(.bottom, 2)
    }

    func navItem(icon: String, label: String, index: Int) -> some View {
        let isSelected: Bool = selectedTab == index
        return Button {
            selectedTab = index
        } label: {
            VStack(spacing: 3) {
                Image(systemName: icon)
                    .font(.system(size: 20))
                    .foregroundColor(isSelected ? .blue : .gray)
                Text(label)
                    .font(.system(size: 9, weight: isSelected ? .semibold : .regular))
                    .foregroundColor(isSelected ? .blue : .gray)
            }
            .frame(maxWidth: .infinity)
        }
    }
}

#Preview {
    HomeView()
}
