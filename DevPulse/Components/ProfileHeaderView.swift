//
//  ProfileHeaderView.swift
//  DevPulse
//
//  Created by David Messer on 4/28/26.
//

import SwiftUI

struct ProfileHeaderView: View {
    let user: GitHubUser
    
    var body: some View {
        VStack(spacing: 16) {
            AsyncImage(url: URL(string: user.avatarUrl)) { phase in
                switch phase {
                case .empty:
                    ProgressView()
                case .success(let image):
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                case .failure:
                    Image(systemName: "person.circle.fill")
                        .font(.system(size: 60))
                        .foregroundStyle(.secondary)
                @unknown default:
                    EmptyView()
                }
            }
            .frame(width: 100, height: 100)
            .clipShape(Circle())
            
            VStack(spacing: 4) {
                Text(user.name ?? user.login)
                    .font(.title2.bold())
                if let bio = user.bio {
                    Text(bio)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                }
            }
            
            HStack(spacing: 24) {
                StatBadge(value: user.publicRepos, label: "Repos")
                StatBadge(value: user.followers, label: "Followers")
                StatBadge(value: user.following, label: "Following")
            }
        }
    }
}

#Preview {
    let user = GitHubUser(
        id: 1,
        login: "login",
        avatarUrl: "https://avatars.githubusercontent.com/u/6812208?v=4",
        name: "David Messer",
        bio: "Bio",
        publicRepos: 8,
        followers: 4,
        following: 6
    )
    
    ProfileHeaderView(
        user: user
    )
}
