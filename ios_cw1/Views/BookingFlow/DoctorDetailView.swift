//
//  DoctorDetailView.swift
//  ios_cw1
//
//  Created by COBSCCOMP242P-74 on 2026-03-04.
//

import SwiftUI

struct DoctorDetailView: View {
    let doctor: Doctor
    var onFlowComplete: (() -> Void)? = nil 

    @Environment(\.dismiss) private var dismiss
    @State private var showFullProfile = false
    @State private var showReviews = false

    var body: some View {
        ZStack(alignment: .bottom) {
            ScrollView(showsIndicators: false) {
                VStack(spacing: 0) {
                    HStack {
                        Button(action: { dismiss() }) {
                            Image(systemName: "chevron.left")
                                .font(.title2)
                                .foregroundColor(.primary)
                        }
                        Spacer()
                        Button(action: { }) {
                            Image(systemName: "heart")
                                .font(.title3)
                                .foregroundColor(.primary)
                        }
                    }
                    .padding(.horizontal, 24)
                    .padding(.top, 20)
                    .padding(.bottom, 16)

                    DoctorHeader(doctor: doctor, onReviewsTapped: {
                        showReviews = true
                    })
                    .padding(.bottom, 12)

                    Button(action: {
                        showFullProfile = true
                    }) {
                        HStack {
                            Text("Read more about the doctor")
                                .font(.subheadline)
                                .fontWeight(.medium)
                                .foregroundColor(.primary)
                            Spacer()
                            Image(systemName: "chevron.right")
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                        .padding(.horizontal, 20)
                        .padding(.vertical, 14)
                        .background(
                            RoundedRectangle(cornerRadius: 14)
                                .fill(Color(.systemGray6))
                        )
                        .padding(.horizontal, 24)
                    }
                    .buttonStyle(PlainButtonStyle())
                    .padding(.bottom, 8)

                    HStack {
                        Text("Consultation Fee")
                            .font(.headline)
                            .foregroundColor(.gray)
                        Spacer()
                        Text(String(format: "%.2f LKR", doctor.fee))
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.blue)
                    }
                    .padding(.horizontal, 24)
                    .padding(.vertical, 20)
                    .background(
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Color.blue.opacity(0.06))
                    )
                    .padding(.horizontal, 24)
                    .padding(.top, 16)

                    // Peak time indicator
                    PeakTimeIndicator()
                        .padding(.horizontal, 24)
                        .padding(.top, 28)
                        .padding(.bottom, 40)

                    Spacer(minLength: 140)
                }
            }
            .background(Color(.systemBackground))

            VStack {
                NavigationLink(destination: BookingDateView(doctor: doctor, onFlowComplete: onFlowComplete)) {   // <-- Pass closure
                    Text("Book Appointment")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 18)
                        .background(Color.blue)
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                }
                .padding(.horizontal, 24)
                .padding(.vertical, 16)
                .background(Color(.systemBackground))
                .shadow(color: .black.opacity(0.1), radius: 12, y: -6)
            }
        }
        .navigationBarHidden(true)
        .sheet(isPresented: $showFullProfile) {
            FullDoctorProfileView(doctor: doctor)
        }
        .sheet(isPresented: $showReviews) {
            ReviewsView(
                doctor: doctor,
                reviews: MockData.sampleReviews
            )
        }
    }
}

#Preview {
    DoctorDetailView(doctor: MockData.doctors[0])
}
