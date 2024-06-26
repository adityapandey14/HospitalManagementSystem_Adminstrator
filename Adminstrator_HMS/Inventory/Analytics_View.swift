//
//  Analytics_View.swift
//  Adminstrator_HMS
//
//  Created by Arnav on 08/05/24.
//

import Foundation
import SwiftUI
import Charts
import FirebaseFirestore

struct Analytics: View {
    @EnvironmentObject var viewModel: InventoryViewModel
    @StateObject private var firebaseManager = FirebaseManager()
    @State private var availableRoomsCount = 0
    @State private var bookedRoomsCount = 0
    
    var body: some View {
        ScrollView {
            VStack {
                VStack {
                    Text("Blood")
                        .font(.title)
                        .padding()
                    
                    // Bar graph for blood inventory
                    BarChart(data: bloodChartData())
                        .frame(height: 200)
                        .padding()
                    
                    Text("Oxygen Tanks")
                        .font(.title)
                        .padding()
                    
                    // Pie chart for oxygen tank inventory
                    DoughnutChart(data: oxygenTankChartData())
                        .frame(width: 200, height: 200)
                        .padding()
                    
                    HStack {
                        HStack {
                            RoundedRectangle(cornerRadius: 10)
                                .frame(width: 30, height: 30)
                                .foregroundStyle(Color.red)
                            Text("Total Tanks")
                        }
                        .padding(.trailing, 10)
                        HStack {
                            RoundedRectangle(cornerRadius: 10)
                                .frame(width: 30, height: 30)
                                .foregroundStyle(Color("turqoise"))
                            Text("Available Tanks")
                        }
                    }
                }
                .onAppear {
                    viewModel.fetchInventory {}
                }
                Spacer()
                VStack {
                    Text("Room Availability")
                        .font(.title)
                        .padding()
                    
                    // Doughnut chart for room availability
                    DoughnutChart1(availableRooms: (20-bookedRoomsCount), bookedRooms: bookedRoomsCount)
                        .frame(width: 200, height: 200)
                        .padding()
                    
                    // Update counts asynchronously
                    VStack {
                        HStack {
                            RoundedRectangle(cornerRadius: 10)
                                .frame(width: 30, height: 30)
                                .foregroundStyle(Color("messageAccent"))
                            Text("Available Rooms: \(20-bookedRoomsCount)")
                        }
                        HStack {
                            RoundedRectangle(cornerRadius: 10)
                                .frame(width: 30, height: 30)
                                .foregroundStyle(Color("littleDarkAccent"))
                            Text("Booked Rooms: \(bookedRoomsCount)")
                        }
                        .padding(.trailing)
                    }
                    .onAppear {
                        // Fetch room availability data
                        fetchRoomAvailability()
                    }
                }
                
            }
        }
    }
    
    // Function to prepare data for the bar chart
    func bloodChartData() -> [ChartData] {
        var chartData: [ChartData] = []
        for bloodItem in viewModel.bloodItems {
            let data = ChartData(label: bloodItem.id, value: Double(bloodItem.quantity))
            chartData.append(data)
        }
        return chartData
    }
    
    func fetchRoomAvailability() {
            // Get the count of available rooms
            firebaseManager.getAvailableRoomsCount { count in
                availableRoomsCount = count
            }
            
            // Get the count of booked rooms
            firebaseManager.getBookedRoomsCount { count in
                bookedRoomsCount = count
            }
        }
    
    // Function to prepare data for the pie chart
    func oxygenTankChartData() -> [ChartData] {
        let totalOxygen = 350
        let availableOxygen = viewModel.oxygenTanks.reduce(0) { $0 + $1.quantity }
        let usedOxygen = totalOxygen - availableOxygen
        
        // Include the existing oxygen quantity in the chart data
        let existingOxygen = viewModel.oxygenTanks.first?.quantity ?? 0
        
        let chartData = [
            ChartData(label: "Total Capacity", value: Double(totalOxygen)),
            ChartData(label: "Available", value: Double(availableOxygen))
        ]
        return chartData
    }
}



// Model for chart data
struct ChartData: Identifiable {
    let id = UUID()
    let label: String
    let value: Double
}

// Bar chart view

struct BarChart: View {
    let data: [ChartData]
    var body: some View {
        Chart() {
            ForEach(data, id: \.label) { item in
                BarMark(
                    x: .value("Blood Type", item.label),
                    y: .value("Quantity", item.value)
                )
            }
        }
        .chartYScale(domain: [0, 350])
    }
}

// Doughnut chart view
struct DoughnutChart: View {
    let data: [ChartData]
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Circle()
                    .fill(Color(uiColor: .secondarySystemBackground)) // Set the inner circle color to match the background
                    .frame(width: geometry.size.width * 0.5, height: geometry.size.height * 0.5) // Adjust size of the inner circle as needed
                
                ForEach(0..<data.count) { index in
                    DoughnutSlice(startAngle: angle(index), endAngle: angle(index + 1))
                        .fill(Color(hue: Double(index) / Double(data.count), saturation: 1.0, brightness: 1.0))
                }
            }
        }
    }
    
    func angle(_ index: Int) -> Angle {
        let total = data.reduce(0) { $0 + $1.value }
        let startAngle = index == 0 ? 0 : data[0..<index].reduce(0) { $0 + $1.value / total * 360 }
        let endAngle = data[0..<index].reduce(0) { $0 + $1.value / total * 360 }
        return Angle(degrees: startAngle + (endAngle - startAngle) / 2)
    }
}

// Doughnut slice shape
struct DoughnutSlice: Shape {
    let startAngle: Angle
    let endAngle: Angle
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let radius = min(rect.width, rect.height) / 2
        let innerRadius = radius * 0.5 // Adjust inner radius as needed
        path.move(to: CGPoint(x: center.x + radius * CGFloat(cos(startAngle.radians)), y: center.y + radius * CGFloat(sin(startAngle.radians))))
        path.addArc(center: center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: false)
        path.addLine(to: CGPoint(x: center.x + innerRadius * CGFloat(cos(endAngle.radians)), y: center.y + innerRadius * CGFloat(sin(endAngle.radians))))
        path.addArc(center: center, radius: innerRadius, startAngle: endAngle, endAngle: startAngle, clockwise: true)
        path.closeSubpath()
        return path
    }
}



struct DoughnutChart1: View {
    let availableRooms: Int
    let bookedRooms: Int
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Circle()
                    .fill(Color(uiColor: .secondarySystemBackground)) // Set the inner circle color to match the background
                    .frame(width: geometry.size.width * 0.5, height: geometry.size.height * 0.5) // Adjust size of the inner circle as needed
                
                // Booked rooms slice
                DoughnutSlice(startAngle: .degrees(0), endAngle: .degrees(Double(bookedRooms) / Double(availableRooms + bookedRooms) * 360))
                    .fill(Color("messageAccent"))
                
                // Available rooms slice
                DoughnutSlice(startAngle: .degrees(Double(bookedRooms) / Double(availableRooms + bookedRooms) * 360), endAngle: .degrees(360))
                    .fill(Color("littleDarkAccent"))
            }
        }
    }
}

struct DoughnutSlice1: Shape {
    let startAngle: Angle
    let endAngle: Angle
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let radius = min(rect.width, rect.height) / 2
        path.move(to: center)
        path.addArc(center: center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: false)
        path.closeSubpath()
        return path
    }
}

struct Analytics_Previews: PreviewProvider {
    static var previews: some View {
        Analytics()
            .environmentObject(InventoryViewModel())
    }
}
