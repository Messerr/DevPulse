//
//  GitHubRepo.swift
//  DevPulse
//
//  Created by David Messer on 4/28/26.
//

import Foundation

struct GitHubRepo: Codable, Identifiable {
    let id: Int
    let name: String
    let fullName: String
    let description: String?
    let language: String?
    let stargazersCount: Int
    let forksCount: Int
    let openIssuesCount: Int
    let isPrivate: Bool
    let htmlUrl: String
    let createdAt: Date
    let updatedAt: Date
    let owner: Owner
    
    struct Owner: Codable {
        let login: String
        let avatarUrl: String
    }
    
    enum CodingKeys: String,  CodingKey {
        case id, name, fullName, description, language
        case stargazersCount, forksCount, openIssuesCount
        case isPrivate = "private"
        case htmlUrl, createdAt, updatedAt, owner
    }
}
