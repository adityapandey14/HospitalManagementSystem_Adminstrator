//
//  DoctorModal.swift
//  Adminstrator_HMS
//
//  Created by Aditya Pandey on 09/05/24.
//


import Foundation
import SwiftUI
import FirebaseFirestore

struct DoctorModel: Identifiable, Equatable, Codable {
    var id: String
    var fullName: String
    var descript: String
    var gender: String
    var mobileno: String
    var experience: String
    var qualification: String
    var dob: Date?
    var address: String
    var pincode: String
    var department: String
    var speciality: String
    var cabinNo: String
    var profilephoto: String?
}

class DoctorViewModel: ObservableObject {
    @Published var doctorDetails: [DoctorModel] = []
    private let db = Firestore.firestore()
    static let shared = DoctorViewModel()
    
    init(){
        Task {
            await fetchDoctorDetails()
        }
    }

    func fetchDoctorDetails() async {
        do {
            let snapshot = try await db.collection("doctor").getDocuments()
            
            var details: [DoctorModel] = []
            for document in snapshot.documents {
                let data = document.data()
                let id = document.documentID
                
                // Extract values safely, providing default values or handling unexpected types
                let fullName = data["fullName"] as? String ?? ""
                let descript = data["descript"] as? String ?? ""
                let gender = data["gender"] as? String ?? ""
                let mobileno = data["mobileno"] as? String ?? ""
                let experience = data["experience"] as? String ?? "" // Fixed field name
                let qualification = (data["qualification"] as? String ?? "") // Fixed expected type
                let dob = data["dob"] as? Timestamp // If Firestore stores Date as Timestamp
                let dateOfBirth = dob?.dateValue() // Convert Timestamp to Date
                let address = data["address"] as? String ?? ""
                let pincode = data["pincode"] as? String ?? ""
                let department = data["department"] as? String ?? ""
                let speciality = data["speciality"] as? String ?? ""
                let cabinNo = data["cabinNo"] as? String ?? ""
                let profilephoto = data["profilephoto"] as? String

                let doctorDetail = DoctorModel(
                    id: id,
                    fullName: fullName,
                    descript: descript,
                    gender: gender,
                    mobileno: mobileno,
                    experience: experience,
                    qualification: qualification,
                    dob: dateOfBirth, // Set converted date
                    address: address,
                    pincode: pincode,
                    department: department,
                    speciality: speciality,
                    cabinNo: cabinNo,
                    profilephoto: profilephoto
                )
                
                details.append(doctorDetail)
            }
            
            // Update the property within the main thread
            DispatchQueue.main.async {
                self.doctorDetails = details
            }
        } catch {
            print("Error fetching Doctor details: \(error.localizedDescription)")
        }
    }

    func fetchDoctorDetailsByID(doctorID: String) async {
        do {
            let document = try await db.collection("doctor").document(doctorID).getDocument()
            
            if document.exists {
                if let data = document.data() {
                    let dob = data["dob"] as? Timestamp // Convert to Timestamp
                    let dateOfBirth = dob?.dateValue() // Convert Timestamp to Date
                    
                    let doctorDetail = DoctorModel(
                        id: document.documentID,
                        fullName: data["fullName"] as? String ?? "",
                        descript: data["descript"] as? String ?? "",
                        gender: data["gender"] as? String ?? "",
                        mobileno: data["mobileno"] as? String ?? "",
                        experience: data["experience"] as? String ?? "",
                        qualification: data["qualification"] as? String ?? "",
                        dob: dateOfBirth,
                        address: data["address"] as? String ?? "",
                        pincode: data["pincode"] as? String ?? "",
                        department: data["department"] as? String ?? "",
                        speciality: data["speciality"] as? String ?? "",
                        cabinNo: data["cabinNo"] as? String ?? "",
                        profilephoto: data["profilephoto"] as? String ?? ""
                    )
                    
                    // Update the property on the main thread
                    DispatchQueue.main.async {
                        self.doctorDetails = [doctorDetail]
                    }
                }
            } else {
                print("Doctor document does not exist")
            }
        } catch {
            print("Error fetching Doctor details: \(error.localizedDescription)")
        }
    }
}






let dummyDoctor = DoctorModel(
    id: "1",
    fullName: "Dr. John Smith",
    descript: "Expert in cardiology",
    gender: "Male",
    mobileno: "1234567890",
    experience: "10 years",
    qualification: "MD",
    dob: Date(timeIntervalSince1970: 0),  // Example date (Jan 1, 1970)
    address: "123 Medical Lane",
    pincode: "123456",
    department: "Cardiology",
    speciality: "Cardiologist",
    cabinNo: "101",
    profilephoto: "https://www.example.com/doctor-profile.jpg"  // Example image URL
)
