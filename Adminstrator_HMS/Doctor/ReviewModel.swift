//
//  ReviewModal.swift
//  Adminstrator_HMS
//
//  Created by Aditya Pandey on 09/05/24.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore
import FirebaseFirestoreSwift
import Combine



struct ReviewData :  Identifiable, Codable ,  Equatable {
    var id : String
    var comment : String
    var patientId : String
    var doctorId : String
    var ratingStar : Int
    var appointmentId : String
    
    
}


class ReviewViewModel : ObservableObject {
    @Published var reviewDetails = [ReviewData]()
    private let db = Firestore.firestore()
    static let shared = ReviewViewModel()
    
    init() {
        // Initialize the view model asynchronously
        fetchReviewDetail()
    }
    
    func fetchReviewDetail() {
           Task {
               do {
                   let snapshot = try await db.collection("review").getDocuments()
                   DispatchQueue.main.async {
                       var details: [ReviewData] = []
                       for document in snapshot.documents {
                           if let reviewDetail = self.parseReviewData(from: document) {
                               details.append(reviewDetail)
                           }
                       }
                       self.reviewDetails = details
                   }
               } catch {
                   print("Error fetching review details: \(error.localizedDescription)")
               }
           }
       }

       // New function to fetch reviews by a specific doctorId
       func fetchReviewDetailByDoctorId(doctorId: String) {
           Task {
               do {
                   let snapshot = try await db.collection("review")
                                             .whereField("doctorId", isEqualTo: doctorId)
                                             .getDocuments()
                   DispatchQueue.main.async {
                       var details: [ReviewData] = []
                       for document in snapshot.documents {
                           if let reviewDetail = self.parseReviewData(from: document) {
                               details.append(reviewDetail)
                           }
                       }
                       self.reviewDetails = details
                   }
               } catch {
                   print("Error fetching review details by doctorId: \(error.localizedDescription)")
               }
           }
       }

       // Utility function to parse ReviewData from a Firestore document
       private func parseReviewData(from document: QueryDocumentSnapshot) -> ReviewData? {
           let data = document.data()
           let id = document.documentID
           let comment = data["comment"] as? String ?? ""
           let patientId = data["patientId"] as? String ?? ""
           let doctorId = data["doctorId"] as? String ?? ""
           let ratingStar = data["ratingStar"] as? Int ?? 0
           let appointmentId = data["appointmentId"] as? String ?? ""

           return ReviewData(id: id,
                             comment: comment,
                             patientId: patientId,
                             doctorId: doctorId,
                             ratingStar: ratingStar,
                             appointmentId: appointmentId)
       }
       
    
    func addReview(appointmentId : String , comment: String, ratingStar: Int, doctorId: String) async throws {
        let db = Firestore.firestore()
        guard let userId = Auth.auth().currentUser?.uid else {
            throw NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Current user not found"])
        }

        // Create a dictionary representing the review data
        let data: [String: Any] = [
            "appointmentId" : appointmentId,
            "comment": comment,
            "ratingStar": ratingStar,
            "doctorId": doctorId,
            "time": Date(),
            "userId": userId
           
            
        ]

        do {
            // Add the document to the "review" collection
            try await db.collection("review").addDocument(data: data)
            print("Review added successfully to \(doctorId) collection")
        } catch {
            print("Error adding document: \(error.localizedDescription)")
            throw error
        }
    } //End of the function
    
    
   
    
}

struct ReviewModel: View {
    @ObservedObject var reviewViewModel = ReviewViewModel()
    @State private var isFetching = false
    var body: some View {
        NavigationStack{
          
            
            HStack{
                let reviewsForSkillOwner = reviewViewModel.reviewDetails.filter { $0.doctorId == "2" }
                if !reviewsForSkillOwner.isEmpty {
                    //Calculating Average of the doctor
                    let averageRating = reviewsForSkillOwner.reduce(0.0) { $0 + Double($1.ratingStar) } / Double(reviewsForSkillOwner.count)
            
                    Text("\(averageRating, specifier: "%.1f") ⭐️")
                        .font(AppFont.smallReg)
            
                    Text("\(reviewsForSkillOwner.count) Review\(reviewsForSkillOwner.count == 1 ? "" : "s")")
                        .font(AppFont.smallReg)
                } else {
                    Text("no reviews")
                        .font(AppFont.smallReg)
                        .foregroundColor(.black).opacity(0.3)
    
                }
                Spacer()
            }
            .padding()

            .font(AppFont.smallReg)
            .onAppear() {
                reviewViewModel.fetchReviewDetail()
                }
            
            
        } //End of the Navigation View
        
        
    }
}

#Preview {
    ReviewModel()
}
