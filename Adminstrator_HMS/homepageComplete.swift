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
                Homepage()
                    .tabItem {
                        Label("Home", systemImage: "house")
                            .padding(.top)
                    }

                CodeGeneratorView()
                    .tabItem {
                        Label("Timetable" , systemImage: "calendar")
                    }
                
                EmailView()
                    .tabItem {
                        Label("Requests" , systemImage: "shared.with.you")
                    }
                
                
                RoomAllocationView()
                    .tabItem {
                        Label("Requests" , systemImage: "shared.with.you")
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
