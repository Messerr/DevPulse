//
//  ActivityScreen.swift
//  DevPulse
//
//  Created by David Messer on 5/2/26.
//

import SwiftUI

struct ActivityScreen: View {
	let username: String
	@State private var events: [GitHubEvent] = []
	@State private var loadState: LoadState<Void> = .idle
	
    var body: some View {
		Group {
			switch loadState {
			case .idle, .loading:
				ProgressView("Loading Activity...")
			case .loaded:
				ScrollView {
					LazyVStack(spacing: 12) {
						ForEach(events) { event in
							EventRow(event: event)
						}
					}
					.padding()
				}
			case .error(let message):
				ContentUnavailableView {
					Label("Failed to Load", systemImage: "wifi.exclamationmark")
				} description: {
					Text(message)
				} actions: {
					Button("Retry") { Task { await loadEvents() } }
				}
			}
		}
		.navigationTitle("Activity")
		.task {
			await loadEvents()
		}
		.refreshable {
			await loadEvents()
		}
    }
	
	func loadEvents() async {
		loadState = .loading
		do {
			events = try await GitHubAPI.fetchEvents(for: username)
			loadState = .loaded(())
		} catch {
			loadState = .error(error.localizedDescription)
		}
	}
}

#Preview {
	ActivityScreen(username: "Messerr")
}
