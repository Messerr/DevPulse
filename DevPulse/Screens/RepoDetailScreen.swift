//
//  RepoDetailScreen.swift
//  DevPulse
//
//  Created by David Messer on 5/2/26.
//

import SwiftUI

struct RepoDetailScreen: View {
    let repo: GitHubRepo
    @Environment(\.openURL) private var openURL
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                VStack(alignment: .leading, spacing: 8) {
                    Text(repo.name)
                        .font(.title.bold())
                    if let desc = repo.description {
                        Text(desc)
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                }
                
                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]) {
                    StatBadge(value: repo.stargazersCount, label: "Stars")
                    StatBadge(value: repo.forksCount, label: "Forks")
                    StatBadge(value: repo.openIssuesCount, label: "Issues")
                }
                
                SectionCard(title: "Details", icon: "info.circle") {
                    if let language = repo.language {
                        LabeledContent("Language") {
                            HStack {
                                Circle()
                                    .fill(LanguageColors.color(for: language))
                                    .frame(width: 10, height: 10)
                            }
                        }
                    }
                    LabeledContent("Created", value: repo.createdAt.formatted(date: .abbreviated, time: .omitted))
                    LabeledContent("Updated", value: repo.updatedAt.formatted(.relative(presentation: .named)))
                    LabeledContent("Visibility", value: repo.isPrivate ? "Private" : "Public")
                }
                
                Button {
                    if let url = URL(string: repo.htmlUrl) {
                        openURL(url)
                    }
                } label: {
                    Label("View on GitHub", systemImage: "safari")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(.blue, in: RoundedRectangle(cornerRadius: 12))
                        .foregroundStyle(.white)
                }
            }
            .padding()
        }
        .navigationTitle(repo.name)
    }
}

#Preview {
    RepoDetailScreen(repo: GitHubRepo(
        id: 1,
        name: "ShopLog",
        fullName: "Messerr/ShopLog",
        description: "A machine shop tool tracker",
        language: "Swift",
        stargazersCount: 5,
        forksCount: 2,
        openIssuesCount: 1,
        isPrivate: false,
        htmlUrl: "https://github.com/Messerr/ShopLog",
        createdAt: .now,
        updatedAt: .now,
        owner: GitHubRepo.Owner(login: "Messerr", avatarUrl: "")
    ))
}
