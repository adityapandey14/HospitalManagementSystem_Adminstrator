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
    @State private var hospitalName = ""
    @State private var hospitalAddress = ""
    @State private var hospitalContactInfo = ""
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
                Text("Hospital Information")
                    .font(.headline)
                TextField("Hospital Name", text: $hospitalName)
                TextField("Hospital Address", text: $hospitalAddress)
                TextField("Hospital Contact Info", text: $hospitalContactInfo)

                Text("Patient & Doctor Information")
                    .font(.headline)
                TextField("Patient ID", text: $patientID)
                TextField("Doctor ID", text: $doctorID)

                DatePicker("Billing Date", selection: $billingDate, displayedComponents: .date)

                Text("Items")
                    .font(.headline)
                ForEach(items.indices, id: \.self) { index in
                    ItemRowView(item: $items[index])
                }
                Button(action: addItem) {
                    Text("Add Item")
                }

                // Other fields ...
                

                Button(action: saveBill) {
                    Text("Save Bill")
                }
                NavigationLink(destination: BillsListView(), isActive: $isShowingBillsList) {
                                        EmptyView()
                                    }
                                    .hidden()

                                    Button(action: {
                                        isShowingBillsList = true
                                    }) {
                                        Text("Go to Bill List")
                                    }
            }
            .padding()
        }
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
        VStack(alignment: .leading) {
            TextField("Description", text: $item.description)
            HStack {
                TextField("Quantity", text: $quantityString)
                    .keyboardType(.numberPad)
                    .onChange(of: quantityString) { newValue in
                        if let quantity = Int(newValue) {
                            item.quantity = quantity
                            calculateTotalCharge() // Call calculateTotalCharge here
                        } else {
                            item.quantity = nil
                        }
                    }

                TextField("Price per Service", text: $priceString)
                    .keyboardType(.decimalPad)
                    .onChange(of: priceString) { newValue in
                        if let price = Double(newValue) {
                            item.pricePerService = price
                            calculateTotalCharge() // Call calculateTotalCharge here
                        } else {
                            item.pricePerService = nil
                        }
                    }

                Text("Total Charge: \(item.totalCharge ?? 0,specifier: "%.2f")")
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

#Preview {
    InputPage()
}




