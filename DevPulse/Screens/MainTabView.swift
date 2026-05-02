//
//  MainTabView.swift
//  DevPulse
//
//  Created by David Messer on 5/2/26.
//

import SwiftUI

struct MainTabView: View {
    @Binding var username: String
    
    var body: some View {
        TabView {
            Tab("Profile", systemImage: "person.circle") {
                NavigationStack {
                    ProfileScreen(username: username)
                }
            }
            Tab("Repos", systemImage: "folder") {
                NavigationStack {
                    RepoListScreen(username: username)
                }
            }
            Tab("Search", systemImage: "magnifyingglass") {
                NavigationStack {
                    SearchScreen()
                }
            }
            Tab("Activity", systemImage: "bolt") {
                NavigationStack {
                    ActivityScreen(username: username)
                }
            }
            Tab("Settings", systemImage: "gear") {
                NavigationStack {
                    SettingsScreen(username: $username)
                }
            }
        }
    }
}

#Preview {
    @Previewable @State var username = ""
    
    MainTabView(username: $username)
}
