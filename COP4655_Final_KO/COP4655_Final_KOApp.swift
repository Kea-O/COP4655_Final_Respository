//
//  COP4655_Final_KOApp.swift
//  COP4655_Final_KO
//
//  Created by Keagan O'Leary on 12/7/25.
//

import SwiftUI
import FirebaseCore

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        return true
    }
}

@main
struct COP4655_Final_KOApp: App {
    // register app delegate for Firebase setup
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    // Create some instances to pass into views:
    @StateObject var feedViewModel = FeedViewModel()
    @StateObject var downloadViewModel = DownloadViewModel()
    @StateObject var authViewModel = AuthViewModel()
    @StateObject var reviewViewModel = ReviewViewModel()
    
    // Persist user logins over app launches:
    @StateObject private var currentUser = CurrentUser()
    
    var body: some Scene {
        WindowGroup {
            NavigationView {
                ContentView()
                    .environmentObject(feedViewModel)
                    .environmentObject(downloadViewModel)
                    .environmentObject(currentUser)
                    .environmentObject(authViewModel)
                    .environmentObject(reviewViewModel)
            }
        }
    }
}
