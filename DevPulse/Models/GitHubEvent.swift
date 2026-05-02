//
//  GitHubEvent.swift
//  DevPulse
//
//  Created by David Messer on 5/2/26.
//

import Foundation

struct GitHubEvent: Codable, Identifiable {
	let id: String
	let type: String
	let repo: EventRepo
	let createdAt: Date
	let isPublic: Bool
	
	struct EventRepo: Codable {
		let name: String
	}
	
	enum CodingKeys: String, CodingKey {
		case id, type, repo, createdAt
		case isPublic = "public"
	}
	
	var icon: String {
		switch type {
		case "PushEvent": "arrow.up.circle"
		case "WatchEvent": "star"
		case "CreateEvent": "plus.circle"
		case "ForkEvent": "tuningfork"
		case "IssuesEvent": "exclamationmark.circle"
		case "PullRequestEvent": "arrow.triangle.pull"
		default: "circle"
		}
	}
	
	var displayType: String {
		type.replacingOccurrences(of: "Event", with: "")
	}
}
