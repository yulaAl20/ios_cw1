//
//  IndoorNavigationView.swift
//  ios_cw1
//
//  Created by Oshadha Samarasinghe on 2026-03-05.
//

import SwiftUI

struct IndoorNavigationView: View {
    
    @State private var selectedTab: Int = 3
    @State private var startLocation: String = ""
    @State private var destination: String = ""
    @State private var selectedFloor: String = "Floor 1"
    @State private var showLocationPicker: Bool = false
    @State private var isSelectingStartLocation: Bool = true
    @State private var showQRScanner: Bool = false
    @State private var showNavigationSteps: Bool = false
    @State private var isARMode: Bool = false
    
    var hasValidRoute: Bool {
        return !startLocation.isEmpty && !destination.isEmpty
    }
    
    var currentRoute: NavigationRoute? {
        return NavigationRoute.getRoute(from: startLocation, to: destination, floor: selectedFloor)
    }
    
    var currentFloorData: FloorData {
        switch selectedFloor {
        case "Floor 1":
            return FloorData(
                title: "First Floor - Entry & Services",
                rows: [
                    FloorRow(rooms: [
                        Room(name: "Reception"),
                        Room(name: "Registration"),
                        Room(name: "Records"),
                        Room(name: "Records")
                    ]),
                    FloorRow(entrance: "Entrance", rooms: [
                        Room(name: "Waiting Area", isWide: true),
                        Room(name: "Restroom")
                    ]),
                    FloorRow(rooms: [
                        Room(name: "Emergency Dept", isWide: true),
                        Room(name: "Nurse Stn"),
                        Room(name: "Elevator")
                    ]),
                    FloorRow(entrance: "Entrance 2", rooms: [
                        Room(name: "Waiting Area\nB", isWide: true),
                        Room(name: "Restroom")
                    ]),
                    FloorRow(rooms: [
                        Room(name: "Pharmacy", isWide: true),
                        Room(name: "Billing"),
                        Room(name: "Elevator")
                    ])
                ]
            )
        case "Floor 2":
            return FloorData(
                title: "Second Floor - Consultations",
                rows: [
                    FloorRow(rooms: [
                        Room(name: "Room 201"),
                        Room(name: "Room 202"),
                        Room(name: "Room 203"),
                        Room(name: "Vitals")
                    ]),
                    FloorRow(rooms: [
                        Room(name: "Cardiology", isWide: true),
                        Room(name: "Nurses' Stn")
                    ]),
                    FloorRow(rooms: [
                        Room(name: "Pediatrics", isWide: true),
                        Room(name: "Restroom"),
                        Room(name: "Elevator")
                    ]),
                    FloorRow(rooms: [
                        Room(name: "Neurology", isWide: true),
                        Room(name: "Waiting Area")
                    ]),
                    FloorRow(rooms: [
                        Room(name: "Orthopedics", isWide: true),
                        Room(name: "Records"),
                        Room(name: "Elevator")
                    ])
                ]
            )
        case "Floor 3":
            return FloorData(
                title: "Third Floor - Diagnostics",
                rows: [
                    FloorRow(rooms: [
                        Room(name: "Main Lab"),
                        Room(name: "X-Ray"),
                        Room(name: "MRI Scan"),
                        Room(name: "Records")
                    ]),
                    FloorRow(rooms: [
                        Room(name: "Blood Bank", isWide: true),
                        Room(name: "Sample Room")
                    ]),
                    FloorRow(rooms: [
                        Room(name: "CT Scan", isWide: true),
                        Room(name: "Ultrasound"),
                        Room(name: "Elevator")
                    ]),
                    FloorRow(rooms: [
                        Room(name: "Pathology", isWide: true),
                        Room(name: "Restroom")
                    ]),
                    FloorRow(rooms: [
                        Room(name: "Cafeteria", isWide: true),
                        Room(name: "Billing"),
                        Room(name: "Elevator")
                    ])
                ]
            )
        default:
            return FloorData(
                title: "First Floor - Entry & Services",
                rows: [
                    FloorRow(rooms: [
                        Room(name: "Reception"),
                        Room(name: "Registration"),
                        Room(name: "Records"),
                        Room(name: "Records")
                    ]),
                    FloorRow(entrance: "Entrance", rooms: [
                        Room(name: "Waiting Area", isWide: true),
                        Room(name: "Restroom")
                    ]),
                    FloorRow(rooms: [
                        Room(name: "Emergency Dept", isWide: true),
                        Room(name: "Nurse Stn"),
                        Room(name: "Elevator")
                    ]),
                    FloorRow(entrance: "Entrance 2", rooms: [
                        Room(name: "Waiting Area\nB", isWide: true),
                        Room(name: "Restroom")
                    ]),
                    FloorRow(rooms: [
                        Room(name: "Pharmacy", isWide: true),
                        Room(name: "Billing"),
                        Room(name: "Elevator")
                    ])
                ]
            )
        }
    }
    
    var body: some View {
        ZStack(alignment: .bottom) {
            Color.white.ignoresSafeArea()
            
            VStack(spacing: 0) {
                HStack(spacing: 12) {
                    ZStack {
                        Circle()
                            .fill(Color(.systemGray6))
                            .frame(width: 44, height: 44)
                        Image(systemName: "person.circle")
                            .font(.system(size: 24))
                            .foregroundColor(.secondary)
                    }
                    
                    Spacer()
                    
                    Text("Navigation")
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(.primary)
                    
                    Spacer()
                    
                    ZStack(alignment: .topTrailing) {
                        ZStack {
                            Circle()
                                .fill(Color(.systemGray6))
                                .frame(width: 44, height: 44)
                            Image(systemName: "bell")
                                .font(.system(size: 20))
                                .foregroundColor(.secondary)
                        }
                        
                        Circle()
                            .fill(Color.red)
                            .frame(width: 10, height: 10)
                            .offset(x: -8, y: 8)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 10)
                .padding(.bottom, 16)
                
                HStack(spacing: 12) {
                    VStack(spacing: 0) {
                        Circle()
                            .fill(Color.blue)
                            .frame(width: 12, height: 12)
                        
                        VStack(spacing: 2) {
                            ForEach(0..<8, id: \.self) { _ in
                                Rectangle()
                                    .fill(Color.gray.opacity(0.4))
                                    .frame(width: 2, height: 4)
                            }
                        }
                        .padding(.vertical, 4)
                        
                        Image(systemName: "mappin.circle.fill")
                            .font(.system(size: 16))
                            .foregroundColor(.red)
                    }
                    .padding(.trailing, 4)
                    
                    VStack(spacing: 12) {
                        HStack {
                            Text(startLocation.isEmpty ? "Choose Start location" : startLocation)
                                .font(.system(size: 15))
                                .foregroundColor(startLocation.isEmpty ? Color(.placeholderText) : .primary)
                            Spacer()
                        }
                        .padding(.horizontal, 16)
                        .padding(.vertical, 12)
                        .background(Color(.systemGray6))
                        .cornerRadius(10)
                        .onTapGesture {
                            isSelectingStartLocation = true
                            showLocationPicker = true
                        }
                        
                        HStack {
                            Text(destination.isEmpty ? "Choose destination" : destination)
                                .font(.system(size: 15))
                                .foregroundColor(destination.isEmpty ? Color(.placeholderText) : .primary)
                            Spacer()
                        }
                        .padding(.horizontal, 16)
                        .padding(.vertical, 12)
                        .background(Color(.systemGray6))
                        .cornerRadius(10)
                        .onTapGesture {
                            isSelectingStartLocation = false
                            showLocationPicker = true
                        }
                    }
                    
                    VStack(spacing: 20) {
                        Button(action: {
                            let temp = startLocation
                            startLocation = destination
                            destination = temp
                        }) {
                            Image(systemName: "arrow.up.arrow.down")
                                .font(.system(size: 16, weight: .medium))
                                .foregroundColor(.secondary)
                                .frame(width: 32, height: 32)
                        }
                        
                        Button(action: {
                            startLocation = ""
                            destination = ""
                        }) {
                            Image(systemName: "xmark")
                                .font(.system(size: 16, weight: .medium))
                                .foregroundColor(.secondary)
                                .frame(width: 32, height: 32)
                        }
                    }
                }
                .padding(16)
                .background(Color.white)
                .cornerRadius(16)
                .shadow(color: Color.black.opacity(0.08), radius: 8, x: 0, y: 2)
                .padding(.horizontal, 20)
                .padding(.bottom, 16)
                
                ScrollView {
                    VStack(spacing: 20) {
                        VStack(alignment: .leading, spacing: 16) {
                            HStack {
                                Text(currentFloorData.title)
                                    .font(.system(size: 15, weight: .medium))
                                    .foregroundColor(.secondary)
                                
                                Spacer()
                                
                                Menu {
                                    Button("Floor 1") {
                                        withAnimation {
                                            selectedFloor = "Floor 1"
                                        }
                                    }
                                    Button("Floor 2") {
                                        withAnimation {
                                            selectedFloor = "Floor 2"
                                        }
                                    }
                                    Button("Floor 3") {
                                        withAnimation {
                                            selectedFloor = "Floor 3"
                                        }
                                    }
                                } label: {
                                    HStack(spacing: 4) {
                                        Text(selectedFloor)
                                            .font(.system(size: 15, weight: .semibold))
                                            .foregroundColor(.blue)
                                        Image(systemName: "chevron.down")
                                            .font(.system(size: 12, weight: .semibold))
                                            .foregroundColor(.blue)
                                    }
                                }
                            }
                            
                            VStack(spacing: 12) {
                                ForEach(currentFloorData.rows) { row in
                                    HStack(alignment: .center, spacing: 8) {
                                        if let entrance = row.entrance {
                                            HStack(spacing: 4) {
                                                Text(entrance)
                                                    .font(.system(size: 13, weight: .medium))
                                                    .foregroundColor(.secondary)
                                                
                                                Image(systemName: "arrow.right")
                                                    .font(.system(size: 12))
                                                    .foregroundColor(.secondary)
                                            }
                                            .frame(width: 80, alignment: .leading)
                                        } else {
                                            Spacer()
                                                .frame(width: 88)
                                        }
                                        
                                        ForEach(row.rooms) { room in
                                            buildLocationBox(room.name, isWide: room.isWide)
                                        }
                                    }
                                }
                            }
                        }
                        .padding(.horizontal, 20)
                        
                        Spacer(minLength: 180)
                    }
                }
                
                Spacer()
            }
            
            VStack(spacing: 0) {
                if hasValidRoute, let route = currentRoute {
                    VStack(spacing: 12) {
                        HStack(spacing: 12) {
                            Button(action: {
                                isARMode = false
                            }) {
                                Image(systemName: "map.fill")
                                    .font(.system(size: 20))
                                    .foregroundColor(isARMode ? .secondary : .blue)
                                    .frame(width: 44, height: 44)
                                    .background(isARMode ? Color(.systemGray6) : Color.blue.opacity(0.15))
                                    .cornerRadius(10)
                            }
                            
                            Button(action: {
                                isARMode = true
                            }) {
                                Image(systemName: "camera.viewfinder")
                                    .font(.system(size: 20))
                                    .foregroundColor(isARMode ? .blue : .secondary)
                                    .frame(width: 44, height: 44)
                                    .background(isARMode ? Color.blue.opacity(0.15) : Color(.systemGray6))
                                    .cornerRadius(10)
                            }
                            
                            Spacer()
                        }
                        .padding(.horizontal, 20)
                        
                        Button(action: {
                            showNavigationSteps = true
                        }) {
                            HStack(spacing: 12) {
                                ZStack {
                                    Circle()
                                        .fill(Color.blue)
                                        .frame(width: 50, height: 50)
                                    
                                    Image(systemName: "location.north.fill")
                                        .font(.system(size: 24))
                                        .foregroundColor(.white)
                                }
                                
                                VStack(alignment: .leading, spacing: 4) {
                                    HStack(spacing: 12) {
                                        HStack(spacing: 4) {
                                            Image(systemName: "figure.walk")
                                                .font(.system(size: 12))
                                            Text("\(route.estimatedTime) min")
                                                .font(.system(size: 13, weight: .medium))
                                        }
                                        .foregroundColor(.blue)
                                        
                                        HStack(spacing: 4) {
                                            Image(systemName: "arrow.left.and.right")
                                                .font(.system(size: 12))
                                            Text("\(route.distance) m")
                                                .font(.system(size: 13, weight: .medium))
                                        }
                                        .foregroundColor(.blue)
                                    }
                                    
                                    Text(route.steps.first?.instruction ?? "")
                                        .font(.system(size: 15, weight: .semibold))
                                        .foregroundColor(.primary)
                                        .lineLimit(2)
                                    
                                    if route.steps.count > 1 {
                                        Text("Next:")
                                            .font(.system(size: 12))
                                            .foregroundColor(.blue)
                                    }
                                }
                                
                                Spacer()
                            }
                            .padding(16)
                            .background(Color.white)
                            .cornerRadius(16)
                            .shadow(color: Color.black.opacity(0.08), radius: 8, x: 0, y: 2)
                        }
                        .padding(.horizontal, 20)
                    }
                    .padding(.bottom, 12)
                }
                
                FloatingNavBarView(selectedTab: $selectedTab)
            }
        }
        .sheet(isPresented: $showLocationPicker) {
            if isSelectingStartLocation {
                SelectLocationView(selectedLocation: $startLocation, isStartLocation: true)
            } else {
                SelectLocationView(selectedLocation: $destination, isStartLocation: false)
            }
        }
        .sheet(isPresented: $showQRScanner) {
            NavigationQRscan(selectedLocation: $startLocation)
        }
        .sheet(isPresented: $showNavigationSteps) {
            if let route = currentRoute {
                NavigationStepsView(route: route)
            }
        }
    }
    
    private func buildLocationBox(_ name: String, isWide: Bool = false) -> some View {
        let isStart = (name == startLocation)
        let isEnd = (name == destination)
        let isOnPath = currentRoute?.pathLocations.contains(name) ?? false
        let shouldHighlight = isStart || isEnd || (hasValidRoute && isOnPath)
        
        return ZStack {
            Text(name)
                .font(.system(size: 13, weight: shouldHighlight ? .semibold : .medium))
                .foregroundColor(shouldHighlight ? .primary : Color.primary.opacity(0.7))
                .multilineTextAlignment(.center)
                .frame(maxWidth: .infinity)
                .frame(height: isWide ? 54 : 48)
                .background(shouldHighlight ? Color.green.opacity(0.25) : Color(.systemGray6).opacity(0.6))
                .cornerRadius(12)
                .frame(minWidth: isWide ? 140 : nil)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(shouldHighlight ? Color.green : Color.clear, lineWidth: 2)
                )
            
            if isStart {
                VStack {
                    HStack {
                        Spacer()
                        Circle()
                            .fill(Color.blue)
                            .frame(width: 10, height: 10)
                            .padding(4)
                    }
                    Spacer()
                }
            }
            
            if isEnd {
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        Image(systemName: "mappin.circle.fill")
                            .font(.system(size: 16))
                            .foregroundColor(.red)
                            .padding(4)
                    }
                }
            }
        }
    }
}

struct FloorData {
    let title: String
    let rows: [FloorRow]
}

struct FloorRow: Identifiable {
    let id = UUID()
    let entrance: String?
    let rooms: [Room]
    
    init(entrance: String? = nil, rooms: [Room]) {
        self.entrance = entrance
        self.rooms = rooms
    }
}

struct Room: Identifiable {
    let id = UUID()
    let name: String
    let isWide: Bool
    
    init(name: String, isWide: Bool = false) {
        self.name = name
        self.isWide = isWide
    }
}

struct NavigationRoute {
    let start: String
    let end: String
    let floor: String
    let distance: Int
    let estimatedTime: Int
    let steps: [NavigationStep]
    let pathLocations: [String]
    
    static func getRoute(from start: String, to end: String, floor: String) -> NavigationRoute? {
        let allRoutes = getAllRoutes()
        return allRoutes.first { route in
            (route.start == start && route.end == end && route.floor == floor) ||
            (route.start == end && route.end == start && route.floor == floor)
        }
    }
    
    static func getAllRoutes() -> [NavigationRoute] {
        return [
            NavigationRoute(
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
            ),
            
            NavigationRoute(
                start: "Reception",
                end: "Pharmacy",
                floor: "Floor 1",
                distance: 65,
                estimatedTime: 3,
                steps: [
                    NavigationStep(instruction: "Start from Reception desk", stepNumber: 1, distance: 0),
                    NavigationStep(instruction: "Walk past the Waiting Area on your left", stepNumber: 2, distance: 20),
                    NavigationStep(instruction: "Continue past Emergency Department", stepNumber: 3, distance: 25),
                    NavigationStep(instruction: "Pass Entrance 2 and Waiting Area B", stepNumber: 4, distance: 15),
                    NavigationStep(instruction: "Pharmacy will be on your left", stepNumber: 5, distance: 5)
                ],
                pathLocations: ["Reception", "Waiting Area", "Emergency Dept", "Waiting Area\nB", "Pharmacy"]
            ),
            
            NavigationRoute(
                start: "Room 201",
                end: "Elevator",
                floor: "Floor 2",
                distance: 40,
                estimatedTime: 2,
                steps: [
                    NavigationStep(instruction: "Exit Room 201 and turn right", stepNumber: 1, distance: 5),
                    NavigationStep(instruction: "Walk straight down the corridor", stepNumber: 2, distance: 15),
                    NavigationStep(instruction: "Pass the Cardiology department", stepNumber: 3, distance: 10),
                    NavigationStep(instruction: "Elevator is ahead on your right", stepNumber: 4, distance: 10)
                ],
                pathLocations: ["Room 201", "Cardiology", "Pediatrics", "Elevator"]
            ),
            
            NavigationRoute(
                start: "Cardiology",
                end: "Orthopedics",
                floor: "Floor 2",
                distance: 55,
                estimatedTime: 2,
                steps: [
                    NavigationStep(instruction: "Exit Cardiology department", stepNumber: 1, distance: 0),
                    NavigationStep(instruction: "Turn left and walk to Pediatrics", stepNumber: 2, distance: 20),
                    NavigationStep(instruction: "Continue past Neurology department", stepNumber: 3, distance: 20),
                    NavigationStep(instruction: "Orthopedics is at the end of corridor", stepNumber: 4, distance: 15)
                ],
                pathLocations: ["Cardiology", "Pediatrics", "Neurology", "Orthopedics"]
            ),
            
            NavigationRoute(
                start: "Main Lab",
                end: "Cafeteria",
                floor: "Floor 3",
                distance: 70,
                estimatedTime: 3,
                steps: [
                    NavigationStep(instruction: "Leave Main Lab and turn left", stepNumber: 1, distance: 5),
                    NavigationStep(instruction: "Walk past X-Ray and MRI rooms", stepNumber: 2, distance: 20),
                    NavigationStep(instruction: "Continue past Blood Bank", stepNumber: 3, distance: 15),
                    NavigationStep(instruction: "Pass CT Scan and Pathology", stepNumber: 4, distance: 20),
                    NavigationStep(instruction: "Cafeteria entrance on your left", stepNumber: 5, distance: 10)
                ],
                pathLocations: ["Main Lab", "Blood Bank", "CT Scan", "Pathology", "Cafeteria"]
            ),
            
            NavigationRoute(
                start: "X-Ray",
                end: "Elevator",
                floor: "Floor 3",
                distance: 45,
                estimatedTime: 2,
                steps: [
                    NavigationStep(instruction: "Exit X-Ray room", stepNumber: 1, distance: 0),
                    NavigationStep(instruction: "Walk down the main corridor", stepNumber: 2, distance: 15),
                    NavigationStep(instruction: "Pass CT Scan on your right", stepNumber: 3, distance: 15),
                    NavigationStep(instruction: "Elevator is at the end", stepNumber: 4, distance: 15)
                ],
                pathLocations: ["X-Ray", "CT Scan", "Ultrasound", "Elevator"]
            )
        ]
    }
}

struct NavigationStep: Identifiable {
    let id = UUID()
    let instruction: String
    let stepNumber: Int
    let distance: Int
}

#Preview {
    IndoorNavigationView()
}
