//
//  NavigationStepsView.swift
//  ios_cw1
//
//  Created by Oshadha Samarasinghe on 2026-03-05.
//

import SwiftUI

struct NavigationStepsView: View {
    
    @Environment(\.dismiss) var dismiss
    let route: NavigationRoute

    @StateObject private var speech = SpeechSynthesizer()
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                ScrollView {
                    VStack(spacing: 16) {
                        ForEach(Array(route.steps.enumerated()), id: \.element.id) { index, step in
                            HStack(alignment: .top, spacing: 16) {
                                if index == 0 {
                                    ZStack {
                                        Circle()
                                            .fill(Color(.systemGray6))
                                            .frame(width: 44, height: 44)
                                        
                                        Image(systemName: "checkmark")
                                            .font(.system(size: 18, weight: .semibold))
                                            .foregroundColor(.green)
                                    }
                                } else {
                                    ZStack {
                                        Circle()
                                            .fill(Color.blue)
                                            .frame(width: 44, height: 44)
                                        
                                        Text("\(step.stepNumber)")
                                            .font(.system(size: 16, weight: .semibold))
                                            .foregroundColor(.white)
                                    }
                                }
                                
                                VStack(alignment: .leading, spacing: 8) {
                                    Text(step.instruction)
                                        .font(.system(size: 16, weight: .medium))
                                        .foregroundColor(.primary)
                                    
                                    if step.distance > 0 {
                                        Text("Approx. \(step.distance) meters")
                                            .font(.system(size: 14))
                                            .foregroundColor(.secondary)
                                    }
                                }
                                
                                Spacer()
                                
                                Button(action: {
                                    speech.toggleSpeak(step.instruction)
                                }) {
                                    Image(systemName: speech.isSpeaking ? "speaker.slash.fill" : "speaker.wave.2.fill")
                                        .font(.system(size: 18))
                                        .foregroundColor(.secondary)
                                }
                                .frame(width: 44, height: 44)
                                .contentShape(Rectangle())
                                .accessibilityLabel("Read step \(step.stepNumber) aloud")
                                .accessibilityHint("Plays audio of this navigation instruction")
                            }
                            .padding(.horizontal, 20)
                            .padding(.vertical, 12)
                            
                            if index < route.steps.count - 1 {
                                Divider()
                                    .padding(.leading, 76)
                            }
                        }
                        
                        HStack(spacing: 8) {
                            Image(systemName: "clock")
                                .font(.system(size: 14))
                                .foregroundColor(.secondary)
                            
                            Text("Estimated walk: \(route.estimatedTime) minutes")
                                .font(.system(size: 14))
                                .foregroundColor(.secondary)
                        }
                        .padding(.top, 20)
                        .padding(.bottom, 40)
                    }
                    .padding(.top, 20)
                }
            }
            .navigationTitle("Step-by-Step Directions")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        speech.stop()
                        dismiss()
                    }) {
                        Image(systemName: "xmark")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(.primary)
                    }
                }
            }
        }
        .onDisappear {
            speech.stop()
        }
    }
}

#Preview {
    NavigationStepsView(route: NavigationRoute(
        start: "Reception",
        end: "Elevator",
        floor: "Floor 1",
        distance: 50,
        estimatedTime: 2,
        steps: [
            NavigationStep(instruction: "Walk straight ahead from the Main Entrance", stepNumber: 1, distance: 10),
            NavigationStep(instruction: "Continue past the Waiting Area", stepNumber: 2, distance: 15),
            NavigationStep(instruction: "The Registration Counter will be in front of you", stepNumber: 3, distance: 10),
            NavigationStep(instruction: "Turn right and walk to the Elevator", stepNumber: 4, distance: 15)
        ],
        pathLocations: ["Reception", "Waiting Area", "Nurse Stn", "Elevator"]
    ))
}
