//
//  APICache.swift
//  DevPulse
//
//  Created by David Messer on 5/2/26.
//

import Foundation

actor APICache {
	static let shared = APICache()
	
	private var cache: [String: CacheEntry] = [:]
	private let maxAge: TimeInterval = 300 // 5 minutes
	
	struct CacheEntry {
		let data: Any
		let timestamp: Date
		
		var isExpired: Bool {
			Date().timeIntervalSince(timestamp) > 300
		}
	}
	
	func get<T>(_ key: String) -> T? {
		guard let entry = cache[key],
			  !entry.isExpired,
			  let value = entry.data as? T else {
			return nil
		}
		return value
	}
	
	func set(_ key: String, value: Any) {
		cache[key] = CacheEntry(data: value, timestamp: Date())
	}
	
	func clear() {
		cache.removeAll()
	}
}
