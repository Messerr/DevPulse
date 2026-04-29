//
//  UserSearchRow.swift
//  DevPulse
//
//  Created by David Messer on 4/28/26.
//

import SwiftUI

struct UserSearchRow: View {
    let user: GitHubUserSummary
    
    var body: some View {
        HStack(spacing: 12) {
            AsyncImage(url: URL(string: user.avatarUrl)) { image in
                image.resizable().aspectRatio(contentMode: .fill)
            } placeholder: {
                ProgressView()
            }
            .frame(width: 44, height: 44)
            .clipShape(Circle())
            
            Text(user.login)
                .font(.headline)
        }
    }
}

#Preview {
    let user = GitHubUserSummary(
        id: 1,
        login: "Messerr",
        avatarUrl: "https://avatars.githubusercontent.com/u/6812208?v=4"
    )
    
    UserSearchRow(
        user: user
    )
}
