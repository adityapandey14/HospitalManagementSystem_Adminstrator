//
//  ContentView.swift
//  Adminstrator_HMS
//
//  Created by Aditya Pandey on 19/04/24.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var viewModel : AuthViewModel
    @ObservedObject var inventoryViewModel = InventoryViewModel()
    @State private var alertMessage: String = ""
    @State private var showingAlert = false
    var body: some View {
        //Imageview() use this for image upload and retrival
        Group {
            if $viewModel.userSession.wrappedValue != nil{
                homepageComplete()
            } else {
                loginView()
            }
        }.onReceive(NotificationCenter.default.publisher(for: NSNotification.Name("LowStockAlert"))) { notification in
            if let message = notification.object as? String {
                alertMessage = message
                showingAlert = true
            }
        }
        .alert(isPresented: $showingAlert) {
            Alert(title: Text("Low Stock"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
        }
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
    
}
