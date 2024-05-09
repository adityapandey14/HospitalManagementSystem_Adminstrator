//
//  InventoryHome.swift
//  Adminstrator_HMS
//
//  Created by Arnav on 02/05/24.
//

import SwiftUI

struct InventoryHome: View {
    
    @State private var isHovering = false
    var body: some View {
        NavigationView {
            ZStack {
                
//                LinearGradient(gradient: Gradient(colors: [Color.white, Color.white.opacity(0.0)]), startPoint: .top, endPoint: .bottom)
                
                
                VStack {
                    ZStack {
                        ZStack {
//                            LinearGradient(gradient: Gradient(colors: [Color.white, Color.gray]), startPoint: .topLeading, endPoint: .bottomTrailing)
                            RoundedRectangle(cornerRadius: 8)
                                .frame(width: 350, height: 150)
                                .foregroundStyle(Color(uiColor: .secondarySystemBackground))
                                .opacity(isHovering ? 0.8 : 1.0)
                        }
                        NavigationLink(destination: InventoryView()) {
                            Text("View Inventory")
                                .bold()
                                .font(.system(size: 28))
                                .padding()
                        }
                    }
                    .onHover(perform: { hovering in
                        self.isHovering = hovering
                    })
                    
                    
                    ZStack {
                        RoundedRectangle(cornerRadius: 8)
                            .frame(width: 350, height: 150)
                            .foregroundStyle(Color(uiColor: .secondarySystemBackground))
                        NavigationLink(destination: InventoryManagementView()) {
                            Text("Manage Inventory")
                                .bold()
                                .font(.system(size: 28))
                                .padding()
                        }
                    }
                    
                    ZStack {
                        RoundedRectangle(cornerRadius: 8)
                            .frame(width: 350, height: 150)
                            .foregroundStyle(Color(uiColor: .secondarySystemBackground))
                        NavigationLink(destination: Analytics()) {
                            Text("View Analytics")
                                .bold()
                                .font(.system(size: 28))
                                .padding()
                        }
                    }
                    
                }
                .padding(.bottom, 60)
                .navigationBarTitle("Dashboard")
            }
        }
    }
}

struct InventoryHome_Previews: PreviewProvider {
    static var previews: some View {
        InventoryHome()
    }
}
