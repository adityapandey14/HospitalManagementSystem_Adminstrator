//
//  RoomAlloocationView.swift
//  Adminstrator_HMS
//
//  Created by Aayushi on 25/04/24.
//

import SwiftUI

struct RoomAllocationView: View {
    @State private var selectedRoomType: String = "General Ward"
    @State private var selectedRoomNumber: String = ""
    @State private var patientIDInput: String = ""
    @State private var doctorIDInput: String = ""
    @State private var checkInDate: Date = Date()
    @State private var checkOutDate: Date = Date()
    @State private var showAlert: Bool = false
    @State private var alertMessage: String = ""
    
    @ObservedObject var roomManager = FirebaseManager()
    
    let roomTypes = [
        "General Ward": ["101", "102", "103", "104", "105"],
        "AC": ["201", "202", "203", "204", "205"],
        "Non-AC": ["301", "302", "303", "304", "305"],
        "Twin Sharing": ["401", "402", "403", "404", "405"]
    ]
    
    var availableRooms: [String] {
        return roomTypes[selectedRoomType] ?? []
    }
    
    var body: some View {
        VStack {
            HStack {
                Text("Select the room type")
                Picker("Room Type", selection: $selectedRoomType) {
                    ForEach(roomTypes.keys.sorted(), id: \.self) {
                        Text($0)
                    }
                }
                .pickerStyle(MenuPickerStyle())
                .padding()
            }
            
            HStack {
                Text("Select the available room number")
                Picker("Room Number", selection: $selectedRoomNumber) {
                    ForEach(availableRooms, id: \.self) { roomNumber in
                        Text(roomNumber)
                    }
                }
                .pickerStyle(MenuPickerStyle())
                .padding()
            }
            
            TextField("Enter Patient ID", text: $patientIDInput)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            TextField("Enter Doctor ID", text: $doctorIDInput)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            DatePicker("Check-in Date", selection: $checkInDate, in: Date()..., displayedComponents: .date)
                .padding()

            DatePicker("Check-out Date", selection: $checkOutDate, in: checkInDate..., displayedComponents: .date)
                .padding()
            
            Button("Allocate Room") {
                roomManager.isRoomAvailable(roomNumber: selectedRoomNumber, checkInDate: checkInDate, checkOutDate: checkOutDate) { available in
                    if available {
                        roomManager.allocateRoom(
                            roomType: selectedRoomType,
                            roomNumber: selectedRoomNumber,
                            patientID: patientIDInput,
                            doctorID: doctorIDInput,
                            checkInDate: checkInDate,
                            checkOutDate: checkOutDate
                        )
                    } else {
                        showAlert = true
                        alertMessage = "This room is already booked for the selected dates. Please select another room or adjust the dates."
                    }
                }
            }
            .padding()
            .alert(isPresented: $showAlert) {
                Alert(title: Text("Room Booking"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
            }
        }
        .padding()
    }
}

struct RoomAllocationView_Previews: PreviewProvider {
    static var previews: some View {
        RoomAllocationView()
    }
}

