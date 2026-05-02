//
//  GitHubAPI.swift
//  DevPulse
//
//  Created by David Messer on 4/28/26.
//

import Foundation

enum GitHubAPI {
    private static let baseURL = "https://api.github.com"
    
    private static let decoder: JSONDecoder = {
        let d = JSONDecoder()
        d.keyDecodingStrategy = .convertFromSnakeCase
        d.dateDecodingStrategy = .iso8601
        return d
    }()
    
    private static func get<T: Decodable>(_ path: String) async throws -> T {
        guard let url = URL(string: baseURL + path) else {
            throw APIError.invalidURL
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let http = response as? HTTPURLResponse else {
            throw APIError.invalidResponse
        }
        
        switch http.statusCode {
        case 200: break
        case 404: throw APIError.notFound
        case 403: throw APIError.rateLimited
        default: throw APIError.serverError(http.statusCode)
        }
        
        do {
            return try decoder.decode(T.self, from: data)
        } catch {
            throw APIError.decodingError
        }
    }
    
    static func fetchUser(_ username: String) async throws -> GitHubUser {
        try await fetch("/users/\(username)")
    }
    
    static func fetchRepos(for username: String, page: Int = 1) async throws -> [GitHubRepo] {
        try await fetch("/user/\(username)/repos?sort=updated&page=\(page)&per_page=30")
    }
}
