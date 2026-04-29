//
//  RepoCard.swift
//  DevPulse
//
//  Created by David Messer on 4/28/26.
//

import SwiftUI

struct RepoCard: View {
    let repo: GitHubRepo

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text(repo.name)
                    .font(.headline)
                    .lineLimit(1)
                Spacer()
                if repo.isPrivate {
                    Text("Private")
                        .font(.caption2.weight(.medium))
                        .padding(.horizontal, 8)
                        .padding(.vertical, 3)
                        .background(.orange.opacity(0.15), in: Capsule())
                        .foregroundStyle(.orange)
                }
            }

            if let description = repo.description {
                Text(description)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .lineLimit(2)
            }

            HStack(spacing: 16) {
                if let language = repo.language {
                    Label {
                        Text(language)
                    } icon: {
                        Circle()
                            .fill(LanguageColors.color(for: language))
                            .frame(width: 10, height: 10)
                    }
                }

                Label("\(repo.stargazersCount)", systemImage: "star")
                Label("\(repo.forksCount)", systemImage: "tuningfork")

                Spacer()

                Text(repo.updatedAt, format: .relative(presentation: .named))
            }
            .font(.caption)
            .foregroundStyle(.secondary)
        }
        .padding()
        .background(.background, in: RoundedRectangle(cornerRadius: 12))
        .shadow(color: .black.opacity(0.05), radius: 4, y: 2)
    }
}

#Preview {
    RepoCard(repo: GitHubRepo(
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
    .padding()
}
