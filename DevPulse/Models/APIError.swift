//
//  APIError.swift
//  DevPulse
//
//  Created by David Messer on 4/28/26.
//

import Foundation

enum APIError: LocalizedError {
    case invalidURL
    case invalidResponse
    case notFound
    case rateLimited
    case serverError(Int)
    case decodingError
    
    var errorDescription: String? {
        switch self {
        case .invalidURL: "Invalid URL"
        case .invalidResponse: "Invalid server response"
        case .notFound: "User not found"
        case .rateLimited: "Rate limit exceeded. Try again later"
        case .serverError(let code): "Server error (\(code))"
        case .decodingError : "Failed to parse response"
        }
    }
}
