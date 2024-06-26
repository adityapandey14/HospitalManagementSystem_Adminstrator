//
//  BillViewmodel.swift
//  Adminstrator_HMS
//
//  Created by Arnav on 06/05/24.
//

import SwiftUI
import Firebase

class BillViewModel: ObservableObject {
    @Published var patients = [Patient]()
    @Published var bills = [Bill]()
    private var db = Firestore.firestore()

    func addBill(_ bill: Bill) {
        do {
            let _ = try db.collection("bills").addDocument(from: bill)
        } catch {
            print("Error adding bill: \(error.localizedDescription)")
        }
    }
    
    func fetchPatients() {
        db.collection("patient").addSnapshotListener { (querySnapshot, error) in
            guard let documents = querySnapshot?.documents else {
                print("No documents")
                return
            }
            self.patients = documents.map { queryDocumentSnapshot -> Patient in
                let data = queryDocumentSnapshot.data()
                let id = queryDocumentSnapshot.documentID
                let name = data["fullName"] as? String ?? ""
                return Patient(id: id, name:name)
            }
        }
    }

    func fetchBills() {
        db.collection("bills").addSnapshotListener { querySnapshot, error in
            guard let documents = querySnapshot?.documents else {
                print("Error fetching documents: \(error?.localizedDescription ?? "Unknown error")")
                return
            }

            self.bills = documents.compactMap { queryDocumentSnapshot in
                do {
                    let bill = try queryDocumentSnapshot.data(as: Bill.self)
                    return bill
                } catch {
                    print("Error decoding bill: \(error.localizedDescription)")
                    return nil
                }
            }
        }
    }

    func updateBill(_ bill: Bill) {
            guard let billID = bill.id else { return }
            do {
                try db.collection("bills").document(billID).setData(from: bill)
            } catch {
                print("Error updating bill: \(error.localizedDescription)")
            }
        }
    }
