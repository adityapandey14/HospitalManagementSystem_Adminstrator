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
            Spacer()
            Text("Blood Inventory")
                .bold()
                .font(.title)
            List {
                Section(header: Text("Blood Group          Quantity              Capacity")){
                    ForEach(viewModel.bloodItems) { blood in
                        Text("\(blood.id)                         \(blood.quantity)                          350")
                            .multilineTextAlignment(.center)
                    }
                    
                }
            }
            Spacer()
            
            Text("Oxygen Inventory")
//                .padding(.top)
//                .padding(.top, 5)
                .bold()
                .font(.title)
            List {
                Section(header: Text("Number of Tanks")) {
                    ForEach(viewModel.oxygenTanks) { tank in
                        Text("Quantity                \(tank.quantity)")
                    }
                }
            }
            .frame(height: 130)
        }
        .onAppear {
            viewModel.fetchInventory() {}
        }
    }
}


struct InventoryView_Previews: PreviewProvider {
    static var previews: some View {
        InventoryView()
    }
}


