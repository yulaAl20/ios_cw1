//
//  MockData.swift
//  ios_cw1
//
//  Created by COBSCCOMP242P-74 on 2026-03-04.
//


import Foundation

struct MockData {
    static let doctors: [Doctor] = [
        Doctor(
            firstName: "Jenny",
            lastName: "Wilson",
            degree: "MD",
            specialty: "General Physician",
            rating: 4.9,
            imageName: "jenny_wilson",
            availableTime: "Today, 9:30 AM",
            specialtyType: .general,
            experience: "7 Years",
            patients: "5.9k+",
            reviews: "3.8k+",
            fee: 2300.00,
            timeSlots: [
                "09:00", "09:30", "10:00",           // Morning (3)
                "13:00", "13:30", "14:00", "14:30", "15:00", // Afternoon (5)
                "17:00", "17:30"                     // Evening (2)
            ],
            bio: "Dr. Jenny Wilson is a highly trusted general physician known for her compassionate care and accurate diagnosis. With 7 years of experience and thousands of satisfied patients, she focuses on providing effective solutions tailored to each patient’s needs. Her friendly approach helps patients feel comfortable and confident during every visit.",
            availability: "Monday – Friday"
        ),
        Doctor(
            firstName: "Marcus",
            lastName: "Bennett",
            degree: "MD",
            specialty: "General Physician",
            rating: 4.8,
            imageName: nil,
            availableTime: "Today, 5:30 PM",
            specialtyType: .general,
            experience: "10 Years",
            patients: "8.2k+",
            reviews: "4.1k+",
            fee: 2500.00,
            timeSlots: [
                "08:30", "09:00", "09:30",           // Morning
                "12:00", "12:30", "13:00", "13:30", "14:00", // Afternoon
                "16:30", "17:00", "17:30"             // Evening
            ],
            bio: "Dr. Marcus Bennett brings over a decade of experience in general medicine. He is known for his patient‑centered approach and thorough consultations, ensuring every individual receives personalized care.",
            availability: "Monday – Friday"
        ),
        Doctor(
            firstName: "Olivia",
            lastName: "Kim",
            degree: "MD",
            specialty: "Gynecologist",
            rating: 4.6,
            imageName: nil,
            availableTime: "Mon, 12 Oct",
            specialtyType: .gynecologist,
            experience: "12 Years",
            patients: "9.5k+",
            reviews: "4.0k+",
            fee: 2700.00,
            timeSlots: [
                "08:00", "08:30", "09:00", "09:30",   // Morning
                "13:00", "13:30", "14:00", "14:30",   // Afternoon
                "18:00", "18:30"                      // Evening
            ],
            bio: "Dr. Olivia Kim specializes in women's health with 12 years of experience. She provides compassionate care in gynecology and obstetrics, creating a comfortable environment for her patients.",
            availability: "Monday – Thursday"
        ),
        Doctor(
            firstName: "Raj",
            lastName: "Patel",
            degree: "DMD",
            specialty: "Dentist",
            rating: 4.9,
            imageName: nil,
            availableTime: "Today, 1:15 PM",
            specialtyType: .dentist,
            experience: "8 Years",
            patients: "6.3k+",
            reviews: "3.9k+",
            fee: 2100.00,
            timeSlots: [
                "09:30", "10:00", "10:30", "11:00",   // Morning
                "13:00", "13:30", "14:00", "14:30",   // Afternoon
                "17:00", "17:30"                      // Evening
            ],
            bio: "Dr. Raj Patel is a skilled dentist known for his gentle approach and precise treatments. He has transformed thousands of smiles with modern techniques and a caring attitude.",
            availability: "Monday – Saturday"
        ),
        Doctor(
            firstName: "Sarah",
            lastName: "Chen",
            degree: "MD",
            specialty: "Cardiologist",
            rating: 4.7,
            imageName: nil,
            availableTime: "Tomorrow, 10:00 AM",
            specialtyType: .cardiology,
            experience: "15 Years",
            patients: "12.1k+",
            reviews: "5.2k+",
            fee: 3200.00,
            timeSlots: [
                "08:00", "08:30", "09:00", "09:30", "10:00", // Morning
                "12:00", "12:30", "13:00", "13:30", "14:00", // Afternoon
                "16:00", "16:30", "17:00"                    // Evening
            ],
            bio: "Dr. Sarah Chen is a senior cardiologist with 15 years of experience in treating heart conditions. She is dedicated to preventive care and advanced cardiac treatments.",
            availability: "Monday – Friday"
        ),
        Doctor(
            firstName: "Michael",
            lastName: "Lee",
            degree: "MD",
            specialty: "Dermatologist",
            rating: 4.8,
            imageName: nil,
            availableTime: "Wed, 15 Oct",
            specialtyType: .dermatologist,
            experience: "9 Years",
            patients: "7.4k+",
            reviews: "3.7k+",
            fee: 2600.00,
            timeSlots: [
                "10:00", "10:30", "11:00", "11:30",   // Morning
                "14:00", "14:30", "15:00", "15:30",   // Afternoon
                "18:30", "19:00"                      // Evening
            ],
            bio: "Dr. Michael Lee is a board‑certified dermatologist specializing in medical and cosmetic skin care. His patients appreciate his meticulous approach and clear explanations.",
            availability: "Tuesday – Saturday"
        ),
        Doctor(
            firstName: "Emily",
            lastName: "White",
            degree: "MD",
            specialty: "Pediatrician",
            rating: 4.9,
            imageName: nil,
            availableTime: "Today, 11:30 AM",
            specialtyType: .pediatrician,
            experience: "11 Years",
            patients: "10.3k+",
            reviews: "4.8k+",
            fee: 2400.00,
            timeSlots: [
                "08:30", "09:00", "09:30", "10:00",   // Morning
                "12:30", "13:00", "13:30", "14:00",   // Afternoon
                "16:00", "16:30", "17:00"             // Evening
            ],
            bio: "Dr. Emily White is a caring pediatrician who has been looking after children's health for over 11 years. She creates a friendly atmosphere that puts both kids and parents at ease.",
            availability: "Monday – Friday"
        ),
        Doctor(
            firstName: "James",
            lastName: "Brown",
            degree: "MD",
            specialty: "Cardiologist",
            rating: 4.5,
            imageName: nil,
            availableTime: "Thu, 16 Oct",
            specialtyType: .cardiology,
            experience: "20 Years",
            patients: "15.7k+",
            reviews: "6.1k+",
            fee: 3500.00,
            timeSlots: [
                "07:30", "08:00", "08:30", "09:00", "09:30", // Morning
                "12:00", "12:30", "13:00", "13:30", "14:00", // Afternoon
                "16:30", "17:00", "17:30", "18:00"           // Evening
            ],
            bio: "Dr. James Brown is a highly experienced cardiologist with 20 years in practice. He is known for his deep expertise in interventional cardiology and patient‑focused care.",
            availability: "Monday – Thursday"
        )
    ]
    
    static let sampleReviews: [Review] = [
        Review(
            author: "Alex Mitchell",
            date: "2 days ago",
            rating: 5.0,
            comment: "Dr. Jenny is absolutely fantastic! She explained every step of the procedure and made sure I was completely comfortable. Highly recommended to anyone looking for a gentle dentist."
        ),
        Review(
            author: "Sarah Jenkins",
            date: "1 week ago",
            rating: 4.8,
            comment: "Very professional and friendly atmosphere. The clinic is spotless, and I didn't have to wait at all for my appointment. She really values her patients' time."
        ),
        Review(
            author: "Sarah Jenkins",
            date: "1 week ago",
            rating: 4.8,
            comment: "Very professional and friendly atmosphere. The clinic is spotless, and I didn't have to wait at all for"
        )
    ]
}


