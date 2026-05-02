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
                            NavigationLink(value: repo) {
                                RepoCard(repo: repo)
                            }
                            .buttonStyle(.plain)
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
                .navigationDestination(for: GitHubRepo.self) { repo in
                    RepoDetailScreen(repo: repo)
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
            await loadRepos(forceRefresh: true)
        }
    }
    
    func loadRepos(forceRefresh: Bool = false) async {
		loadState = .loading
		print("Auth token: \(GitHubAPI.authToken != nil ? "set" : "nil")")
		do {
			let initialRepos: [GitHubRepo]
			if GitHubAPI.authToken != nil {
				initialRepos = try await GitHubAPI.fetchMyRepos(page: 1, forceRefresh: forceRefresh)
			} else {
				initialRepos = try await GitHubAPI.fetchRepos(for: username, page: 1, forceRefresh: forceRefresh)
			}
			repos = initialRepos
			currentPage = 1
			hasMorePages = initialRepos.count >= 30
			loadState = .loaded(())
			print("Auth token: \(GitHubAPI.authToken != nil), repos loaded: \(initialRepos.count)")
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
