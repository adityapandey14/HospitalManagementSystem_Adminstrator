//
//  homepageComplete.swift
//  Adminstrator_HMS
//
//  Created by Aditya Pandey on 29/04/24.
//

import SwiftUI


struct homepageComplete: View {
    @State private var alertMessage: String = ""
    @State private var showingAlert = false
    var body: some View {
        NavigationStack {
            TabView {
                InventoryHome()
                    .tabItem {
                        Label("Home", systemImage: "house")
                            .padding(.top)
                    }
                InputPage()
                    .tabItem {
                        Label("Bills", systemImage: "doc.fill")
                            .padding(.top)
                    }

                MAIL()
                    .tabItem {
                        Label("codeGenerator" , systemImage: "calendar")
                    }
                
                
                RoomAllocationView()
                    .tabItem {
                        Label("Rooms" , systemImage: "shared.with.you")
                    }
                
               
                
                
            }
//            .onReceive(NotificationCenter.default.publisher(for: NSNotification.Name("LowStockAlert"))) { notification in
//                if let message = notification.object as? String {
//                    alertMessage = message
//                    showingAlert = true
//                }
//            }
//            .alert(isPresented: $showingAlert) {
//                Alert(title: Text("Low Stock"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
//            }
//            .accentColor(Color.accent)
        }
        .tint(Color.accent)
        .accentColor(Color.accent)
        //.navigationBarHidden(false)
//        .preferredColorScheme(.dark)
    }
}

#Preview {
    homepageComplete()
}
