//
//  BillListView.swift
//  Adminstrator_HMS
//
//  Created by Arnav on 06/05/24.
//

import SwiftUI

struct BillsListView: View {
    @EnvironmentObject var viewModel: BillViewModel

    var body: some View {
        List(viewModel.bills) { bill in
            VStack(alignment: .leading) {
                Text("Hospital Name: \(bill.hospitalName)")
                                Text("Hospital Address: \(bill.hospitalAddress)")
                                Text("Hospital Contact Info: \(bill.hospitalContactInfo)")
                                Text("Patient ID: \(bill.patientID)")
                                Text("Doctor ID: \(bill.doctorID)")
                                Text("Billing Date: \(bill.billingDate)")
                                ForEach(bill.items) { item in
                                    VStack(alignment: .leading) {
                                        Text("Item Description: \(item.description)")
                                        Text("Quantity: \(item.quantity ?? 0)")
                                        Text("Price Per Service: \(item.pricePerService ?? 0)")
                                        Text("Total Charge: \(item.totalCharge ?? 0)")
                                    }
                                }
                                Text("Total Amount Due: \(bill.totalAmountDue ?? 0)")
                                Text("Amount Paid: \(bill.amountPaid ?? 0)")
                                Text("Payment Method: \(bill.paymentMethod)")
                                Text("Payment Date: \(bill.paymentDate)")
                                Text("Outstanding Balance: \(bill.outstandingBalance ?? 0)")
                                Text("Notes: \(bill.notes ?? "")")
                                Text("Discounts or Adjustments: \(bill.discountsOrAdjustments ?? 0)")
                                Text("Taxes: \(bill.taxes ?? 0)")
                                Text("Referral Info: \(bill.referralInfo ?? "")")
            }.padding()
        }
        .onAppear {
            viewModel.fetchBills() // Fetch bills when the view appears
        }
    }
}

//#Preview {
//    BillsListView()
//}
