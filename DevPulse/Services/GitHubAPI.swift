//
//  GitHubAPI.swift
//  DevPulse
//
//  Created by David Messer on 4/28/26.
//

import Foundation

enum GitHubAPI {
    static func fetchUser(_ username: String) async throws -> GitHubUser {
        let url = URL(string: "https://api.github.com/users/\(username)")!
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIError.invalidResponse
        }
        
        switch httpResponse.statusCode {
        case 200: break
        case 404: throw APIError.notFound
        case 403: throw APIError.rateLimited
        default: throw APIError.serverError(httpResponse.statusCode)
        }
        
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return try decoder.decode(GitHubUser.self, from: data)
    }
    
    static func fetchRepos(
        for username: String,
        page: Int = 1,
        perPage: Int = 30
    ) async throws -> [GitHubRepo] {
        let url = URL(string: "https://api.github.com/users/\(username)/repos?sort=created&page=\(page)&per_page=\(perPage)")!
        
        let (data, response) = try await URLSession.shared.data(from: url)
        guard let http = response as? HTTPURLResponse, http.statusCode == 200 else {
            throw APIError.invalidResponse
        }
        
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        decoder.dateDecodingStrategy = .iso8601
        return try decoder.decode([GitHubRepo].self, from: data)
    }
    
    static func searchUsers(_ query: String) async throws -> [GitHubUserSummary] {
        guard !query.isEmpty else { return [] }
        let encoded = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? query
        let url = URL(string: "https://api.github.com/search/users?q=\(encoded)&per_page=20")!
        
        let (data, response) = try await URLSession.shared.data(from: url)
        guard let http = response as? HTTPURLResponse, http.statusCode == 200 else {
            throw APIError.invalidResponse
        }
        
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return try decoder.decode(GitHubSearchResult.self, from: data).items
    }
}
