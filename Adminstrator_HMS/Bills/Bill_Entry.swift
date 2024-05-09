//
//  Bill_Entry.swift
//  Adminstrator_HMS
//
//  Created by Arnav on 06/05/24.
//

import SwiftUI

struct InputPage: View {
    @EnvironmentObject var viewModel: BillViewModel

    @State private var isShowingBillsList = false
    @State private var hospitalName = "MedNex"
    @State private var hospitalAddress = "India"
    @State private var hospitalContactInfo = "+91 6767545476"
    @State private var patientID = ""
    @State private var doctorID = ""
    @State private var billingDate = Date()
    @State private var items = [BillItem]()
    @State private var totalAmountDue: Double = 0
    @State private var amountPaid: Double = 0
    @State private var paymentMethod = ""
    @State private var paymentDate = Date()
    @State private var outstandingBalance: Double = 0
    @State private var notes = ""
    @State private var discountsOrAdjustments: Double = 0
    @State private var taxes: Double = 0
    @State private var referralInfo = ""

    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                Text("Bills")
                    .bold()
                    .font(.system(size: 35))
                    .padding(.trailing, 5)
                ZStack {
                    RoundedRectangle(cornerRadius: 8)
                        .foregroundStyle(Color(uiColor: .secondarySystemBackground))
                        .frame(width: 360, height: 140)
                    VStack {
                        Text("Patient Information")
                            .font(.headline)
                            .padding(.bottom, 10)
                        VStack {
                            Picker("Select Patient", selection: $patientID) {
                                if patientID.isEmpty {
                                    Text("Select a Patient")
                                        .foregroundColor(.gray)
                                        .tag("")
                                }
                                ForEach(viewModel.patients, id: \.id) { patient in
                                    Text(patient.name).tag(patient.id)
                                }
                            }
                            .pickerStyle(MenuPickerStyle())
                                .padding(.leading, 10)
                                .frame(width: 330)
//                                .background(Color("grad3"))
                                .cornerRadius(5)
                        }
                        .padding(.bottom, 10)
                    }
                }
                .padding(.bottom, 5)
                
                ZStack {
                    RoundedRectangle(cornerRadius: 8)
                        .foregroundStyle(Color(uiColor: .secondarySystemBackground))
                        .frame(width: 360, height: 50)
                    DatePicker("Billing Date", selection: $billingDate, displayedComponents: .date)
                        .padding()
                }

                Text("Items")
                    .font(.headline)
//                    .padding(.trailing, 50)
                ForEach(items.indices, id: \.self) { index in
                    ItemRowView(item: $items[index])
                }
                HStack {
                    Button(action: addItem) {
                        Text("Add Item")
                    }
                    .padding()
                    
                    // Other fields ...
                    
                    
                    Button(action: saveBill) {
                        Text("Save Bill")
                    }
                    .padding()
                    NavigationLink(destination: BillsListView(), isActive: $isShowingBillsList) {
                        EmptyView()
                    }
                    .hidden()
//                    .padding()
                    
                    Button(action: {
                        isShowingBillsList = true
                    }) {
                        Text("Past bills")
                    }
                    .padding()
                    .padding(.leading, 10)
                }
                .padding()
            }
            .padding()
            
        }
        .padding(.top, 20)
        .onAppear{viewModel.fetchPatients()}
        
    }

    private func addItem() {
        items.append(BillItem(description: "", quantity: nil, pricePerService: nil, totalCharge: nil))
    }

    private func saveBill() {
        let bill = Bill(hospitalName: hospitalName, hospitalAddress: hospitalAddress, hospitalContactInfo: hospitalContactInfo, patientID: patientID, doctorID: doctorID, billingDate: billingDate, items: items, totalAmountDue: totalAmountDue, amountPaid: amountPaid, paymentMethod: paymentMethod, paymentDate: paymentDate, outstandingBalance: outstandingBalance, notes: notes, discountsOrAdjustments: discountsOrAdjustments, taxes: taxes, referralInfo: referralInfo)
        viewModel.addBill(bill) // Call addBill function to save the bill
    }

}

struct ItemRowView: View {
    @Binding var item: BillItem

    @State private var quantityString = ""
    @State private var priceString = ""

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 8)
                .foregroundStyle(Color(uiColor: .secondarySystemBackground))
                .frame(width: 360, height: 100)
            VStack(alignment: .leading) {
                TextField("Description", text: $item.description)
                    .padding(.leading, 15)
                    .padding(.top)
//                    .padding()
                HStack {
                    TextField("Quantity", text: $quantityString)
//                        .padding(.leading, 10)
                        .padding()
                        .keyboardType(.numberPad)
                        .onChange(of: quantityString) { newValue in
                            if let quantity = Int(newValue) {
                                item.quantity = quantity
                                calculateTotalCharge() // Call calculateTotalCharge here
                            } else {
                                item.quantity = nil
                            }
                        }
                    
                    TextField("Price/Service", text: $priceString)
                        .keyboardType(.decimalPad)
                        .onChange(of: priceString) { newValue in
                            if let price = Double(newValue) {
                                item.pricePerService = price
                                calculateTotalCharge() // Call calculateTotalCharge here
                            } else {
                                item.pricePerService = nil
                            }
                        }
                    
                    Text("Bill Amount \(item.totalCharge ?? 0,specifier: "%.2f")")
                        .padding(.bottom)
                }
            }
        }
    }
    

    private func calculateTotalCharge() {
        guard let quantity = item.quantity, let pricePerService = item.pricePerService else {
            item.totalCharge = nil
            return
        }
        item.totalCharge = Double(quantity) * pricePerService
    }
}

//
struct InputPage_Previews : PreviewProvider {
    static var previews: some View{
        InputPage()
            .environmentObject(BillViewModel())
    }
}



