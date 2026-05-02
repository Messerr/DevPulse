//
//  GitHubAPI.swift
//  DevPulse
//
//  Created by David Messer on 4/28/26.
//

import Foundation

enum GitHubAPI {
    private static let baseURL = "https://api.github.com"
	static var authToken: String?
    
    private static let decoder: JSONDecoder = {
        let d = JSONDecoder()
        d.keyDecodingStrategy = .convertFromSnakeCase
        d.dateDecodingStrategy = .iso8601
        return d
    }()
    
    private static func fetch<T: Decodable>(_ path: String, forceRefresh: Bool = false) async throws -> T {
        if !forceRefresh, let cached: T = await APICache.shared.get(path) {
            return cached
        }
        
        guard let url = URL(string: baseURL + path) else {
            throw APIError.invalidURL
        }
        
		var request = URLRequest(url: url)
		request.setValue("application/vnd.github.v3+json", forHTTPHeaderField: "Accept")
		
		if let token = authToken {
			request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
		}
		
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let http = response as? HTTPURLResponse else {
            throw APIError.invalidResponse
        }
        
        switch http.statusCode {
        case 200: break
		case 401: throw APIError.unauthorized
        case 404: throw APIError.notFound
        case 403: throw APIError.rateLimited
        default: throw APIError.serverError(http.statusCode)
        }
        
        do {
            let result = try decoder.decode(T.self, from: data)
            await APICache.shared.set(path, value: result)
            return result
        } catch {
            throw APIError.decodingError
        }
    }
    
    static func fetchUser(_ username: String, forceRefresh: Bool = false) async throws -> GitHubUser {
        try await fetch("/users/\(username)", forceRefresh: forceRefresh)
    }
    
    static func fetchMyRepos(page: Int = 1, forceRefresh: Bool = false) async throws -> [GitHubRepo] {
		try await fetch("/user/repos?sort=updated&page=\(page)&per_page=30&affiliation=owner,collaborator,organization_member", forceRefresh: forceRefresh)
	}
	
    static func fetchRepos(for username: String, page: Int = 1, forceRefresh: Bool = false) async throws -> [GitHubRepo] {
        try await fetch("/users/\(username)/repos?sort=updated&page=\(page)&per_page=30", forceRefresh: forceRefresh)
    }
	
    static func searchUsers(_ query: String, forceRefresh: Bool = false) async throws -> [GitHubUserSummary] {
		let encoded = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? query
		let result: GitHubSearchResult = try await fetch("/search/users?q=\(encoded)&per_page=20", forceRefresh: forceRefresh)
		return result.items
	}
	
    static func fetchEvents(for username: String, forceRefresh: Bool = false) async throws -> [GitHubEvent] {
		try await fetch("/users/\(username)/events?per_page=30", forceRefresh: forceRefresh)
	}
}
