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
    @State var showAlert: Bool = false
    @State var alertMessage: String = ""
    private var isInitialFetchDone = false
    init(){
        fetchInventory {}
    }
    
    private var db = Firestore.firestore()
    
    func fetchInventory(completion: @escaping () -> Void) {
            var bloodFetched = false
            var oxygenFetched = false
            
            // Fetch blood inventory
        db.collection("blood").addSnapshotListener { [self] querySnapshot, error in
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
                                if !isInitialFetchDone { // Only trigger once during initial fetch
                                    checkLowStock()
                                    isInitialFetchDone = true
                                }
                                completion()
                            }
            }
            
            // Fetch oxygen inventory
        db.collection("oxygen").addSnapshotListener { [self] querySnapshot, error in
                guard let documents = querySnapshot?.documents else {
                    print("Error fetching oxygen documents: \(error!)")
                    return
                }
                self.oxygenTanks = documents.compactMap { queryDocumentSnapshot in
                    let data = queryDocumentSnapshot.data()
                    let quantity = data["quantity"] as? Int ?? 0
                    return OxygenTank(id: "", quantity: quantity)
                }
                oxygenFetched = true
                if bloodFetched && oxygenFetched {
                                if !isInitialFetchDone { // Only trigger once during initial fetch
                                    checkLowStock()
                                    isInitialFetchDone = true
                                }
                                completion()
                            }
            }
        }
    
    private func checkLowStock() {
            for bloodItem in bloodItems {
                if bloodItem.quantity < 10 {
                    showAlert(message: "Low stock of blood type \(bloodItem.id)")
                }
            }
            
            for oxygenTank in oxygenTanks {
                if oxygenTank.quantity < 10 {
                    showAlert(message: "Low stock of oxygen tanks")
                }
            }
        }
    private func showAlert(message: String) {
            // Post a notification with the message
            NotificationCenter.default.post(name: NSNotification.Name("LowStockAlert"), object: message)
        }
    
    private func updateBloodGroup(group: String, quantity: Int, completion: @escaping () -> Void) {
            // Get existing quantity
            var existingQuantity = 0
            if let bloodItem = self.bloodItems.first(where: { $0.id == group }) {
                existingQuantity = bloodItem.quantity
            }
            
            // Calculate new quantity
            let newQuantity = existingQuantity + quantity
            
            // Check if new quantity is valid
            guard newQuantity >= 0 else {
                showAlert(message: "Not enough blood available")
                return
            }
            
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
        // Get existing quantity
        var existingQuantity = 0
        if let oxygenTank = self.oxygenTanks.first {
            existingQuantity = oxygenTank.quantity
        }
        
        // Calculate new quantity
        let newQuantity = existingQuantity + quantity
        
        // Check if new quantity is valid
        guard newQuantity >= 0 else {
            showAlert(message: "Not enough oxygen tanks available")
            return
        }
        
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
