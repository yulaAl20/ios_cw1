//
//  PeakTimeIndicator.swift
//  ios_cw1
//
//  Created by COBSCCOMP242P-74 on 2026-03-04.
//

import SwiftUI

struct PeakTimeIndicator: View {
    // Demo data: higher value = busier / more peak
    let busyLevels: [Double] = [0.2, 0.4, 0.7, 0.9, 0.95, 0.8, 0.5, 0.3]
    let times = ["7:30", "8:00", "8:30", "9:00", "9:30", "10:00", "10:30", "11:00"]
    
    private let maxBarHeight: CGFloat = 70
    private let barWidth: CGFloat = 3
    private let lineCornerRadius: CGFloat = 1.5
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("Peak Hours Today")
                .font(.headline)
                .fontWeight(.semibold)
                .padding(.horizontal, 20)
                .padding(.top, 16)
                .padding(.bottom, 12)
            
            // The chart container
            VStack(spacing: 12) {
                // Chart area
                HStack(alignment: .bottom, spacing: 8) {
                    ForEach(0..<times.count, id: \.self) { i in
                        VStack(spacing: 6) {
                            RoundedRectangle(cornerRadius: lineCornerRadius)
                                .fill(.black)
                                .frame(width: barWidth)
                                .frame(height: CGFloat(busyLevels[i]) * maxBarHeight)
                            
                            Text(times[i])
                                .font(.caption2)
                                .foregroundStyle(.gray)
                                .multilineTextAlignment(.center)
                        }
                        .frame(maxWidth: .infinity)
                    }
                }
                .frame(height: maxBarHeight + 28)
                .padding(.horizontal, 16)
                // Legend
                HStack {
                    Text("Low activity")
                        .font(.caption)
                        .foregroundStyle(.gray)
                    Spacer()
                    Text("Peak / Busy")
                        .font(.caption)
                        .foregroundStyle(.gray)
                }
                .padding(.horizontal, 16)
                .padding(.bottom, 12)
            }
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color(.systemBackground))
                    .shadow(color: .black.opacity(0.08), radius: 8, x: 0, y: 2)
            )
            .padding(.horizontal, 20)  
        }
    }
}

#Preview {
    PeakTimeIndicator()
        .padding(.vertical)
        .background(Color(.systemGroupedBackground))
}
