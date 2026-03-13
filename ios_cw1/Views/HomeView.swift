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
    @EnvironmentObject var flowViewModel: AppointmentFlowViewModel
    @State private var animatePulse: Bool = false
    @State private var showProgressSheet: Bool = false

    var body: some View {
        NavigationStack {
            ZStack(alignment: .top) {

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

                ScrollView(showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 24) {
                        Color.clear.frame(height: 120)

                        activeQueueCard
                        quickServicesSection
                        bookAppointmentCard
                        topDoctorsSection

                        Spacer(minLength: 160)
                    }
                    .padding(.horizontal, 20)
                }

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
            .sheet(isPresented: $showProgressSheet) {
                AppointmentProgressView()
                    .environmentObject(flowViewModel)
                    .environmentObject(AppointmentStore())
            }
            .onAppear {
                if !animatePulse {
                    withAnimation(.easeInOut(duration: 1.4).repeatForever(autoreverses: true)) {
                        animatePulse = true
                    }
                }
                if flowViewModel.currentStage == .inQueue {
                    flowViewModel.startQueueTimer()
                }
            }
        }
    }
}

extension HomeView {

    var activeQueueCard: some View {
        Button(action: {
            showProgressSheet = true
        }) {
            ZStack {
                RoundedRectangle(cornerRadius: 24)
                    .fill(
                        LinearGradient(
                    colors: [
                                Color(hex: flowViewModel.stageColor[0]),
                                Color(hex: flowViewModel.stageColor[1])
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .shadow(color: Color(hex: flowViewModel.stageColor[0]).opacity(0.4), radius: 12, x: 0, y: 6)

                VStack(alignment: .leading, spacing: 0) {
                    queueCardContent
                }
                .padding(18)
            }
            .offset(y: 6)
        }
        .buttonStyle(.plain)
    }

    @ViewBuilder
    private var queueCardContent: some View {
        switch flowViewModel.currentStage {
        case .inQueue:
            inQueueCardBody
        case .withDoctor:
            withDoctorCardBody
        case .labQueue:
            labQueueCardBody
        case .labOngoing:
            labOngoingCardBody
        case .pharmacyPickup:
            pharmacyCardBody
        case .done:
    doneCardBody
        }
    }

    private var inQueueCardBody: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 6) {
                    Label("In Queue", systemImage: "clock.fill")
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundColor(.white.opacity(0.75))
                        .labelStyle(.titleAndIcon)

                    Text("Your turn in \(flowViewModel.estimatedWaitText)")
                        .font(.system(size: 17, weight: .bold))
                        .foregroundColor(.white)

                    Text(flowViewModel.doctorLocation)
                        .font(.subheadline)
                        .foregroundColor(.white.opacity(0.8))

                    Text("Queue \(flowViewModel.queuePosition) of \(flowViewModel.totalInQueue)")
                        .font(.subheadline)
                        .foregroundColor(.white.opacity(0.7))
                }

                Spacer()

                VStack(spacing: 4) {
                    Text("Token")
                        .font(.system(size: 11, weight: .semibold))
                        .foregroundColor(.white.opacity(0.75))
                    Text("#\(flowViewModel.token)")
                        .font(.system(size: 28, weight: .bold))
                        .foregroundColor(.white)
                }
                .padding(.horizontal, 14)
                .padding(.vertical, 10)
                .background(Color.white.opacity(0.15))
                .cornerRadius(14)
            }

            timerProgressBar
        }
    }

    private var timerProgressBar: some View {
        let initial = max(1, flowViewModel.queuePosition * 4 * 60)
        let progress = max(0.0, min(1.0, Double(flowViewModel.timerSecondsRemaining) / Double(initial)))
        return GeometryReader { geo in
            ZStack(alignment: .leading) {
                Capsule()
                    .fill(Color.white.opacity(0.2))
                    .frame(height: 5)
                Capsule()
                    .fill(Color.white.opacity(0.85))
                    .frame(width: geo.size.width * progress, height: 5)
                    .animation(.linear(duration: 1.0), value: progress)
            }
        }
        .frame(height: 5)
    }

    private var withDoctorCardBody: some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading, spacing: 6) {
                Label("Appointment in Progress", systemImage: "stethoscope")
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundColor(.white.opacity(0.75))

                Text("Currently with")
                    .font(.subheadline)
                    .foregroundColor(.white.opacity(0.8))

                Text(flowViewModel.doctorName)
                    .font(.system(size: 17, weight: .bold))
                    .foregroundColor(.white)

                Text(flowViewModel.doctorLocation)
                    .font(.subheadline)
                    .foregroundColor(.white.opacity(0.7))
            }

            Spacer()

            ZStack {
                Circle()
                    .fill(Color.white.opacity(0.15))
                    .frame(width: 54, height: 54)
                    .scaleEffect(animatePulse ? 1.15 : 1.0)

                Image(systemName: "stethoscope")
                    .font(.system(size: 24, weight: .semibold))
                    .foregroundColor(.white)
            }
        }
    }

    private var labQueueCardBody: some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading, spacing: 6) {
                Label("Lab Test Queued", systemImage: "flask.fill")
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundColor(.white.opacity(0.75))

                Text("Head to Lab")
                    .font(.system(size: 17, weight: .bold))
                    .foregroundColor(.white)

                Text(flowViewModel.labLocation)
                    .font(.subheadline)
                    .foregroundColor(.white.opacity(0.8))

                Text("Queue \(flowViewModel.labQueuePosition) of \(flowViewModel.labTotalInQueue)")
                    .font(.subheadline)
                    .foregroundColor(.white.opacity(0.7))
            }

            Spacer()

            VStack(spacing: 4) {
                Text("Position")
                    .font(.system(size: 11, weight: .semibold))
                    .foregroundColor(.white.opacity(0.75))
                Text("#\(flowViewModel.labQueuePosition)")
                    .font(.system(size: 28, weight: .bold))
                    .foregroundColor(.white)
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 10)
            .background(Color.white.opacity(0.15))
            .cornerRadius(14)
        }
    }

    private var labOngoingCardBody: some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading, spacing: 6) {
                Label("Lab Test In Progress", systemImage: "waveform.path.ecg")
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundColor(.white.opacity(0.75))

                Text("Your test is underway")
                    .font(.system(size: 17, weight: .bold))
                    .foregroundColor(.white)

                Text(flowViewModel.labLocation)
                    .font(.subheadline)
                    .foregroundColor(.white.opacity(0.8))

                Text("Please wait nearby for results")
                    .font(.subheadline)
                    .foregroundColor(.white.opacity(0.7))
            }

            Spacer()

            ZStack {
                Circle()
                    .fill(Color.white.opacity(0.15))
                    .frame(width: 54, height: 54)
                    .scaleEffect(animatePulse ? 1.12 : 1.0)

                Image(systemName: "waveform.path.ecg")
                    .font(.system(size: 22))
                    .foregroundColor(.white)
            }
        }
    }

    private var pharmacyCardBody: some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading, spacing: 6) {
                Label("Collect Medicine", systemImage: "pills.fill")
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundColor(.white.opacity(0.75))

                Text("Go to Pharmacy")
                    .font(.system(size: 17, weight: .bold))
                    .foregroundColor(.white)

                Text(flowViewModel.pharmacyLocation)
                    .font(.subheadline)
                    .foregroundColor(.white.opacity(0.8))

                Text("\(flowViewModel.medicines.count) item\(flowViewModel.medicines.count == 1 ? "" : "s") prescribed")
                    .font(.subheadline)
                    .foregroundColor(.white.opacity(0.7))
            }

            Spacer()

            ZStack {
                Circle()
                    .fill(Color.white.opacity(0.15))
                    .frame(width: 54, height: 54)

                Image(systemName: "pills.fill")
                    .font(.system(size: 24))
                    .foregroundColor(.white)
            }
        }
    }

    private var doneCardBody: some View {
        HStack(alignment: .center, spacing: 16) {
            Image(systemName: "checkmark.seal.fill")
                .font(.system(size: 36))
                .foregroundColor(.white)

            VStack(alignment: .leading, spacing: 4) {
                Text("All Done Today!")
                    .font(.system(size: 17, weight: .bold))
                    .foregroundColor(.white)
                Text("Your visit is complete. Take care!")
                    .font(.subheadline)
                    .foregroundColor(.white.opacity(0.8))
            }

            Spacer()
        }
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
                        LinearGradient(
                            colors: [
                                Color(#colorLiteral(red: 0.0, green: 0.48, blue: 0.78, alpha: 1)),
                                Color(#colorLiteral(red: 0.09, green: 0.59, blue: 0.83, alpha: 1))
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
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
                NavigationLink(destination: ChooseDoctorView(selectedTab: $router.currentTab)) {
                    quickServiceItem(icon: "stethoscope", title: "Find\nDoctor", color: .blue)
                }
                .buttonStyle(.plain)

                NavigationLink(destination: PastTestsAndOrdersView()) {
                    quickServiceItem(icon: "cross.case.fill", title: "Lab\nReports", color: .green)
                }
                .buttonStyle(.plain)

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

                NavigationLink(destination: PastTestsAndOrdersView(initialFilter: .radiology)) {
                    quickServiceItem(icon: "waveform.path.ecg", title: "Scans", color: .purple)
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
                    doctorCard(image: "doctor1", name: "Dr. Emma Wilson", specialty: "Neurologist")
                    doctorCard(image: "jenny_wilson", name: "Dr. Michael Lee", specialty: "Cardiologist")
                    doctorCard(image: "doctor3", name: "Dr. Sarah Parker", specialty: "Dermatologist")
                }
            }
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

            Text(name).font(.headline)
            Text(specialty).font(.subheadline).foregroundColor(.gray)
        }
        .frame(width: 220)
    }
}

#Preview {
    let store = AppointmentStore()
    let flow = AppointmentFlowViewModel(appointmentStore: store)
    return HomeView()
        .environmentObject(AppRouter())
        .environmentObject(store)
        .environmentObject(flow)
}
