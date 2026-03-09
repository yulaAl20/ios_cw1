//
//  NavigationARView.swift
//  ios_cw1
//
//  Created by Oshadha Samarasinghe on 2026-03-09.
//

import SwiftUI

struct NavigationARView: View {
    let route: NavigationRoute
    @Environment(\.dismiss) var dismiss
    @State private var animationOffset: CGFloat = 0
    @State private var scanLineOffset: CGFloat = 0
    @State private var pulseScale: CGFloat = 1.0
    
    var body: some View {
        ZStack {
            // Simulated Camera Background
            LinearGradient(
                gradient: Gradient(colors: [
                    Color.white,
                    Color(.systemGray6),
                    Color.white
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .overlay(
                // Grid pattern to simulate camera overlay
                GeometryReader { geo in
                    Path { path in
                        let spacing: CGFloat = 40
                        for i in stride(from: 0, to: geo.size.width, by: spacing) {
                            path.move(to: CGPoint(x: i, y: 0))
                            path.addLine(to: CGPoint(x: i, y: geo.size.height))
                        }
                        for i in stride(from: 0, to: geo.size.height, by: spacing) {
                            path.move(to: CGPoint(x: 0, y: i))
                            path.addLine(to: CGPoint(x: geo.size.width, y: i))
                        }
                    }
                    .stroke(Color.blue.opacity(0.1), lineWidth: 0.5)
                }
            )
            
            VStack {
                // Top AR HUD with navigation controls
                VStack(spacing: 8) {
                    HStack {
                        // Back Button
                        Button(action: {
                            dismiss()
                        }) {
                            HStack(spacing: 6) {
                                Image(systemName: "chevron.left")
                                    .font(.system(size: 14, weight: .semibold))
                                
                            }
                            .foregroundColor(.blue)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 8)
                            .background(Color.white)
                            .cornerRadius(20)
                            .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
                        }
                        
                        Spacer()
                        
                        // Floor Indicator
                        Text(route.floor)
                            .font(.system(size: 12, weight: .semibold))
                            .foregroundColor(.white)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(Color.blue)
                            .cornerRadius(20)
                            .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 60)
                    
                    // Scan Lines Animation
                    ZStack {
                        Rectangle()
                            .fill(
                                LinearGradient(
                                    gradient: Gradient(colors: [
                                        Color.blue.opacity(0),
                                        Color.blue.opacity(0.2),
                                        Color.blue.opacity(0)
                                    ]),
                                    startPoint: .top,
                                    endPoint: .bottom
                                )
                            )
                            .frame(height: 60)
                            .offset(y: scanLineOffset)
                    }
                    .frame(height: 100)
                    .clipped()
                }
                
                Spacer()
                
                // Center AR Directional Arrows
                VStack(spacing: 20) {
                    // Animated arrows pointing forward
                    VStack(spacing: -10) {
                        ForEach(0..<3, id: \.self) { index in
                            Image(systemName: "chevron.up")
                                .font(.system(size: 50, weight: .bold))
                                .foregroundColor(.blue)
                                .opacity(0.8 - Double(index) * 0.25)
                                .offset(y: animationOffset - CGFloat(index * 20))
                        }
                    }
                    .frame(height: 100)
                    
                    // Current Instruction Card
                    if let currentStep = route.steps.first {
                        VStack(spacing: 8) {
                            Text("STEP \(currentStep.stepNumber)")
                                .font(.system(size: 12, weight: .bold))
                                .foregroundColor(.blue)
                            
                            Text(currentStep.instruction)
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(.primary)
                                .multilineTextAlignment(.center)
                                .lineLimit(2)
                        }
                        .padding(.horizontal, 20)
                        .padding(.vertical, 16)
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .fill(Color.white)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 16)
                                        .stroke(Color.blue.opacity(0.3), lineWidth: 2)
                                )
                                .shadow(color: Color.black.opacity(0.1), radius: 8, x: 0, y: 4)
                        )
                        .padding(.horizontal, 30)
                    }
                }
                
                Spacer()
                
                // Bottom AR Info Panel
                VStack(spacing: 12) {
                    // Distance and Time Display
                    HStack(spacing: 40) {
                        // Distance
                        VStack(spacing: 4) {
                            HStack(spacing: 6) {
                                Image(systemName: "arrow.left.and.right")
                                    .font(.system(size: 14))
                                Text("DISTANCE")
                                    .font(.system(size: 10, weight: .bold))
                            }
                            .foregroundColor(.secondary)
                            
                            Text("\(route.distance)m")
                                .font(.system(size: 28, weight: .bold))
                                .foregroundColor(.primary)
                        }
                        
                        // Divider
                        Rectangle()
                            .fill(Color.gray.opacity(0.3))
                            .frame(width: 1, height: 50)
                        
                        // Time
                        VStack(spacing: 4) {
                            HStack(spacing: 6) {
                                Image(systemName: "clock")
                                    .font(.system(size: 14))
                                Text("ETA")
                                    .font(.system(size: 10, weight: .bold))
                            }
                            .foregroundColor(.secondary)
                            
                            Text("\(route.estimatedTime) min")
                                .font(.system(size: 28, weight: .bold))
                                .foregroundColor(.primary)
                        }
                    }
                    .padding(.horizontal, 30)
                    .padding(.vertical, 16)
                    .background(
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Color.white)
                            .overlay(
                                RoundedRectangle(cornerRadius: 20)
                                    .stroke(Color.blue.opacity(0.2), lineWidth: 1)
                            )
                            .shadow(color: Color.black.opacity(0.1), radius: 8, x: 0, y: 4)
                    )
                    
                    // Compass/Direction Indicator
                    HStack(spacing: 12) {
                        Image(systemName: "location.north.fill")
                            .font(.system(size: 20))
                            .foregroundColor(.blue)
                        
                        VStack(alignment: .leading, spacing: 2) {
                            Text("HEADING")
                                .font(.system(size: 10, weight: .bold))
                                .foregroundColor(.secondary)
                            Text("North • Straight Ahead")
                                .font(.system(size: 13, weight: .semibold))
                                .foregroundColor(.primary)
                        }
                        
                        Spacer()
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 12)
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(Color.white)
                            .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
                    )
                    .padding(.horizontal, 20)
                    
                    // Destination Indicator
                    HStack(spacing: 12) {
                        Image(systemName: "mappin.circle.fill")
                            .font(.system(size: 20))
                            .foregroundColor(.blue)
                        
                        VStack(alignment: .leading, spacing: 2) {
                            Text("DESTINATION")
                                .font(.system(size: 10, weight: .bold))
                                .foregroundColor(.secondary)
                            Text(route.end)
                                .font(.system(size: 13, weight: .semibold))
                                .foregroundColor(.primary)
                        }
                        
                        Spacer()
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 12)
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(Color.white)
                            .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
                    )
                    .padding(.horizontal, 20)
                }
                .padding(.bottom, 30)
            }
            
            // AR Crosshair Center
            ZStack {
                Circle()
                    .stroke(Color.blue.opacity(0.4), lineWidth: 2)
                    .frame(width: 60, height: 60)
                
                Circle()
                    .stroke(Color.blue.opacity(0.2), lineWidth: 1)
                    .frame(width: 80, height: 80)
                
                // Center dot
                Circle()
                    .fill(Color.blue)
                    .frame(width: 6, height: 6)
                
                // Crosshair lines
                Path { path in
                    path.move(to: CGPoint(x: -40, y: 0))
                    path.addLine(to: CGPoint(x: -20, y: 0))
                    path.move(to: CGPoint(x: 20, y: 0))
                    path.addLine(to: CGPoint(x: 40, y: 0))
                    path.move(to: CGPoint(x: 0, y: -40))
                    path.addLine(to: CGPoint(x: 0, y: -20))
                    path.move(to: CGPoint(x: 0, y: 20))
                    path.addLine(to: CGPoint(x: 0, y: 40))
                }
                .stroke(Color.blue.opacity(0.5), lineWidth: 2)
            }
            .position(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height / 2)
        }
        .edgesIgnoringSafeArea(.all)
        .onAppear {
            startAnimations()
        }
    }
    
    private func startAnimations() {
        // Animate arrows moving upward
        withAnimation(Animation.linear(duration: 1.5).repeatForever(autoreverses: false)) {
            animationOffset = -60
        }
        
        // Animate scan line
        withAnimation(Animation.linear(duration: 2.0).repeatForever(autoreverses: false)) {
            scanLineOffset = 100
        }
        
        // Pulse animation for indicators
        withAnimation(Animation.easeInOut(duration: 1.5).repeatForever(autoreverses: true)) {
            pulseScale = 1.3
        }
    }
}

// Preview
struct NavigationARView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationARView(route: NavigationRoute(
            start: "Reception",
            end: "Emergency Dept",
            floor: "Floor 1",
            distance: 40,
            estimatedTime: 2,
            steps: [
                NavigationStep(instruction: "Start from Reception desk", stepNumber: 1, distance: 0),
                NavigationStep(instruction: "Walk down the main corridor", stepNumber: 2, distance: 20),
                NavigationStep(instruction: "Emergency Department is on your left", stepNumber: 3, distance: 20)
            ],
            pathLocations: ["Reception", "Emergency Dept"]
        ))
    }
}
