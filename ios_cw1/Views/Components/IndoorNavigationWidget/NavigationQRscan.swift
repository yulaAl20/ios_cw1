//
//  NavigationQRscan.swift
//  ios_cw1
//
//  Created by Oshadha Samarasinghe on 2026-03-05.
//

import SwiftUI

struct NavigationQRscan: View {
    
    @Environment(\.dismiss) var dismiss
    @Binding var selectedLocation: String
    
    @State private var isScanning: Bool = false
    @State private var scannedLocation: String = "Reception"
    @State private var scannedFloor: String = "Floor 1"
    @State private var showSuccess: Bool = false
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.white.ignoresSafeArea()
                
                VStack(spacing: 0) {
                    if !showSuccess {
                        initialScanView
                    } else {
                        successView
                    }
                }
            }
            .navigationTitle("Scan QR Code")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        dismiss()
                    }) {
                        Image(systemName: "arrow.left")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(.primary)
                    }
                }
            }
        }
    }
    
    private var initialScanView: some View {
        VStack(spacing: 24) {
            Spacer()
            
            Image(systemName: "qrcode")
                .font(.system(size: 60))
                .foregroundColor(.primary)
            
            VStack(spacing: 8) {
                Text("Scan Location QR code")
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(.primary)
                
                Text("Point your camera at the QR code\nplaced near the location")
                    .font(.system(size: 15))
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
            }
            
            Spacer()
            
            ZStack {
                RoundedRectangle(cornerRadius: 20)
                    .stroke(Color.blue, lineWidth: 6)
                    .frame(width: 280, height: 280)
                
                VStack {
                    HStack {
                        scannerCorner
                        Spacer()
                        scannerCorner.rotation3DEffect(.degrees(90), axis: (x: 0, y: 0, z: 1))
                    }
                    Spacer()
                    HStack {
                        scannerCorner.rotation3DEffect(.degrees(270), axis: (x: 0, y: 0, z: 1))
                        Spacer()
                        scannerCorner.rotation3DEffect(.degrees(180), axis: (x: 0, y: 0, z: 1))
                    }
                }
                .frame(width: 240, height: 240)
            }
            
            Spacer()
            
            Button(action: {
                withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
                    showSuccess = true
                }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                    selectedLocation = scannedLocation
                    dismiss()
                }
            }) {
                HStack(spacing: 8) {
                    Image(systemName: "qrcode.viewfinder")
                        .font(.system(size: 18, weight: .semibold))
                    Text("Tap to Scan")
                        .font(.system(size: 17, weight: .semibold))
                }
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(Color.blue)
                .cornerRadius(14)
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 40)
        }
    }
    
    private var successView: some View {
        VStack(spacing: 24) {
            Spacer()
            
            Image(systemName: "qrcode")
                .font(.system(size: 60))
                .foregroundColor(.primary)
            
            VStack(spacing: 8) {
                Text("Scan Location QR code")
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(.primary)
                
                Text("Point your camera at the QR code\nplaced near the location")
                    .font(.system(size: 15))
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
            }
            
            Spacer()
            
            ZStack {
                RoundedRectangle(cornerRadius: 20)
                    .stroke(Color.blue, lineWidth: 6)
                    .frame(width: 280, height: 280)
                
                VStack {
                    HStack {
                        scannerCorner
                        Spacer()
                        scannerCorner.rotation3DEffect(.degrees(90), axis: (x: 0, y: 0, z: 1))
                    }
                    Spacer()
                    HStack {
                        scannerCorner.rotation3DEffect(.degrees(270), axis: (x: 0, y: 0, z: 1))
                        Spacer()
                        scannerCorner.rotation3DEffect(.degrees(180), axis: (x: 0, y: 0, z: 1))
                    }
                }
                .frame(width: 240, height: 240)
                
                ZStack {
                    Circle()
                        .fill(Color.green)
                        .frame(width: 70, height: 70)
                    
                    Image(systemName: "checkmark")
                        .font(.system(size: 35, weight: .bold))
                        .foregroundColor(.white)
                }
                .scaleEffect(showSuccess ? 1.0 : 0.5)
                .opacity(showSuccess ? 1.0 : 0)
            }
            
            Spacer()
            
            HStack(spacing: 12) {
                Image(systemName: "mappin.circle.fill")
                    .font(.system(size: 24))
                    .foregroundColor(.green)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(scannedLocation)
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.primary)
                    Text(scannedFloor)
                        .font(.system(size: 13))
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                Image(systemName: "checkmark.circle.fill")
                    .font(.system(size: 24))
                    .foregroundColor(.green)
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 16)
            .background(Color.white)
            .cornerRadius(16)
            .shadow(color: Color.black.opacity(0.08), radius: 8, x: 0, y: 2)
            .padding(.horizontal, 20)
            .padding(.bottom, 40)
            .scaleEffect(showSuccess ? 1.0 : 0.9)
            .opacity(showSuccess ? 1.0 : 0)
        }
    }
    
    private var scannerCorner: some View {
        VStack(spacing: 0) {
            Rectangle()
                .fill(Color.blue)
                .frame(width: 6, height: 40)
            Rectangle()
                .fill(Color.blue)
                .frame(width: 40, height: 6)
                .offset(x: -17, y: -6)
        }
    }
}

#Preview {
    NavigationQRscan(selectedLocation: .constant(""))
}
