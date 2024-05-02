//
//  InventoryManagementView.swift
//  Adminstrator_HMS
//
//  Created by Arnav on 02/05/24.
//

import SwiftUI

struct InventoryManagementView: View {
    @State private var selectedBloodGroupIndex = 0
    @State private var bloodQuantity = ""
    @State private var blooddec = ""
    @State private var oxygenQuantity = ""
    @State private var oxygenQuantitytodec = ""
    @State private var showAlert = false
    
    let bloodGroups = ["A+", "B+", "AB+", "O+", "A-", "B-", "AB-", "O-"]

    @ObservedObject var viewModel = InventoryViewModel()
    
    var body: some View {
        VStack {
            Picker("Blood Group", selection: $selectedBloodGroupIndex) {
                ForEach(0 ..< bloodGroups.count) {
                    Text(self.bloodGroups[$0])
                }
            }
            .pickerStyle(MenuPickerStyle())
            .padding()
            
            TextField("Blood Quantity", text: $bloodQuantity)
                .padding()
            
            Button("Add Blood") {
                if let quantity = Int(bloodQuantity) {
                    switch bloodGroups[selectedBloodGroupIndex] {
                        case "A+":
                            viewModel.updateBloodAPlus(quantity: quantity){}
                        case "B+":
                            viewModel.updateBloodBPlus(quantity: quantity){}
                        case "AB+":
                            viewModel.updateBloodABPlus(quantity: quantity){}
                        case "O+":
                            viewModel.updateBloodOPlus(quantity: quantity){}
                        case "A-":
                            viewModel.updateBloodAMinus(quantity: quantity){}
                        case "B-":
                            viewModel.updateBloodBMinus(quantity: quantity){}
                        case "AB-":
                            viewModel.updateBloodABMinus(quantity: quantity){}
                        case "O-":
                            viewModel.updateBloodOMinus(quantity: quantity){}
                        default:
                            break
                    }
                    bloodQuantity = ""
                }
            }
            .padding()
            
            
            TextField("Blood Quantity", text: $blooddec)
                .padding()
            Button("Blood Used") {
                if let quantity = Int(blooddec) {
                    switch bloodGroups[selectedBloodGroupIndex] {
                        case "A+":
                            viewModel.updateBloodAPlus(quantity: -(quantity)){}
                        case "B+":
                            viewModel.updateBloodBPlus(quantity: -(quantity)){}
                        case "AB+":
                            viewModel.updateBloodABPlus(quantity: -(quantity)){}
                        case "O+":
                            viewModel.updateBloodOPlus(quantity: -(quantity)){}
                        case "A-":
                            viewModel.updateBloodAMinus(quantity: -(quantity)){}
                        case "B-":
                            viewModel.updateBloodBMinus(quantity: -(quantity)){}
                        case "AB-":
                            viewModel.updateBloodABMinus(quantity: -(quantity)){}
                        case "O-":
                            viewModel.updateBloodOMinus(quantity: -(quantity)){}
                        default:
                            break
                    }
                    bloodQuantity = ""
                }
            }
            .padding()
            
            TextField("Oxygen Tank Quantity", text: $oxygenQuantity)
                .padding()
            
            Button("Add Oxygen Tank") {
                if let quantity = Int(oxygenQuantity) {
                    viewModel.updateOxygenTanks(quantity: quantity){}
                    oxygenQuantity = ""
                }
            }
            .padding()
            
            TextField("Oxygen Tank Quantity to decrease", text: $oxygenQuantitytodec)
                .padding()
            
            Button("Remove Oxygen Tank") {
                if let quantity = Int(oxygenQuantitytodec) {
                    viewModel.updateOxygenTanks(quantity: -(quantity)){}
                    oxygenQuantity = ""
                }
            }
            .padding()
            
        }
    }
}
