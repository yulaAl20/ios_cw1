//
//  TestResultView.swift
//  ios_cw1
//
//  Created by Yulani Alwis on 2026-03-08.
//

import SwiftUI
import CoreImage.CIFilterBuiltins

struct TestResultView: View {
    
    @Environment(\.dismiss) var dismiss
    let testResult: TestResult
    
    @State private var showShareSheet = false
    @State private var showDownloadAlert = false
    
    var body: some View {
        ZStack(alignment: .top) {
            
            // Background
            Color(red: 0.90, green: 0.93, blue: 0.98)
                .ignoresSafeArea()
            
            ScrollView(showsIndicators: false) {
                VStack(spacing: 0) {
                    
                    Spacer().frame(height: 120)
                    
                    // Test Overview Card
                    testOverviewCard
                        .padding(.horizontal, 20)
                    
                    // Report Actions
                    if testResult.reportAvailable {
                        reportActionsSection
                            .padding(.horizontal, 20)
                            .padding(.top, 20)
                    }
                    
                    // QR Code Section
                    qrCodeSection
                        .padding(.horizontal, 20)
                        .padding(.top, 20)
                    
                    Spacer().frame(height: 40)
                }
            }
            
            // Header
            header
        }
        .navigationBarHidden(true)
        .sheet(isPresented: $showShareSheet) {
            ActivityViewController(
                activityItems: ["Test Report: \(testResult.testName)\nDate: \(testResult.formattedDate)\nDoctor: \(testResult.doctorName)"]
            )
        }
        .alert("Download Report", isPresented: $showDownloadAlert) {
            Button("OK", role: .cancel) { }
        } message: {
            Text("Your report has been downloaded successfully!")
        }
    }
}


// HEADER

extension TestResultView {
    
    var header: some View {
        HStack {
            Button(action: { dismiss() }) {
                Image(systemName: "chevron.left")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(Color(red: 0.15, green: 0.35, blue: 0.75))
                    .frame(width: 40, height: 40)
                    .background(Color.white)
                    .clipShape(Circle())
            }
            
            VStack(alignment: .leading, spacing: 2) {
                Text("Test Result")
                    .font(.system(size: 22, weight: .bold))
                    .foregroundColor(.black)
                
                Text(testResult.testName)
                    .font(.system(size: 13))
                    .foregroundColor(.gray)
            }
            
            Spacer()
        }
        .padding(.horizontal, 20)
        .padding(.top, 60)
        .padding(.bottom, 16)
        .background(Color(red: 0.82, green: 0.88, blue: 0.96))
    }
}


// TEST OVERVIEW CARD

extension TestResultView {
    
    var testOverviewCard: some View {
        VStack(alignment: .leading, spacing: 20) {
            
            // Header with icon
            HStack(spacing: 12) {
                ZStack {
                    Circle()
                        .fill(categoryColor.opacity(0.15))
                        .frame(width: 60, height: 60)
                    
                    Image(systemName: testResult.icon)
                        .font(.system(size: 26))
                        .foregroundColor(categoryColor)
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(testResult.testName)
                        .font(.system(size: 20, weight: .bold))
                    
                    HStack(spacing: 6) {
                        Image(systemName: "checkmark.seal.fill")
                            .font(.system(size: 12))
                        
                        Text(testResult.status)
                            .font(.system(size: 14, weight: .semibold))
                    }
                    .foregroundColor(.green)
                }
                
                Spacer()
            }
            
            Divider()
            
            // Test Details
            VStack(alignment: .leading, spacing: 16) {
                
                detailRow(
                    icon: "mappin.circle.fill",
                    title: "Place",
                    value: testResult.place
                )
                
                detailRow(
                    icon: "calendar",
                    title: "Date",
                    value: "\(testResult.formattedDate) at \(testResult.formattedTime)"
                )
                
                detailRow(
                    icon: "stethoscope",
                    title: "Doctor",
                    value: testResult.doctorName
                )
            }
        }
        .padding(20)
        .background(Color.white)
        .cornerRadius(20)
        .shadow(color: .black.opacity(0.06), radius: 10, x: 0, y: 4)
    }
    
    func detailRow(icon: String, title: String, value: String) -> some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 18))
                .foregroundColor(categoryColor)
                .frame(width: 30)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.system(size: 12))
                    .foregroundColor(.gray)
                
                Text(value)
                    .font(.system(size: 15, weight: .medium))
                    .foregroundColor(.black)
            }
            
            Spacer()
        }
    }
    
    var categoryColor: Color {
        switch testResult.category {
        case .blood:
            return Color(red: 0.85, green: 0.25, blue: 0.25)
        case .radiology:
            return Color(red: 0.0, green: 0.48, blue: 0.78)
        case .urine:
            return Color(red: 0.85, green: 0.65, blue: 0.15)
        case .pharmacy:
            return Color(red: 0.38, green: 0.35, blue: 0.85)
        case .all:
            return Color(red: 0.15, green: 0.35, blue: 0.75)
        }
    }
}


// REPORT ACTIONS

extension TestResultView {
    
    var reportActionsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            
            HStack(spacing: 12) {
                
                // Download Button
                Button(action: { showDownloadAlert = true }) {
                    HStack(spacing: 8) {
                        Image(systemName: "arrow.down.circle.fill")
                            .font(.system(size: 20))
                        
                        Text("Download")
                            .font(.system(size: 15, weight: .semibold))
                    }
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
                    .background(
                        LinearGradient(
                            colors: [
                                Color(red: 0.15, green: 0.35, blue: 0.75),
                                Color(red: 0.25, green: 0.50, blue: 0.88)
                            ],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .cornerRadius(14)
                }
                
                // Share Button
                Button(action: { showShareSheet = true }) {
                    HStack(spacing: 8) {
                        Image(systemName: "square.and.arrow.up")
                            .font(.system(size: 20))
                        
                        Text("Share")
                            .font(.system(size: 15, weight: .semibold))
                    }
                    .foregroundColor(Color(red: 0.15, green: 0.35, blue: 0.75))
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
                    .background(Color.white)
                    .cornerRadius(14)
                    .overlay(
                        RoundedRectangle(cornerRadius: 14)
                            .stroke(Color(red: 0.15, green: 0.35, blue: 0.75), lineWidth: 2)
                    )
                }
            }
        }
    }
}


// QR CODE SECTION

extension TestResultView {
    
    var qrCodeSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            
            Text("Consult Doctor")
                .font(.system(size: 18, weight: .bold))
                .padding(.leading, 4)
            
            VStack(spacing: 16) {
                
                // QR Code Card
                VStack(spacing: 16) {
                    
                    // QR Code
                    if let qrCodeImage = generateQRCode(from: qrCodeData) {
                        Image(uiImage: qrCodeImage)
                            .resizable()
                            .interpolation(.none)
                            .scaledToFit()
                            .frame(width: 200, height: 200)
                            .padding(20)
                            .background(Color.white)
                            .cornerRadius(16)
                    }
                    
                    // Instructions
                    VStack(spacing: 8) {
                        Text("Lab/Scan Review")
                            .font(.system(size: 16, weight: .bold))
                        
                        Text("When you visit the doctor for lab/scan review, show this QR code to the reception.")
                            .font(.system(size: 14))
                            .foregroundColor(.gray)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 8)
                    }
                    
                    // Info Box
                    HStack(spacing: 10) {
                        Image(systemName: "info.circle.fill")
                            .font(.system(size: 16))
                            .foregroundColor(Color(red: 0.15, green: 0.35, blue: 0.75))
                        
                        Text("No consultation fees for lab/scan review")
                            .font(.system(size: 13, weight: .medium))
                            .foregroundColor(Color(red: 0.15, green: 0.35, blue: 0.75))
                    }
                    .padding(12)
                    .frame(maxWidth: .infinity)
                    .background(Color(red: 0.15, green: 0.35, blue: 0.75).opacity(0.08))
                    .cornerRadius(12)
                    
                    // Queue Info
                    VStack(spacing: 6) {
                        Text("Queue Status")
                            .font(.system(size: 12, weight: .semibold))
                            .foregroundColor(.gray)
                            .textCase(.uppercase)
                            .tracking(1)
                        
                        HStack(spacing: 20) {
                            queueStatusItem(count: "4", label: "Consultation", color: .blue)
                            
                            Divider()
                                .frame(height: 30)
                            
                            queueStatusItem(count: "2", label: "Lab/Scan Review", color: .green)
                        }
                    }
                    .padding(.top, 8)
                }
                .padding(24)
                .background(
                    LinearGradient(
                        colors: [
                            Color(red: 0.95, green: 0.96, blue: 0.98),
                            Color.white
                        ],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
                .cornerRadius(20)
                .shadow(color: .black.opacity(0.06), radius: 10, x: 0, y: 4)
            }
        }
    }
    
    func queueStatusItem(count: String, label: String, color: Color) -> some View {
        VStack(spacing: 4) {
            Text(count)
                .font(.system(size: 28, weight: .bold))
                .foregroundColor(color)
            
            Text(label)
                .font(.system(size: 11))
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
    }
    
    var qrCodeData: String {
        """
        {
            "type": "lab_scan_review",
            "test_id": "\(testResult.id.uuidString)",
            "test_name": "\(testResult.testName)",
            "patient_queue_type": "labScanReview",
            "date": "\(testResult.formattedDate)",
            "doctor": "\(testResult.doctorName)"
        }
        """
    }
    
    func generateQRCode(from string: String) -> UIImage? {
        let context = CIContext()
        let filter = CIFilter.qrCodeGenerator()
        
        filter.message = Data(string.utf8)
        filter.correctionLevel = "M"
        
        if let outputImage = filter.outputImage {
            let transform = CGAffineTransform(scaleX: 10, y: 10)
            let scaledImage = outputImage.transformed(by: transform)
            
            if let cgImage = context.createCGImage(scaledImage, from: scaledImage.extent) {
                return UIImage(cgImage: cgImage)
            }
        }
        
        return nil
    }
}


// ActivityViewController for Share Sheet

struct ActivityViewController: UIViewControllerRepresentable {
    let activityItems: [Any]
    
    func makeUIViewController(context: Context) -> UIActivityViewController {
        let controller = UIActivityViewController(
            activityItems: activityItems,
            applicationActivities: nil
        )
        return controller
    }
    
    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}


#Preview {
    NavigationStack {
        TestResultView(
            testResult: TestResult(
                testName: "Blood Test",
                category: .blood,
                place: "ClinicFlow Central Lab",
                date: Date(),
                doctorName: "Dr. Sarah Johnson",
                status: "Completed",
                reportAvailable: true,
                reportURL: "sample-report-url",
                icon: "drop.fill"
            )
        )
    }
}
