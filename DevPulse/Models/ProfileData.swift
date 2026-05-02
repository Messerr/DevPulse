//
//  ProfileData.swift
//  DevPulse
//
//  Created by David Messer on 5/2/26.
//

import Foundation

struct ProfileData {
    let user: GitHubUser
    let recentRepos: [GitHubRepo]
    let recentActivity: [GitHubEvent]
}
