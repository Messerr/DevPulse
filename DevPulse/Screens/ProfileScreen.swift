//
//  ProfileScreen.swift
//  DevPulse
//
//  Created by David Messer on 4/28/26.
//

import SwiftUI

struct ProfileScreen: View {
    let username: String
    @State private var user: GitHubUser?
    @State private var loadState: LoadState<GitHubUser> = .idle
    
    var body: some View {
        Group {
            switch loadState {
            case .idle, .loading:
                ProgressView("Loading profile...")
                
            case .loaded(let user):
                ScrollView {
                    ProfileHeaderView(user: user)
                    
                    NavigationLink("View Repos", value: RepoNavigation(username: username))
                }
                .navigationDestination(for: RepoNavigation.self) { nav in
                    RepoListScreen(username: nav.username)
                }
                
            case .error(let message):
                ContentUnavailableView {
                    Label("Something Went Wrong", systemImage: "wifi.exclamationmark")
                } description: {
                    Text(message)
                } actions: {
                    Button("Try Again") { loadState = .idle }
                }
            }
        }
        .task {
            guard case .idle = loadState else { return }
            loadState = .loading
            do {
                let user = try await GitHubAPI.fetchUser(username)
                loadState = .loaded(user)
            } catch {
                loadState = .error(error.localizedDescription)
            }
        }
    }
}

#Preview {
    ProfileScreen(username: "Messerr")
}
