//
//  ContentView.swift
//  COP4655_Final_KO
//
//  Created by Keagan O'Leary on 12/7/25.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var feedViewModel: FeedViewModel
    @EnvironmentObject var downloadViewModel: DownloadViewModel
    @EnvironmentObject var currentUser: CurrentUser
    @EnvironmentObject var authViewModel: AuthViewModel

    var body: some View {
        if currentUser.isLoggedIn {
            TabView {
                NavigationStack {
                    FeedSearchView()
                }
                .tabItem {
                    Image(systemName: "magnifyingglass")
                    Text("Search")
                }

                NavigationStack {
                    DownloadFeedView()
                }
                .tabItem {
                    Image(systemName: "tray.and.arrow.down.fill")
                    Text("Downloads")
                }
            }
        } else {
            NavigationStack {
                LoginView()
                    .environmentObject(authViewModel)
            }
        }
    }
}

#Preview {
    ContentView()
}
