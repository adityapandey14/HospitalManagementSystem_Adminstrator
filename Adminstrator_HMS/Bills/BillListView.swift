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
                Text("Billing Date: \(bill.billingDate)")
                // Add more bill details as needed
            }
        }
        .onAppear {
            viewModel.fetchBills() // Fetch bills when the view appears
        }
    }
}
