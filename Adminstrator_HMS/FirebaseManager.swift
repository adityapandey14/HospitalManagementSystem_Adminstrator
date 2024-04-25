//
//  FirebaseManager.swift
//  Adminstrator_HMS
//
//  Created by Aayushi on 25/04/24.
//

import FirebaseFirestore
import FirebaseFirestoreSwift

class FirebaseManager: ObservableObject {
    private var db = Firestore.firestore()
    
    func allocateRoom(roomType: String, roomNumber: String, patientID: String, doctorID: String, checkInDate: Date, checkOutDate: Date) {
        let roomData: [String: Any] = [
            "type": roomType,
            "number": roomNumber,
            "availability": false,
            "currentPatientID": patientID,
            "currentDoctorID": doctorID,
            "checkInDate": checkInDate,
            "checkOutDate": checkOutDate
        ]
        
        db.collection("Rooms").addDocument(data: roomData) { error in
            if let error = error {
                print("Error allocating room: \(error.localizedDescription)")
            } else {
                print("Room allocated successfully!")
            }
        }
    }
    
    func isRoomAvailable(roomNumber: String, checkInDate: Date, checkOutDate: Date, completion: @escaping (Bool) -> Void) {
        // Query Firestore to check if the room is available for the given dates
        db.collection("Rooms")
            .whereField("number", isEqualTo: roomNumber)
            .whereField("checkInDate", isLessThanOrEqualTo: checkOutDate)
            .whereField("checkOutDate", isGreaterThanOrEqualTo: checkInDate)
            .getDocuments { (querySnapshot, error) in
                if let error = error {
                    print("Error checking room availability: \(error.localizedDescription)")
                    completion(false)
                } else {
                    let bookings = querySnapshot?.documents ?? []
                    completion(bookings.isEmpty)
                }
            }
    }
}

