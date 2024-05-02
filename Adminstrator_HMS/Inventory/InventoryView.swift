//
//  InventoryView.swift
//  Adminstrator_HMS
//
//  Created by Arnav on 02/05/24.
//

import SwiftUI

struct InventoryView: View {
    @ObservedObject var viewModel = InventoryViewModel()
    
    var body: some View {
        VStack {
            Text("Blood Inventory")
                .font(.title)
            List {
                ForEach(viewModel.bloodItems) { blood in
                    Text("\(blood.id): \(blood.quantity)")
                }
            }
            
            Text("Oxygen Tanks Inventory")
                .font(.title)
            List {
                ForEach(viewModel.oxygenTanks) { tank in
                    Text("Quantity: \(tank.quantity)")
                }
            }
        }
        .onAppear {
            viewModel.fetchInventory() {}
        }
    }
}

