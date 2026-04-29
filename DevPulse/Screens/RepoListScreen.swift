//
//  RepoListScreen.swift
//  DevPulse
//
//  Created by David Messer on 4/28/26.
//

import SwiftUI

struct RepoListScreen: View {
    let username: String
    @State private var loadState: LoadState<Void> = .idle
    @State private var repos: [GitHubRepo] = []
    @State private var currentPage = 1
    @State private var hasMorePages = true
    @State private var isLoadingMore = false
    
    var body: some View {
        Group {
            switch loadState {
            case .idle, .loading:
                ProgressView("Loading repos...")
            case .loaded:
                ScrollView {
                    LazyVStack {
                        ForEach(repos) { repo in
                            RepoCard(repo: repo)
                                .onAppear {
                                    if repo.id == repos.last?.id {
                                        loadMoreIfNeeded()
                                    }
                                }
                        }
                        
                        if isLoadingMore {
                            ProgressView()
                                .padding()
                        }
                        
                        if !hasMorePages && !repos.isEmpty {
                            Text("All repos loaded")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                                .padding()
                        }
                    }
                    .padding()
                }
            case .error(let message):
                ContentUnavailableView {
                    Label("Failed to Load", systemImage: "wifi.exclamationmark")
                } description: {
                    Text(message)
                } actions: {
                    Button("Retry") { loadState = .idle }
                }
            }
        }
        .navigationTitle("Repositories")
        .task {
            await loadRepos()
        }
        .refreshable {
            await loadRepos()
        }
    }
    
    func loadRepos() async {
        loadState = .loading
        do {
            let initialRepos = try await GitHubAPI.fetchRepos(for: username, page: 1)
            repos = initialRepos
            currentPage = 1
            hasMorePages = initialRepos.count >= 30
            loadState = .loaded(())
        } catch {
            loadState = .error(error.localizedDescription)
        }
    }
    
    func loadMore() async {
        isLoadingMore = true
        do {
            let newRepos = try await GitHubAPI.fetchRepos(for: username, page: currentPage + 1)
            let existingIDs = Set(repos.map(\.id))
            let uniqueNew = newRepos.filter { !existingIDs.contains($0.id) }
            repos.append(contentsOf: uniqueNew)
            print("total: \(repos.count)")
            if newRepos.count < 30 || uniqueNew.isEmpty {
                hasMorePages = false
                print("No more pages")
            }
            currentPage += 1
        } catch {
            print("Load more error: \(error)")
        }
        isLoadingMore = false
    }
    
    func loadMoreIfNeeded() {
        guard hasMorePages && !isLoadingMore else { return }
        isLoadingMore = true
        Task {
            await loadMore()
        }
    }
}

#Preview {
    RepoListScreen(username: "Messerr")
}
