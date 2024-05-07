//
//  Adminstrator_HMSApp.swift
//  Adminstrator_HMS
//
//  Created by Aditya Pandey on 19/04/24.
//

import SwiftUI
import Firebase

@main
struct Adminstrator_HMSApp: App {
    @StateObject var viewModel = AuthViewModel()
    @StateObject var billviewModel = BillViewModel()
    @StateObject var announcementViewModel = AnnouncementsViewModel()
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
     init(){ //to make tab bar have green accent on selected bar icon
        // FirebaseApp.configure()
         if #available(iOS 15.0, *) {
             let appearance = UITabBarAppearance()
             appearance.selectionIndicatorTintColor = UIColor.green
             UITabBar.appearance().scrollEdgeAppearance = appearance
         }
     }
     
     var body: some Scene {
         WindowGroup {
        //     onboardingPageSwiftUIView()
             ContentView()
                 .environmentObject(viewModel)
                 .environmentObject(billviewModel)
                 .environmentObject(announcementViewModel)
         }
     }
}

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()

    return true
  }
}
