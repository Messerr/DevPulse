//
//  GitHubSearchResult.swift
//  DevPulse
//
//  Created by David Messer on 4/28/26.
//

import Foundation

struct GitHubSearchResult: Codable {
    let totalCount: Int
    let items: [GitHubUserSummary]
}
