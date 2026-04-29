//
//  GitHubUserSummary.swift
//  DevPulse
//
//  Created by David Messer on 4/28/26.
//

import Foundation

struct GitHubUserSummary: Codable, Identifiable {
    let id: Int
    let login: String
    let avatarUrl: String
}
