//
//  ReviewsView.swift
//  ios_cw1
//
//  Created by COBSCCOMP242P-74 on 2026-03-04.
//

import SwiftUI

struct ReviewsView: View {
    let doctor: Doctor
    let reviews: [Review]

    @Environment(\.dismiss) private var dismiss

    var body: some View {
        VStack(spacing: 0) {
            // Top bar
            HStack {
                Button(action: { dismiss() }) {
                    Image(systemName: "chevron.left")
                        .font(.title2)
                        .foregroundColor(.primary)
                }
                Spacer()
                Text("Reviews")
                    .font(.headline)
                    .fontWeight(.semibold)
                Spacer()
                Color.clear.frame(width: 44, height: 44)
            }
            .padding(.horizontal, 24)
            .padding(.top, 16)
            .padding(.bottom, 8)

            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 24) {

                    HStack(spacing: 12) {

                        Group {
                            if let imageName = doctor.imageName, let uiImage = UIImage(named: imageName) {
                                Image(uiImage: uiImage)
                                    .resizable()
                                    .scaledToFill()
                            } else {
                                Image(systemName: "person.fill")
                                    .resizable()
                                    .scaledToFit()
                                    .foregroundStyle(.blue)
                                    .background(Color.blue.opacity(0.15))
                            }
                        }
                        .frame(width: 48, height: 48)
                        .clipShape(Circle())

                        VStack(alignment: .leading, spacing: 2) {
                            Text(doctor.fullName)
                                .font(.headline)
                            Text(doctor.specialty)
                                .font(.subheadline)
                                .foregroundStyle(.gray)
                        }

                        Spacer()

                        HStack(spacing: 4) {
                            Image(systemName: "star.fill")
                                .foregroundColor(.yellow)
                            Text(String(format: "%.1f", doctor.rating))
                                .font(.headline)
                        }
                    }
                    .padding(.horizontal, 24)

                    Text("Reviews (\(doctor.reviews))")
                        .font(.title3)
                        .fontWeight(.semibold)
                        .padding(.horizontal, 24)

                    VStack(spacing: 20) {
                        ForEach(reviews) { review in
                            ReviewCard(review: review)
                        }
                    }
                    .padding(.horizontal, 24)

                    Spacer(minLength: 40)
                }
                .padding(.top, 8)
            }
        }
        .navigationBarHidden(true)
    }
}

struct ReviewCard: View {
    let review: Review

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(review.author)
                        .font(.headline)
                    Text(review.date)
                        .font(.caption)
                        .foregroundColor(.gray)
                }
                Spacer()
                HStack(spacing: 4) {
                    Image(systemName: "star.fill")
                        .foregroundColor(.yellow)
                        .font(.caption)
                    Text(String(format: "%.1f", review.rating))
                        .font(.subheadline)
                        .fontWeight(.medium)
                }
            }

            Text(review.comment)
                .font(.body)
                .foregroundColor(.gray)
                .lineLimit(4)
                .multilineTextAlignment(.leading)
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(16)
    }
}

#Preview {
    NavigationStack {
        ReviewsView(
            doctor: MockData.doctors[0],
            reviews: MockData.sampleReviews
        )
    }
}
