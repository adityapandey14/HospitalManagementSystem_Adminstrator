//
//  homepageComplete.swift
//  Adminstrator_HMS
//
//  Created by Aditya Pandey on 29/04/24.
//

import SwiftUI


struct homepageComplete: View {
    var body: some View {
        NavigationStack {
            TabView {
                InventoryHome()
                    .tabItem {
                        Label("Home", systemImage: "house")
                            .padding(.top)
                    }

                CodeGeneratorView()
                    .tabItem {
                        Label("codeGenerator" , systemImage: "calendar")
                    }
                
                EmailView()
                    .tabItem {
                        Label("Email" , systemImage: "shared.with.you")
                    }
                
                
                RoomAllocationView()
                    .tabItem {
                        Label("Rooms" , systemImage: "shared.with.you")
                    }
                
               
                
                
            }
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
