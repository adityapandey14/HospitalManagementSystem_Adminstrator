
import SwiftUI
import FirebaseFirestore

struct RoomAllocationView: View {
    @State private var selectedRoomType: String = "General Ward"
    @State private var selectedRoomNumber: String = "101"
    @State private var patientIDInput: String = ""
    @State private var doctorIDInput: String = ""
    @State private var checkInDate: Date = Date()
    @State private var checkOutDate: Date = Date()
    @State private var showAlert: Bool = false
    @State private var showAlert1: Bool = false
    @State private var alertMessage: String = ""
    @State private var allocationSuccess: Bool = false
    @ObservedObject var roomManager = FirebaseManager()
    
    let roomTypes = [
        "General Ward": ["101", "102", "103", "104", "105"],
        "AC": ["201", "202", "203", "204", "205"],
        "Non-AC": ["301", "302", "303", "304", "305"],
        "Twin Sharing": ["401", "402", "403", "404", "405"]
    ]
    
    @State private var availableRooms: [String] = []

    var body: some View {
       
           
                
                ZStack{
                    ScrollView{
                    VStack {
                        Text("Room Allocation")
                            .bold()
                            .font(.system(size: 35))
                            .padding(.trailing, 105)
                        HStack{
                            Text("Patient ID")
                                .foregroundColor(Color("AccentColor 1"))
                                .padding()
                            TextField("Enter PatientID", text: $patientIDInput)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .cornerRadius(20)
                                .foregroundColor(Color("AccentColor 1"))
                                .padding()
                                .background(Color(uiColor: .secondarySystemBackground))
                            
                        }
                        //.underlineTextField()
                        Divider()
                        HStack{
                            Text("Doctor ID")
                                .foregroundColor(Color(red:115/255, green:151/255, blue:180/255))
                                .padding()
                            TextField("Enter DoctorID", text: $doctorIDInput)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .cornerRadius(20)
                                .foregroundColor(Color("AccentColor 1"))
                                .padding()
                                .background(Color(uiColor: .secondarySystemBackground))
                        }
                        Divider()
                        
                        DatePicker("Check-in Date", selection: $checkInDate, in: Date()..., displayedComponents: .date)
                            .foregroundColor(Color("AccentColor 1"))
                            .padding()
                        Divider()
                        
                        DatePicker("Check-out Date", selection: $checkOutDate, in: checkInDate..., displayedComponents: .date)
                            .foregroundColor(Color("AccentColor 1"))
                            .padding()
                        Divider()
                        HStack {
                            Text("Type of Room")
                                .foregroundColor(Color("AccentColor 1"))
                                .padding()
                            Spacer()
                            Picker("Room Type", selection: $selectedRoomType) {
                                ForEach(roomTypes.keys.sorted(), id: \.self) {
                                    Text($0)
                                }
                            }
                            .pickerStyle(MenuPickerStyle())
                            .accentColor(Color("AccentColor 1"))
//                            .foregroundStyle(Color("AccentColor 1"))
                            // .padding()
                            .onReceive([selectedRoomType].publisher.first()) { _ in
                                filterAvailableRooms(selectedRoomType,checkInDate: checkInDate,checkOutDate: checkOutDate)
                            }
                        }
                        Divider()
                        HStack {
                            Text("Room Number")
                                .foregroundColor(Color("AccentColor 1"))
                                .padding()
                            Spacer()
                            Picker("Room Number", selection: $selectedRoomNumber) {
                                ForEach(availableRooms, id: \.self) { roomNumber in
                                    Text(roomNumber)
                                }
                            }
                            .pickerStyle(MenuPickerStyle())
                            .accentColor(Color("AccentColor 1"))
                            .padding()
                        }
                        Spacer()
                        
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
                                    ) { success in
                                        if success {
                                            allocationSuccess = true
                                        } else {
                                            showAlert = true
                                            alertMessage = "Failed to allocate the room."
                                        }
                                    }
                                } else {
                                    showAlert1 = true
                                    alertMessage = "This room is already booked for the selected dates. Please select another room or adjust the dates."
                                }
                            }
                            
                        }
                        .cornerRadius(10)
                        .foregroundColor(.black)
                        .frame(width: 357, height: 55)
                        .background(Color("AccentColor 1"))
                        .padding()
                        .disabled(
                            patientIDInput.isEmpty || doctorIDInput.isEmpty || selectedRoomNumber.isEmpty
                        )
                        
                        .alert(isPresented: Binding<Bool>(
                            get: {
                                return self.showAlert1 || self.allocationSuccess
                            },
                            set: { _ in }
                        )) {
                            if showAlert1 {
                                return Alert(title: Text("Room Booking"), message: Text(alertMessage), dismissButton: .default(Text("OK")) {
                                    // Reset showAlert1 state
                                    self.showAlert1 = false
                                })
                            } else if allocationSuccess {
                                return Alert(title: Text("Room Allocated"), message: Text("The room has been successfully allocated."), dismissButton: .default(Text("OK")) {
                                    // Reset allocationSuccess state
                                    self.allocationSuccess = false
                                })
                            } else {
                                return Alert(title: Text("Room not Allocated"), message: Text("The room has not been allocated."), dismissButton: .default(Text("OK")))
                            }
                        }
                        
                        
                        
                        
                        
                        
                        
                        
                    }
                    .padding()
                }
                    .background(Color(uiColor: .secondarySystemBackground))
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        //                    Button(action: {}) {
                        //                        HStack{
                        //                            Image(systemName: "chevron.left")
                        //                            Text("Back")
                        //                        }
                        //                        .foregroundColor(Color(red: 10/225, green: 29/255, blue: 59/255))
                        //                        .padding()
                        //                    }
                    }
                }
            }
        }
    

    private func filterAvailableRooms(_ roomType: String, checkInDate: Date, checkOutDate: Date) {
        roomManager.getBookedRoomNumbers(checkInDate: checkInDate, checkOutDate: checkOutDate) { [self] bookedRoomNumbers in
            // Filter available rooms based on booked room numbers
            if let rooms = self.roomTypes[roomType] {
                let availableRooms = rooms.filter { room in
                    return !bookedRoomNumbers.contains(room)
                }

                self.availableRooms = availableRooms
            } else {
                self.availableRooms = []
            }
        }
    }








}

struct RoomAllocationView_Previews: PreviewProvider {
    static var previews: some View {
        RoomAllocationView()
    }
}
