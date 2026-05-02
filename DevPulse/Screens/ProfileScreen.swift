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
    @State private var loadState: LoadState<ProfileData> = .idle
    
    var body: some View {
        Group {
            switch loadState {
            case .idle, .loading:
                ProgressView("Loading profile...")
                
            case .loaded(let profileData):
                ScrollView {
                    ProfileHeaderView(user: profileData.user)
                    
                    if !profileData.recentRepos.isEmpty {
                        SectionCard(title: "Recent Repos", icon: "folder") {
                            ForEach(profileData.recentRepos) { repo in
                                RepoCard(repo: repo)
                            }
                        }
                    }
                    NavigationLink("View All Repos", value: RepoNavigation(username: username))
                        .padding()
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
            await loadProfileData(forceRefresh: false)
        }
        .refreshable {
            await loadProfileData(forceRefresh: true)
        }
    }
    
    func loadProfileData(forceRefresh: Bool) async {
        loadState = .loading
        
        do {
            async let userRequest = GitHubAPI.fetchUser(username)
            async let reposRequest = GitHubAPI.fetchRepos(for: username)
            async let eventsRequest = GitHubAPI.fetchEvents(for: username)
            
            let user = try await userRequest
            let repos = try? await reposRequest
            let events = try? await eventsRequest
            
            let profileData = ProfileData(
                user: user,
                recentRepos: Array((repos ?? []).prefix(5)),
                recentActivity: events ?? []
            )
            loadState = .loaded(profileData)
        } catch {
            loadState = .error(error.localizedDescription)
        }
    }
}

#Preview {
    ProfileScreen(username: "Messerr")
}
