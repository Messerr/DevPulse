//
//  ContentView.swift
//  DevPulse
//
//  Created by David Messer on 4/28/26.
//

import SwiftUI

struct ContentView: View {
    let username = "Messerr"
    
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
					SettingsScreen()
				}
			}
        }
    }
}

#Preview {
    ContentView()
}
