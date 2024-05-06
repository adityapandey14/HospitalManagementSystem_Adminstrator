//
//  BillModel.swift
//  Adminstrator_HMS
//
//  Created by Arnav on 06/05/24.
//

import SwiftUI

// Bill Item Struct
struct BillItem: Identifiable, Codable {
    var id = UUID()
    var description: String
    var quantity: Int?
    var pricePerService: Double?
    var totalCharge: Double?
}

// Bill Struct
struct Bill: Identifiable, Codable {
    var id : String?
    var creationTimestamp = Date()

    var hospitalName: String
    var hospitalAddress: String
    var hospitalContactInfo: String

    var patientID: String
    var doctorID: String

    var billingDate = Date()
    var items: [BillItem]

    var totalAmountDue: Double?
    var amountPaid: Double?
    var paymentMethod: String
    var paymentDate = Date()
    var outstandingBalance: Double?

    var notes: String?

    var discountsOrAdjustments: Double?
    var taxes: Double?
    var referralInfo: String?
}
