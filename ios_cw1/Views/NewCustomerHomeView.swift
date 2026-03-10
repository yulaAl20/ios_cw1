//
//  NewCustomerHomeView.swift
//

import SwiftUI

struct NewCustomerHomeView: View {
    
    @State private var selectedTab: Int = 0
    @State private var animatePulse: Bool = false
    
    var body: some View {
        ZStack(alignment: .top) {
            
            //  Background
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
                    RoundedCorner(
                        radius: 40,
                        corners: [.topLeft, .topRight]
                    )
                )
            }
            .ignoresSafeArea()
            
            
            // Scrollable Content
            ScrollView(showsIndicators: false){
                VStack(spacing: 24) {
                    Spacer()
                        .frame(height: 100)
                    
                    quickServicesSection
                    bookAppointmentCard
                    topDoctorsSection
                    
                    Spacer(minLength: 20)
                }
                .padding(.horizontal, 20)
            }
            
            
            // Sticky Header
            HeaderView()
                .padding(.horizontal, 20)
                .padding(.bottom, 4)
                .background(Color.white)
        }
        .safeAreaInset(edge: .bottom) {
            VStack(spacing: 8) {
                DirectionsBarView()
                    .padding(.horizontal, 16)
                FloatingNavBarView(selectedTab: $selectedTab)
            }
        }
        .onAppear { animatePulse = true }
    }
}

// Quick Services
extension NewCustomerHomeView {
    
    var quickServicesSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            
            Text("Quick Services")
                .font(.headline)
            
            HStack(spacing: 0) {
                quickItem(icon: "stethoscope", title: "Doctor", color: .blue)
                quickItem(icon: "cross.case.fill", title: "Reports", color: .green)
                quickItem(icon: "pills.fill", title: "Pharmacy", color: .orange)
                quickItem(icon: "waveform.path.ecg", title: "Scans", color: .purple)
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(24)
        .shadow(color: .black.opacity(0.05), radius: 8, y: 4)
    }
    
    func quickItem(icon: String, title: String, color: Color) -> some View {
        VStack(spacing: 6) {
            Circle()
                .fill(color.opacity(0.15))
                .frame(width: 50, height: 50)
                .overlay(
                    Image(systemName: icon)
                        .foregroundColor(color)
                )
            
            Text(title)
                .font(.system(size: 11))
                .foregroundColor(.gray)
        }
        .frame(maxWidth: .infinity)
    }
}

// Book Appointment
extension NewCustomerHomeView {
    
    var bookAppointmentCard: some View {
        VStack(spacing: 12) {

            Button(action: {
          //      showBookingFlow = true
            }) {
                Text("Book Appointment")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(
                        LinearGradient(
                            colors: [Color.blue, Color.blue.opacity(0.8)],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
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
}

// Top Doctors
extension NewCustomerHomeView {
    
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
        VStack(alignment: .leading) {
            RoundedRectangle(cornerRadius: 24)
                .fill(Color.blue.opacity(0.15))
                .frame(width: 200, height: 200)
            
            Text("Dr. Emma Wilson")
                .font(.headline)
            
            Text("Neurologist")
                .font(.subheadline)
                .foregroundColor(.gray)
        }
        .frame(width: 200)
    }
}

#Preview {
    NewCustomerHomeView()
}
