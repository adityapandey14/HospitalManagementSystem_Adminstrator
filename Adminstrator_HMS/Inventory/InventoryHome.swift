//
//  InventoryHome.swift
//  Adminstrator_HMS
//
//  Created by Arnav on 02/05/24.
//

import SwiftUI

struct InventoryHome: View {
    var body: some View {
        NavigationView {
            VStack {
                NavigationLink(destination: InventoryView()) {
                    Text("View Inventory")
                        .padding()
                }
                
                NavigationLink(destination: InventoryManagementView()) {
                    Text("Manage Inventory")
                        .padding()
                }
            }
            .navigationBarTitle("Hospital Inventory")
        }
    }
}

