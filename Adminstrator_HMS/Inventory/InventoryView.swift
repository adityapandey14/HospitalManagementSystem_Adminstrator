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
        NavigationStack {
            VStack(spacing: 20) {
                
                VStack(spacing: 10) {
                    HStack{
                        Text("Oxygen Inventory")
                            .font(.title2)
                        Spacer()
                        NavigationLink(destination: InventoryManagementView()) {
                            
                            Image(systemName: "square.and.pencil")
                                .foregroundColor(.accentColor1)

                            Text("Update")
                                .font(.headline)
                                .fontWeight(.bold)
                                .padding()
                                .cornerRadius(10)
                                .foregroundColor(.accentColor1)
                        }
                    }
                    
                    List {
                        Section(header: Text("Number of Tanks")) {
                            ForEach(viewModel.oxygenTanks) { tank in
                                Text("Quantity                \(tank.quantity)")
                            }
                        }
                    }
                    .frame(height: 100)
                }
                
                VStack(spacing: 10) {
                    HStack {
                        Text("Blood Inventory")
                            .font(.title2)
                        Spacer()
                    }
                    
                    List {
                        Section(header:
                            HStack {
                                Text("Blood Group")
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                Spacer()
                                Text("Quantity")
                                    .frame(maxWidth: .infinity, alignment: .center)
                                Spacer()
                                Text("Capacity")
                                    .frame(maxWidth: .infinity, alignment: .trailing)
                            }
                        ) {
                            ForEach(viewModel.bloodItems) { blood in
                                HStack {
                                    Text(blood.id)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                    Spacer()
                                    Text("\(blood.quantity)")
                                        .frame(maxWidth: .infinity, alignment: .center)
                                    Spacer()
                                    Text("350")
                                        .frame(maxWidth: .infinity, alignment: .trailing)
                                }
                                .padding(.vertical, 8)
                            }
                        }
                    }
                    .listStyle(GroupedListStyle())
                    .cornerRadius(10)
                }
            }
            .padding()
            .onAppear {
                viewModel.fetchInventory() {}
            }
        }
    }
}



struct InventoryView_Previews: PreviewProvider {
    static var previews: some View {
        InventoryView()
    }
}


