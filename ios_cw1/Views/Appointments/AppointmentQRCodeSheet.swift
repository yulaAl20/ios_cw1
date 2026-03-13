import SwiftUI

//Reusable sheet to show the same QR UI used in payment success screens,
// for users to access their booking QR later from Appointments.
struct AppointmentQRCodeSheet: View {
    let title: String
    let receiptNumber: String
    let qrImage: UIImage?

    let primaryMessage: String
    let secondaryMessage: String?

    let details: [Detail]

    struct Detail: Identifiable {
        let id = UUID()
        let label: String
        let value: String
    }

    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            ScrollView(showsIndicators: false) {
                VStack(spacing: 20) {
                    Spacer().frame(height: 8)

                    Text(title)
                        .font(.system(size: 22, weight: .bold))
                        .multilineTextAlignment(.center)

                    VStack(spacing: 8) {
                        Text("BOOKING REFERENCE")
                            .font(.system(size: 11, weight: .semibold))
                            .foregroundColor(.gray)
                            .tracking(1)

                        Text(receiptNumber)
                            .font(.system(size: 26, weight: .bold, design: .monospaced))
                            .foregroundColor(.blue)
                    }

                    VStack(spacing: 12) {
                        Text(primaryMessage)
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(.gray)

                        if let qrImage {
                            Image(uiImage: qrImage)
                                .resizable()
                                .interpolation(.none)
                                .scaledToFit()
                                .frame(width: 180, height: 180)
                                .padding(12)
                                .background(Color.white)
                                .cornerRadius(12)
                                .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
                        } else {
                            ContentUnavailableView("QR not available", systemImage: "qrcode", description: Text("We couldn't generate your QR code right now."))
                                .padding(.top, 8)
                        }

                        Text(secondaryMessage ?? "Show this QR code at the reception for quick check-in")
                            .font(.system(size: 13))
                            .foregroundColor(.gray)
                            .multilineTextAlignment(.center)
                    }

                    VStack(spacing: 10) {
                        ForEach(details) { row in
                            HStack {
                                Text(row.label)
                                    .foregroundColor(.gray)
                                Spacer()
                                Text(row.value)
                                    .font(.system(size: 15, weight: .medium))
                                    .multilineTextAlignment(.trailing)
                            }
                        }
                    }
                    .padding(18)
                    .background(Color.white)
                    .cornerRadius(16)
                    .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 4)
                    .padding(.horizontal, 20)

                    Button("Done") {
                        dismiss()
                    }
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(Color.blue)
                    .cornerRadius(30)
                    .padding(.horizontal, 20)
                    .padding(.top, 10)
                    .padding(.bottom, 20)
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Close") { dismiss() }
                }
            }
        }
    }
}

#Preview {
    AppointmentQRCodeSheet(
        title: "Payment Successful!",
        receiptNumber: "A-123456",
        qrImage: nil,
        primaryMessage: "Scan at Counter",
        secondaryMessage: "Show this QR code at the reception for quick check-in",
        details: [
            .init(label: "Doctor", value: "Dr. Emma Wilson"),
            .init(label: "Date & Time", value: "Fri, 13 Mar • 01:00 PM"),
            .init(label: "Location", value: "Room 12"),
            .init(label: "Amount Paid", value: "LKR 2300.00")
        ]
    )
}
