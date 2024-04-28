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
        NavigationView {
            ZStack{
                VStack {
                    HStack{
                        Text("Patient ID")
                            .foregroundColor(Color(red:115/255, green:151/255, blue:180/255))
                        TextField("Enter PatientID", text: $patientIDInput)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .cornerRadius(20)
                            .foregroundColor(Color(red:115/255, green:151/255, blue:180/255))
                            .padding()
                            
                    }
                    .underlineTextField()
                    HStack{
                        Text("Doctor ID")
                            .foregroundColor(Color(red:115/255, green:151/255, blue:180/255))
                        TextField("Enter DoctorID", text: $patientIDInput)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .cornerRadius(20)
                            .foregroundColor(Color(red:115/255, green:151/255, blue:180/255))
                            .padding()
                    }

                    HStack {
                        Text("Type of Room")
                            .foregroundColor(Color(red:115/255, green:151/255, blue:180/255))
                        Spacer()
                        Picker("Room Type", selection: $selectedRoomType) {
                            ForEach(roomTypes.keys.sorted(), id: \.self) {
                                Text($0)
                            }
                        }
                        .pickerStyle(MenuPickerStyle())
                        .accentColor(Color(red:10/255, green:29/255, blue:59/255))
                       // .padding()
                    }
                    
                    HStack {
                        Text("Room Number")
                            .foregroundColor(Color(red:115/255, green:151/255, blue:180/255))
                        Spacer()
                        Picker("Room Number", selection: $selectedRoomNumber) {
                            ForEach(availableRooms, id: \.self) { roomNumber in
                                Text(roomNumber)
                            }
                        }
                        .pickerStyle(MenuPickerStyle())
                        .accentColor(Color(red:10/255, green:29/255, blue:59/255))
                        .padding()
                    }
                    

                    
                    DatePicker("Check-in Date", selection: $checkInDate, in: Date()..., displayedComponents: .date)
                        .foregroundColor(Color(red:115/255, green:151/255, blue:180/255))
                        
                    
                    DatePicker("Check-out Date", selection: $checkOutDate, in: checkInDate..., displayedComponents: .date)
                        .foregroundColor(Color(red:115/255, green:151/255, blue:180/255))
                       
                    
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
                    .foregroundColor(.white)
                    .cornerRadius(30)
                    .frame(width:357, height:55)
                    .background(Color(red:10/255, green:29/255, blue:59/255))
                    .padding()
                    .alert(isPresented: $showAlert) {
                        Alert(title: Text("Room Booking"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
                    }
                }
                .padding()
            }
            .background(Color(red:236/255, green:241/255, blue:247/255))
            .navigationBarTitle("Room Allocation")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        
                    }) {
                        HStack{
                            Image(systemName: "chevron.left")
                            Text("Back")
                               
                        }
                        .foregroundColor(Color(red: 10/225, green: 29/255, blue: 59/255))
                            .padding()
                            
                    }
                }    }
        }
    }
}
    

struct RoomAllocationView_Previews: PreviewProvider {
    static var previews: some View {
        RoomAllocationView()
    }
}
