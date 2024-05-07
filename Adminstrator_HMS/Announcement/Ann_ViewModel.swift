//
//  Ann_ViewModel.swift
//  Adminstrator_HMS
//
//  Created by Arnav on 07/05/24.
//

import Foundation
import Firebase

class AnnouncementsViewModel: ObservableObject {
    @Published var announcements: [Announcement] = []

    private var db = Firestore.firestore()

    init() {
        // Fetch announcements from Firebase when the view model is initialized
        fetchAnnouncements()
    }

    func addAnnouncement(text: String, dateTime: Date) {
        let id = UUID().uuidString
        db.collection("announcements").document(id).setData([
            "text": text,
            "dateTime": Timestamp(date: dateTime)
        ]) { error in
            if let error = error {
                print("Error adding document: \(error)")
            } else {
                print("Document added with ID: \(id)")
                // Update local announcements after adding
            }
        }
    }

    private func fetchAnnouncements() {
        db.collection("announcements").addSnapshotListener { querySnapshot, error in
            guard let documents = querySnapshot?.documents else {
                print("Error fetching documents: \(error!)")
                return
            }

            self.announcements = documents.compactMap { document in
                let data = document.data()
                guard let text = data["text"] as? String,
                      let dateTime = data["dateTime"] as? Timestamp else {
                    return nil
                }

                return Announcement(id: document.documentID, text: text, dateTime: dateTime.dateValue())
            }
        }
    }
}
