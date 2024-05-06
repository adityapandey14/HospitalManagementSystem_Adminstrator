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
            
            Text("Manage Inventory")
                .bold()
                .font(.system(size: 30))
                .padding(.bottom, 40)
            
            ZStack {
                
                RoundedRectangle(cornerRadius: 8)
                    .frame(width: 379, height: 200)
                    .foregroundStyle(Color("solitude"))
                VStack {
                    
                    
                    Text("Manage Blood")
                        .bold()
                        .padding(.trailing, 210)
                        .padding(.top)
                        .padding(.bottom)
                        .font(.system(size: 20))
                    HStack {
                        Picker("Blood Group", selection: $selectedBloodGroupIndex) {
                            ForEach(0 ..< bloodGroups.count) {
                                Text(self.bloodGroups[$0])
                            }
                        }
                        .pickerStyle(MenuPickerStyle())
                        .padding()
                        
                        TextField("Blood Quantity", text: $bloodQuantity)
                            .padding(.leading, 30)
                        //                        .frame(height: 60)
                        
                        
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
                    }
                    
                    HStack {
                        TextField("Blood Quantity", text: $blooddec)
                            .padding(.leading, 131)
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
                    }
                }
            }
            
            ZStack {
                
                RoundedRectangle(cornerRadius: 8)
                    .frame(width: 379, height: 200)
                    .foregroundStyle(Color("solitude"))
                VStack {
                    Text("Manage Oxygen")
                        .bold()
                        .padding(.top)
                        .font(.system(size: 20))
                        .padding(.trailing, 190)
                        .padding(.bottom)
                    
                    HStack {
                        TextField("Number of Tanks", text: $oxygenQuantity)
                            .padding(.leading, 30)
                        
                        Button("Add Tanks") {
                            if let quantity = Int(oxygenQuantity) {
                                viewModel.updateOxygenTanks(quantity: quantity){}
                                oxygenQuantity = ""
                            }
                        }
                        .padding()
                    }
                    
                    HStack {
                        TextField("Number of Tanks", text: $oxygenQuantitytodec)
                            .padding(.leading, 30)
                        
                        Button("Remove Tanks") {
                            if let quantity = Int(oxygenQuantitytodec) {
                                viewModel.updateOxygenTanks(quantity: -(quantity)){}
                                oxygenQuantity = ""
                            }
                        }
                        .padding()
                    }
                }
            }
            .padding(.bottom, 150)
            .padding(.top)
        }
        .padding(.top)
    }
}

struct InventoryManagementView_Previews: PreviewProvider {
    static var previews: some View {
        InventoryManagementView()
    }
}
