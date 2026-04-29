//
//  SearchScreen.swift
//  DevPulse
//
//  Created by David Messer on 4/28/26.
//

import SwiftUI

struct SearchScreen: View {
    @State private var searchText = ""
    @State private var results: [GitHubUserSummary] = []
    
    var body: some View {
        List(results) { user in
            NavigationLink(value: user.login) {
                UserSearchRow(user: user)
            }
        }
        .navigationDestination(for: String.self) { username in
            ProfileScreen(username: username)
        }
        .searchable(text: $searchText, prompt: "Search GitHub users...")
        .task(id: searchText) {
            guard !searchText.isEmpty else {
                results = []
                return
            }
            
            do {
                try await Task.sleep(for: .milliseconds(500))
                let users = try await GitHubAPI.searchUsers(searchText)
                results = users
            } catch is CancellationError {
                // silent fail
            } catch {
                results = []
            }
        }
    }
}

#Preview {
    SearchScreen()
}
