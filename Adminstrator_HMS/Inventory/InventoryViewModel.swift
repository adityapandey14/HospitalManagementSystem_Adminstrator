//
//  InventoryViewModel.swift
//  Adminstrator_HMS
//
//  Created by Arnav on 02/05/24.
//

import SwiftUI
import Firebase

class InventoryViewModel: ObservableObject {
    @Published var bloodItems: [Blood] = []
    @Published var oxygenTanks: [OxygenTank] = []
    init(){
        fetchInventory {}
    }
    
    private var db = Firestore.firestore()
    
    func fetchInventory(completion: @escaping () -> Void) {
        var bloodFetched = false
        var oxygenFetched = false
        
        // Fetch blood inventory
        db.collection("blood").addSnapshotListener { querySnapshot, error in
            guard let documents = querySnapshot?.documents else {
                print("Error fetching blood documents: \(error!)")
                return
            }
            self.bloodItems = documents.compactMap { queryDocumentSnapshot in
                let data = queryDocumentSnapshot.data()
                let id = queryDocumentSnapshot.documentID
                let quantity = data["quantity"] as? Int ?? 0
                return Blood(id: id, quantity: quantity)
            }
            bloodFetched = true
            if bloodFetched && oxygenFetched {
                completion()
            }
        }
        
        // Fetch oxygen inventory
        db.collection("oxygen").addSnapshotListener { querySnapshot, error in
                    guard let documents = querySnapshot?.documents else {
                        print("Error fetching oxygen documents: \(error!)")
                        return
                    }
                    self.oxygenTanks = documents.compactMap { queryDocumentSnapshot in
                        let data = queryDocumentSnapshot.data()
                        let quantity = data["quantity"] as? Int ?? 0
                        return OxygenTank(id:"",quantity: quantity)
                    }
                    oxygenFetched = true
                    if bloodFetched && oxygenFetched {
                        completion()
                    }
                }
    }
    
    private func updateBloodGroup(group: String, quantity: Int, completion: @escaping () -> Void) {
        var existingQuantity = 0
        if let bloodItem = self.bloodItems.first(where: { $0.id == group }) {
           existingQuantity = bloodItem.quantity
        }
        
        // Calculate new quantity
        let newQuantity = existingQuantity + quantity
        
        // Update quantity in Firebase
        db.collection("blood").document(group).updateData(["quantity": newQuantity]) { error in
            if let error = error {
                print("Error updating blood quantity: \(error)")
            } else {
                completion()
            }
        }
    }

    func updateBloodAPlus(quantity: Int, completion: @escaping () -> Void) {
        updateBloodGroup(group: "A+", quantity: quantity, completion: completion)
    }
    
    func updateBloodBPlus(quantity: Int, completion: @escaping () -> Void) {
        updateBloodGroup(group: "B+", quantity: quantity, completion: completion)
    }
    
    func updateBloodABPlus(quantity: Int, completion: @escaping () -> Void) {
        updateBloodGroup(group: "AB+", quantity: quantity, completion: completion)
    }
    
    func updateBloodOPlus(quantity: Int, completion: @escaping () -> Void) {
        updateBloodGroup(group: "O+", quantity: quantity, completion: completion)
    }
    
    func updateBloodAMinus(quantity: Int, completion: @escaping () -> Void) {
        updateBloodGroup(group: "A-", quantity: quantity, completion: completion)
    }
    
    func updateBloodBMinus(quantity: Int, completion: @escaping () -> Void) {
        updateBloodGroup(group: "B-", quantity: quantity, completion: completion)
    }
    
    func updateBloodABMinus(quantity: Int, completion: @escaping () -> Void) {
        updateBloodGroup(group: "AB-", quantity: quantity, completion: completion)
    }
    
    func updateBloodOMinus(quantity: Int, completion: @escaping () -> Void) {
        updateBloodGroup(group: "O-", quantity: quantity, completion: completion)
    }

    func updateOxygenTanks(quantity: Int, completion: @escaping () -> Void) {
            var existingQuantity = 0
            if let oxygenTank = self.oxygenTanks.first {
                existingQuantity = oxygenTank.quantity
            }
            
            // Calculate new quantity
            let newQuantity = existingQuantity + quantity
            
            // Update quantity in Firebase
            db.collection("oxygen").document("oxygentanks").updateData(["quantity": newQuantity]) { error in
                if let error = error {
                    print("Error updating oxygen tank quantity: \(error)")
                } else {
                    completion()
                }
            }
        }
    
    
}
