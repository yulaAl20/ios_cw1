//
//  IndoorNavigationView.swift
//  ios_cw1
//
//  Created by Oshadha Samarasinghe on 2026-03-05.
//

import SwiftUI

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
        
        if let exactMatch = allRoutes.first(where: {
            $0.start == start && $0.end == end && $0.floor == floor
        }) {
            return exactMatch
        }
        
        return allRoutes.first(where: {
            $0.start == end && $0.end == start && $0.floor == floor
        })
    }
    
    static func getAllRoutes() -> [NavigationRoute] {
        return [
            NavigationRoute(
                start: "Reception",
                end: "Waiting Area",
                floor: "Floor 1",
                distance: 35,
                estimatedTime: 2,
                steps: [
                    NavigationStep(instruction: "Start from Reception desk", stepNumber: 1, distance: 0),
                    NavigationStep(instruction: "Walk down the left corridor", stepNumber: 2, distance: 20),
                    NavigationStep(instruction: "Waiting Area is on your left", stepNumber: 3, distance: 15)
                ],
                pathLocations: ["Reception", "Waiting Area"]
                
            ),
            
            NavigationRoute(
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
            ),
            
            NavigationRoute(
                start: "Emergency Dept",
                end: "Reception",
                floor: "Floor 1",
                distance: 40,
                estimatedTime: 2,
                steps: [
                    NavigationStep(instruction: "Exit the Emergency Department", stepNumber: 1, distance: 0),
                    NavigationStep(instruction: "Walk up the main corridor", stepNumber: 2, distance: 20),
                    NavigationStep(instruction: "Turn right when you reach the junction", stepNumber: 3, distance: 10),
                    NavigationStep(instruction: "Walk up the main corridor till you reach Reception", stepNumber: 4, distance: 20)
                ],
                pathLocations: ["Emergency Dept", "Reception"]
            ),
            
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
                start: "Room 203",
                end: "Pediatrics",
                floor: "Floor 2",
                distance: 45,
                estimatedTime: 2,
                steps: [
                    NavigationStep(instruction: "Exit Room 203", stepNumber: 1, distance: 0),
                    NavigationStep(instruction: "Turn left and walk down the corridor", stepNumber: 2, distance: 15),
                    NavigationStep(instruction: "Continue past Cardiology department", stepNumber: 3, distance: 15),
                    NavigationStep(instruction: "Pediatrics is on your left", stepNumber: 4, distance: 15)
                ],
                pathLocations: ["Room 203", "Cardiology", "Pediatrics"]
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
            ),
            
            NavigationRoute(
                start: "MRI Scan",
                end: "Restroom",
                floor: "Floor 3",
                distance: 65,
                estimatedTime: 3,
                steps: [
                    NavigationStep(instruction: "Exit MRI Scan room", stepNumber: 1, distance: 0),
                    NavigationStep(instruction: "Turn left and walk along the corridor", stepNumber: 2, distance: 20),
                    NavigationStep(instruction: "Continue past Blood Bank and CT Scan", stepNumber: 3, distance: 25),
                    NavigationStep(instruction: "Turn left at Pathology", stepNumber: 4, distance: 15),
                    NavigationStep(instruction: "Restroom is on your left", stepNumber: 5, distance: 5)
                ],
                pathLocations: ["MRI Scan", "Blood Bank", "CT Scan", "Pathology", "Restroom"]
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

struct IndoorNavigationView: View {
    
    //@State private var selectedTab: Int = 3
    @EnvironmentObject var router: AppRouter
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
                HeaderView(title: "Navigation")
                    .padding(.horizontal, 20)
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
                                            resetInvalidLocations()
                                        }
                                    }
                                    Button("Floor 2") {
                                        withAnimation {
                                            selectedFloor = "Floor 2"
                                            resetInvalidLocations()
                                        }
                                    }
                                    Button("Floor 3") {
                                        withAnimation {
                                            selectedFloor = "Floor 3"
                                            resetInvalidLocations()
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
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 6)
                                    .background(Color(.systemGray6))
                                    .cornerRadius(8)
                                }
                                .menuStyle(.borderlessButton)
                                .fixedSize()
                            }
                            
                            GeometryReader { geo in
                                ZStack {
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(Color(.systemGray6))
                                    
                                    // Always show the map view here
                                    drawFloorMap(width: geo.size.width, height: geo.size.height)
                                }
                            }
                            .frame(height: 500)
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
                
                FloatingNavBarView(selectedTab: $router.currentTab)
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
        .fullScreenCover(isPresented: $isARMode) {
            if let route = currentRoute {
                NavigationARView(route: route)
            }
        }
    }
    
    private func drawFloorMap(width: CGFloat, height: CGFloat) -> some View {
        ZStack {
            drawCorridors(width: width, height: height)
            
            if hasValidRoute, let route = currentRoute {
                drawNavigationPath(route: route, width: width, height: height)
            }
            
            drawLocationChips(width: width, height: height)
        }
    }
    
    private func drawCorridors(width: CGFloat, height: CGFloat) -> some View {
        
        let mainVertical = width * 0.12
        let subVertical = width * 0.05
        
        let mainHorizontal = height * 0.1
        let subHorizontal = height * 0.04
        
        return ZStack {
            
            // MARK: MAIN VERTICAL CORRIDORS
            
            RoundedRectangle(cornerRadius: 6)
                .fill(Color(.systemGray5))
                .frame(width: mainVertical, height: height * 0.9)
                .position(x: width * 0.5, y: height * 0.5)
            
            RoundedRectangle(cornerRadius: 6)
                .fill(Color(.systemGray5))
                .frame(width: mainVertical, height: height * 0.9)
                .position(x: width * 0.25, y: height * 0.5)
            
            RoundedRectangle(cornerRadius: 6)
                .fill(Color(.systemGray5))
                .frame(width: mainVertical, height: height * 0.9)
                .position(x: width * 0.75, y: height * 0.5)
            
            
            // MARK: MAIN HORIZONTAL CORRIDORS
            
            RoundedRectangle(cornerRadius: 6)
                .fill(Color(.systemGray5))
                .frame(width: width * 0.85, height: mainHorizontal)
                .position(x: width * 0.5, y: height * 0.2)
            
            RoundedRectangle(cornerRadius: 6)
                .fill(Color(.systemGray5))
                .frame(width: width * 0.85, height: mainHorizontal)
                .position(x: width * 0.5, y: height * 0.5)
            
            RoundedRectangle(cornerRadius: 6)
                .fill(Color(.systemGray5))
                .frame(width: width * 0.85, height: mainHorizontal)
                .position(x: width * 0.5, y: height * 0.8)
            
            
            // MARK: SUB CORRIDORS (THIN)
            
            RoundedRectangle(cornerRadius: 4)
                .fill(Color(.systemGray4))
                .frame(width: subVertical, height: height * 0.35)
                .position(x: width * 0.62, y: height * 0.32)
            
            RoundedRectangle(cornerRadius: 4)
                .fill(Color(.systemGray4))
                .frame(width: subVertical, height: height * 0.35)
                .position(x: width * 0.38, y: height * 0.68)
            
            RoundedRectangle(cornerRadius: 4)
                .fill(Color(.systemGray4))
                .frame(width: width * 0.4, height: subHorizontal)
                .position(x: width * 0.3, y: height * 0.35)
            
            RoundedRectangle(cornerRadius: 4)
                .fill(Color(.systemGray4))
                .frame(width: width * 0.4, height: subHorizontal)
                .position(x: width * 0.7, y: height * 0.65)
            
    
            if selectedFloor == "Floor 1" {
                HStack(spacing: 4) {
                    Image(systemName: "door.left.hand.open")
                        .font(.system(size: 12))
                        .foregroundColor(.green)
                    
                    Text("Entrance")
                        .font(.system(size: 10, weight: .medium))
                        .foregroundColor(.green)
                }
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(Color.green.opacity(0.15))
                .cornerRadius(6)
                .position(x: width * 0.12, y: height * 0.2)
            }
        }
    }
    
    private func drawNavigationPath(route: NavigationRoute, width: CGFloat, height: CGFloat) -> some View {
        
        let positions = getLocationPositions(width: width, height: height)
        
        return ZStack {
            
            if (route.start == "Reception" && route.end == "Waiting Area") ||
               (route.start == "Waiting Area" && route.end == "Reception") {
                
                if let start = positions["Reception"],
                   let end = positions["Waiting Area"] {
                    
                    Path { path in
                        
                        path.move(to: start)
                        
                        path.addLine(to: CGPoint(x: width * 0.5, y: height * 0.2))
                        
                        path.addLine(to: CGPoint(x: width * 0.25, y: height * 0.2))
                        
                        path.addLine(to: CGPoint(x: width * 0.25, y: height * 0.32))
                        
                        path.addLine(to: end)
                    }
                    .stroke(
                        Color.blue,
                        style: StrokeStyle(lineWidth: 4, lineCap: .round)
                    )
                }
            }
            
            if (route.start == "Reception" && route.end == "Emergency Dept") ||
               (route.start == "Emergency Dept" && route.end == "Reception") {
                
                if let start = positions["Reception"],
                   let end = positions["Emergency Dept"] {
                    
                    Path { path in
                        
                        path.move(to: start)
                        
                        // Go down from Reception
                        path.addLine(to: CGPoint(x: width * 0.5, y: height * 0.35))
                        
                        // Turn left towards Emergency Dept
                        path.addLine(to: CGPoint(x: width * 0.35, y: height * 0.35))
                        
                        // Go down to Emergency Dept
                        path.addLine(to: end)
                    }
                    .stroke(
                        Color.blue,
                        style: StrokeStyle(lineWidth: 4, lineCap: .round)
                    )
                }
            }
            
            if (route.start == "Room 203" && route.end == "Pediatrics") ||
               (route.start == "Pediatrics" && route.end == "Room 203") {
                
                if let start = positions["Room 203"],
                   let end = positions["Pediatrics"] {
                    
                    Path { path in
                        
                        path.move(to: start)
                        
                        // Go down from Room 203
                        path.addLine(to: CGPoint(x: width * 0.52, y: height * 0.25))
                        
                        // Turn left towards the main corridor
                        path.addLine(to: CGPoint(x: width * 0.35, y: height * 0.25))
                        
                        // Go down past Cardiology
                        path.addLine(to: CGPoint(x: width * 0.35, y: height * 0.45))
                        
                        // Continue down to Pediatrics
                        path.addLine(to: end)
                    }
                    .stroke(
                        Color.blue,
                        style: StrokeStyle(lineWidth: 4, lineCap: .round)
                    )
                }
            }
            
            if (route.start == "MRI Scan" && route.end == "Restroom") ||
               (route.start == "Restroom" && route.end == "MRI Scan") {
                
                if let start = positions["MRI Scan"],
                   let end = positions["Restroom"] {
                    
                    Path { path in
                        
                        path.move(to: start)
                        
                        // Go left along the top corridor
                        path.addLine(to: CGPoint(x: width * 0.5, y: height * 0.15))
                        
                        // Continue left
                        path.addLine(to: CGPoint(x: width * 0.35, y: height * 0.15))
                        
                        // Go down to Blood Bank level
                        path.addLine(to: CGPoint(x: width * 0.35, y: height * 0.40))
                        
                        // Continue down to CT Scan level
                        path.addLine(to: CGPoint(x: width * 0.35, y: height * 0.58))
                        
                        // Continue down to Pathology level
                        path.addLine(to: CGPoint(x: width * 0.35, y: height * 0.72))
                        
                        // Turn left to Restroom
                        path.addLine(to: CGPoint(x: width * 0.25, y: height * 0.72))
                        
                        path.addLine(to: end)
                    }
                    .stroke(
                        Color.blue,
                        style: StrokeStyle(lineWidth: 4, lineCap: .round)
                    )
                }
            }
            
            if let start = positions[route.start] {
                Circle()
                    .fill(Color.blue)
                    .frame(width: 12, height: 12)
                    .position(start)
            }
            
            if let end = positions[route.end] {
                Circle()
                    .fill(Color.red)
                    .frame(width: 12, height: 12)
                    .position(end)
            }
        }
    }
    
    private func drawLocationChips(width: CGFloat, height: CGFloat) -> some View {
        let positions = getLocationPositions(width: width, height: height)
        let locations = getAllCurrentFloorLocations()
        
        return ZStack {
            ForEach(locations, id: \.self) { location in
                if let pos = positions[location] {
                    let isStart = location == startLocation
                    let isEnd = location == destination
                    let isOnPath = currentRoute?.pathLocations.contains(location) ?? false
                    
                    HStack(spacing: 4) {
                        Image(systemName: getLocationIcon(for: location))
                            .font(.system(size: 8))
                            .foregroundColor(isStart ? .blue : (isEnd ? .red : .secondary))
                        
                        Text(location.replacingOccurrences(of: "\n", with: " "))
                            .font(.system(size: 9, weight: .medium))
                            .foregroundColor(.primary)
                            .lineLimit(1)
                    }
                    .padding(.horizontal, 6)
                    .padding(.vertical, 4)
                    .background(
                        RoundedRectangle(cornerRadius: 6)
                            .fill(isStart ? Color.blue.opacity(0.15) : (isEnd ? Color.red.opacity(0.15) : Color.white))
                            .overlay(
                                RoundedRectangle(cornerRadius: 6)
                                    .stroke(
                                        isStart ? Color.blue : (isEnd ? Color.red : (isOnPath ? Color.blue.opacity(0.5) : Color(.systemGray4))),
                                        lineWidth: isStart || isEnd ? 1.5 : 1
                                    )
                            )
                    )
                    .shadow(color: Color.black.opacity(0.1), radius: 2, x: 0, y: 1)
                    .position(pos)
                }
            }
        }
    }
    
    private func getLocationPositions(width: CGFloat, height: CGFloat) -> [String: CGPoint] {
        
        switch selectedFloor {
            
        // MARK: FLOOR 1
        case "Floor 1":
            return [
                
                // Top horizontal corridor
                "Reception": CGPoint(x: width * 0.5, y: height * 0.15),
                "Registration": CGPoint(x: width * 0.65, y: height * 0.15),
                "Records": CGPoint(x: width * 0.82, y: height * 0.15),
                
                // Left vertical corridor
                "Waiting Area": CGPoint(x: width * 0.18, y: height * 0.32),
                "Restroom": CGPoint(x: width * 0.18, y: height * 0.50),
                
                // Middle main corridor
                "Emergency Dept": CGPoint(x: width * 0.35, y: height * 0.50),
                "Nurse Stn": CGPoint(x: width * 0.50, y: height * 0.40),
                
                // Right corridor
                "Elevator": CGPoint(x: width * 0.82, y: height * 0.50),
                
                // Bottom corridor
                "Pharmacy": CGPoint(x: width * 0.50, y: height * 0.88),
                "Billing": CGPoint(x: width * 0.82, y: height * 0.80)
            ]
            
            
        // MARK: FLOOR 2
        case "Floor 2":
            return [
                
                // Top corridor rooms
                "Room 201": CGPoint(x: width * 0.18, y: height * 0.15),
                "Room 202": CGPoint(x: width * 0.35, y: height * 0.15),
                "Room 203": CGPoint(x: width * 0.52, y: height * 0.15),
                "Vitals": CGPoint(x: width * 0.70, y: height * 0.15),
                
                // Middle corridor
                "Cardiology": CGPoint(x: width * 0.35, y: height * 0.40),
                "Nurses' Stn": CGPoint(x: width * 0.50, y: height * 0.32),
                
                // Sub corridor rooms
                "Pediatrics": CGPoint(x: width * 0.35, y: height * 0.58),
                "Restroom": CGPoint(x: width * 0.18, y: height * 0.50),
                
                // Main corridor
                "Elevator": CGPoint(x: width * 0.82, y: height * 0.50),
                
                // Bottom corridor
                "Neurology": CGPoint(x: width * 0.50, y: height * 0.72),
                "Waiting Area": CGPoint(x: width * 0.82, y: height * 0.72),
                
                "Orthopedics": CGPoint(x: width * 0.35, y: height * 0.88),
                "Records": CGPoint(x: width * 0.70, y: height * 0.88)
            ]
            
            
        // MARK: FLOOR 3
        case "Floor 3":
            return [
                
                // Top corridor
                "Main Lab": CGPoint(x: width * 0.25, y: height * 0.15),
                "X-Ray": CGPoint(x: width * 0.50, y: height * 0.15),
                "MRI Scan": CGPoint(x: width * 0.75, y: height * 0.15),
                
                "Records": CGPoint(x: width * 0.88, y: height * 0.30),
                
                // Middle corridor
                "Blood Bank": CGPoint(x: width * 0.35, y: height * 0.40),
                "Sample Room": CGPoint(x: width * 0.65, y: height * 0.40),
                
                // Sub corridor
                "CT Scan": CGPoint(x: width * 0.35, y: height * 0.58),
                "Ultrasound": CGPoint(x: width * 0.50, y: height * 0.50),
                
                // Main corridor
                "Elevator": CGPoint(x: width * 0.82, y: height * 0.58),
                
                // Bottom corridor
                "Pathology": CGPoint(x: width * 0.50, y: height * 0.72),
                "Restroom": CGPoint(x: width * 0.18, y: height * 0.72),
                
                "Cafeteria": CGPoint(x: width * 0.35, y: height * 0.88),
                "Billing": CGPoint(x: width * 0.70, y: height * 0.88)
            ]
            
        default:
            return [:]
        }
    }
    
    // Helper function to check if a location exists on a specific floor
    private func isLocationOnFloor(_ locationName: String, floor: String) -> Bool {
        let locations = getLocationPositionsForFloor(floor: floor, width: 100, height: 100)
        return locations.keys.contains(locationName)
    }
    
    // Helper function to get location positions for a specific floor
    private func getLocationPositionsForFloor(floor: String, width: CGFloat, height: CGFloat) -> [String: CGPoint] {
        switch floor {
        case "Floor 1":
            return [
                "Reception": CGPoint(x: width * 0.5, y: height * 0.15),
                "Registration": CGPoint(x: width * 0.65, y: height * 0.15),
                "Records": CGPoint(x: width * 0.82, y: height * 0.15),
                "Waiting Area": CGPoint(x: width * 0.18, y: height * 0.32),
                "Restroom": CGPoint(x: width * 0.18, y: height * 0.50),
                "Emergency Dept": CGPoint(x: width * 0.35, y: height * 0.50),
                "Nurse Stn": CGPoint(x: width * 0.50, y: height * 0.40),
                "Elevator": CGPoint(x: width * 0.82, y: height * 0.50),
                "Pharmacy": CGPoint(x: width * 0.50, y: height * 0.88),
                "Billing": CGPoint(x: width * 0.82, y: height * 0.80)
            ]
        case "Floor 2":
            return [
                "Room 201": CGPoint(x: width * 0.18, y: height * 0.15),
                "Room 202": CGPoint(x: width * 0.35, y: height * 0.15),
                "Room 203": CGPoint(x: width * 0.52, y: height * 0.15),
                "Vitals": CGPoint(x: width * 0.70, y: height * 0.15),
                "Cardiology": CGPoint(x: width * 0.35, y: height * 0.40),
                "Nurses' Stn": CGPoint(x: width * 0.50, y: height * 0.32),
                "Pediatrics": CGPoint(x: width * 0.35, y: height * 0.58),
                "Restroom": CGPoint(x: width * 0.18, y: height * 0.50),
                "Elevator": CGPoint(x: width * 0.82, y: height * 0.50),
                "Neurology": CGPoint(x: width * 0.50, y: height * 0.72),
                "Waiting Area": CGPoint(x: width * 0.82, y: height * 0.72),
                "Orthopedics": CGPoint(x: width * 0.35, y: height * 0.88),
                "Records": CGPoint(x: width * 0.70, y: height * 0.88)
            ]
        case "Floor 3":
            return [
                "Main Lab": CGPoint(x: width * 0.25, y: height * 0.15),
                "X-Ray": CGPoint(x: width * 0.50, y: height * 0.15),
                "MRI Scan": CGPoint(x: width * 0.75, y: height * 0.15),
                "Records": CGPoint(x: width * 0.88, y: height * 0.30),
                "Blood Bank": CGPoint(x: width * 0.35, y: height * 0.40),
                "Sample Room": CGPoint(x: width * 0.65, y: height * 0.40),
                "CT Scan": CGPoint(x: width * 0.35, y: height * 0.58),
                "Ultrasound": CGPoint(x: width * 0.50, y: height * 0.50),
                "Elevator": CGPoint(x: width * 0.82, y: height * 0.58),
                "Pathology": CGPoint(x: width * 0.50, y: height * 0.72),
                "Restroom": CGPoint(x: width * 0.18, y: height * 0.72),
                "Cafeteria": CGPoint(x: width * 0.35, y: height * 0.88),
                "Billing": CGPoint(x: width * 0.70, y: height * 0.88)
            ]
        default:
            return [:]
        }
    }
    
    // Helper function to reset locations if they don't exist on the selected floor
    private func resetInvalidLocations() {
        if !startLocation.isEmpty && !isLocationOnFloor(startLocation, floor: selectedFloor) {
            startLocation = ""
        }
        if !destination.isEmpty && !isLocationOnFloor(destination, floor: selectedFloor) {
            destination = ""
        }
    }
    
    private func getCorridorNodes(width: CGFloat, height: CGFloat) -> [String: CGPoint] {
        
        return [
            "topCenter": CGPoint(x: width * 0.5, y: height * 0.2),
            "midCenter": CGPoint(x: width * 0.5, y: height * 0.5),
            "bottomCenter": CGPoint(x: width * 0.5, y: height * 0.8),
            
            "leftMid": CGPoint(x: width * 0.25, y: height * 0.5),
            "rightMid": CGPoint(x: width * 0.75, y: height * 0.5),
            
            "leftTop": CGPoint(x: width * 0.25, y: height * 0.2),
            "rightTop": CGPoint(x: width * 0.75, y: height * 0.2),
            
            "leftBottom": CGPoint(x: width * 0.25, y: height * 0.8),
            "rightBottom": CGPoint(x: width * 0.75, y: height * 0.8)
        ]
    }
    
    private func getAllCurrentFloorLocations() -> [String] {
        return currentFloorData.rows.flatMap { row in
            row.rooms.map { $0.name }
        }
    }
    
    private func getLocationIcon(for location: String) -> String {
        let name = location.lowercased()
        
        if name.contains("elevator") {
            return "arrow.up.arrow.down.circle"
        } else if name.contains("restroom") {
            return "toilet"
        } else if name.contains("pharmacy") {
            return "cross.case"
        } else if name.contains("emergency") {
            return "cross.circle"
        } else if name.contains("lab") || name.contains("blood") {
            return "drop"
        } else if name.contains("x-ray") || name.contains("mri") || name.contains("ct") {
            return "waveform"
        } else if name.contains("cafeteria") {
            return "fork.knife"
        } else if name.contains("waiting") {
            return "person.2"
        } else if name.contains("reception") || name.contains("registration") {
            return "person.circle"
        } else if name.contains("billing") {
            return "creditcard"
        } else if name.contains("records") {
            return "doc"
        } else if name.contains("nurse") {
            return "stethoscope"
        } else if name.contains("room") || name.contains("cardiology") || name.contains("pediatrics") || name.contains("neurology") || name.contains("orthopedics") {
            return "bed.double"
        } else if name.contains("vitals") {
            return "heart.circle"
        } else if name.contains("sample") {
            return "eyedropper"
        } else if name.contains("ultrasound") {
            return "waveform.circle"
        } else if name.contains("pathology") {
            return "testtube.2"
        } else {
            return "mappin"
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

#Preview {
    IndoorNavigationView()
        .environmentObject(AppRouter())
        .environmentObject(AppointmentStore())
}
