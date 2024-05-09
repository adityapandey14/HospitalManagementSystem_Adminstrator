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
    func allocateRoom(roomType: String, roomNumber: String, patientID: String, doctorID: String, checkInDate: Date, checkOutDate: Date, completion: @escaping (Bool) -> Void) {
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
                completion(false)
            } else {
                print("Room allocated successfully!")
                completion(true) // Notify the caller that the room allocation was successful
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
    func getBookedRoomNumbers(checkInDate: Date, checkOutDate: Date, completion: @escaping ([String]) -> Void) {
        db.collection("Rooms")
            .whereField("checkInDate", isLessThanOrEqualTo: checkOutDate)
            .whereField("checkOutDate", isGreaterThanOrEqualTo: checkInDate)
            .getDocuments { (querySnapshot, error) in
                if let error = error {
                    print("Error fetching booked room numbers: \(error.localizedDescription)")
                    completion([])
                } else {
                    var bookedRoomNumbers: [String] = []
                    for document in querySnapshot!.documents {
                        if let roomNumber = document.data()["number"] as? String {
                            bookedRoomNumbers.append(roomNumber)
                        }
                    }
                    completion(bookedRoomNumbers)
                }
            }
    }
    func getBookedRoomsCount(completion: @escaping (Int) -> Void) {
        var uniqueRoomNumbers = Set<String>()
        
        db.collection("Rooms")
            .whereField("availability", isEqualTo: false)
            .getDocuments { snapshot, error in
                if let error = error {
                    print("Error fetching booked rooms: \(error.localizedDescription)")
                    completion(0)
                } else {
                    guard let documents = snapshot?.documents else {
                        completion(0)
                        return
                    }
                    
                    for document in documents {
                        if let roomNumber = document.data()["number"] as? String {
                            uniqueRoomNumbers.insert(roomNumber)
                        }
                    }
                    
                    completion(uniqueRoomNumbers.count)
                }
            }
    }

    func getAvailableRoomsCount(completion: @escaping (Int) -> Void) {
            db.collection("Rooms")
                .whereField("availability", isEqualTo: true)
                .getDocuments { snapshot, error in
                    if let error = error {
                        print("Error fetching available rooms: \(error.localizedDescription)")
                        completion(0)
                    } else {
                        completion(snapshot?.documents.count ?? 0)
                    }
                }
        }

    
    }

