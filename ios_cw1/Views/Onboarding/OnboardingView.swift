//
//  OnboardingView.swift
//  ios_cw1
//
//  Created by COBSCCOMP242P-74 on 2026-03-07.
//

import SwiftUI

struct OnboardingView: View {
    @AppStorage("hasSeenOnboarding") private var hasSeenOnboarding = false
    @State private var currentPage = 0

    let pages: [OnboardingPage] = [
        OnboardingPage(
            layout: .first,
            title: "Welcome to Clinic Flow",
            description: "Navigate your clinic visit with ease.\nTrack your progress, find your way, and never miss your turn.",
            imageName: "stethoscope"
        ),
        OnboardingPage(
            layout: .second,
            title: "welcome to clinic flow",
            description: "“No more guessing your turn.”\nTrack your queue in real time.",
            imageName: "image1"
        ),
        OnboardingPage(
            layout: .third,
            title: "welcome to clinic flow",
            description: "“Feel in control of your clinic journey.”\nReal-time updates. Clear directions. Zero confusion.",
            imageName: "image2"
        )
    ]

    var body: some View {
        ZStack {
            Color(.systemBackground).ignoresSafeArea()

            VStack(spacing: 0) {
                // Skip button
                HStack {
                    Spacer()
                    Button("Skip") {
                        hasSeenOnboarding = true
                    }
                    .font(.body)
                    .foregroundColor(.blue)
                    .padding(.horizontal, 24)
                    .padding(.top, 16)
                }

                // Main content
                TabView(selection: $currentPage) {
                    ForEach(0..<pages.count, id: \.self) { index in
                        OnboardingPageView(page: pages[index])
                            .tag(index)
                    }
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
                .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .always))
                .padding(.bottom)
                
                Button(action: {
                    if currentPage == pages.count - 1 {
                        hasSeenOnboarding = true
                    } else {
                        withAnimation {
                            currentPage += 1
                        }
                    }
                }) {
                    Text(currentPage == pages.count - 1 ? "Get Started" : "Next")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(16)
                        .padding(.horizontal, 24)
                }
                .padding(.bottom, 40)
            }
        }
    }
}


enum OnboardingLayout {
    case first, second, third
}


struct OnboardingPage {
    let layout: OnboardingLayout
    let title: String
    let description: String
    let imageName: String
}


struct OnboardingPageView: View {
    let page: OnboardingPage

    var body: some View {
        switch page.layout {
        case .first:
            firstPage
        case .second:
            secondPage
        case .third:
            thirdPage
        }
    }

    // First page
    private var firstPage: some View {
        VStack(spacing: 24) {
            Spacer(minLength: 20)

            VStack(spacing: 0) {
                Text("Welcome to")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                Text("Clinic Flow")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(Color(red: 0.2, green: 0.4, blue: 0.7))
            }
            .multilineTextAlignment(.center)

            ZStack {
                HeartbeatShape()
                    .stroke(Color.blue.opacity(0.4), lineWidth: 2)
                    .frame(width: 200, height: 50)

                Image(systemName: "stethoscope")
                    .font(.system(size: 60))
                    .foregroundColor(Color(red: 0.2, green: 0.4, blue: 0.7))
            }
            .padding(.vertical, 10)

            Text(page.description)
                .font(.body)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 32)

            Spacer()
        }
        .padding(.top, 10)
    }

    // Second page
    private var secondPage: some View {
        VStack(spacing: 20) {
            Spacer(minLength: 10)

            Image(systemName: "stethoscope")
                .font(.system(size: 40))
                .foregroundColor(Color(red: 0.2, green: 0.4, blue: 0.7))

            Text(page.title.capitalized)
                .font(.title2)
                .fontWeight(.semibold)
                .multilineTextAlignment(.center)

            Image(page.imageName)
                .resizable()
                .scaledToFit()
                .frame(height: 280)
                .padding(.vertical, 8)

            Text(page.description)
                .font(.body)
                .foregroundColor(.primary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 32)

            Spacer()
        }
        .padding(.top, 5)
    }

    // Third page
    private var thirdPage: some View {
        secondPage
    }
}

#Preview {
    OnboardingView()
}
