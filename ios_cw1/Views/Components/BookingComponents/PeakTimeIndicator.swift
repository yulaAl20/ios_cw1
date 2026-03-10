//
//  PeakTimeIndicator.swift
//  ios_cw1
//
//  Created by COBSCCOMP242P-74 on 2026-03-04.
//

import SwiftUI

struct PeakTimeIndicator: View {
    let busyLevels: [Double] = [0.3, 0.5, 0.85, 0.95, 0.9, 0.7, 0.45, 0.25, 0.2]
    let times = ["10", "11", "12", "1", "2", "3", "4", "5", "6"]
    
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
            
            VStack(spacing: 12) {
                HStack(alignment: .bottom, spacing: 0) {
                    ForEach(0..<times.count, id: \.self) { i in
                        VStack(spacing: 6) {
                            RoundedRectangle(cornerRadius: lineCornerRadius)
                                .fill(.black)
                                .frame(width: barWidth)
                                .frame(height: CGFloat(busyLevels[i]) * maxBarHeight)
                            
                            Text(times[i])
                                .font(.system(size: 10, weight: .medium, design: .monospaced))
                                .foregroundStyle(.gray)
                                .frame(width: 24, alignment: .center)
                        }
                        .frame(maxWidth: .infinity)
                    }
                }
                .frame(height: maxBarHeight + 28)
                .padding(.horizontal, 12)
                
                HStack {
                    Text("10 AM")
                        .font(.caption2)
                        .foregroundStyle(.gray)
                    Spacer()
                    Text("6 PM")
                        .font(.caption2)
                        .foregroundStyle(.gray)
                }
                .padding(.horizontal, 16)
                
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
