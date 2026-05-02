//
//  EventRow.swift
//  DevPulse
//
//  Created by David Messer on 5/2/26.
//

import SwiftUI

struct EventRow: View {
	let event: GitHubEvent
	
	var body: some View {
		HStack(spacing: 12) {
			Image(systemName: event.icon)
				.foregroundStyle(.secondary)
				.frame(width: 24)
			
			VStack(alignment: .leading, spacing: 4) {
				Text(event.displayType)
					.font(.subheadline.weight(.medium))
				Text(event.repo.name)
					.font(.caption)
					.foregroundStyle(.secondary)
			}
			
			Spacer()
			
			Text(event.createdAt, format: .relative(presentation: .named))
				.font(.caption)
				.foregroundStyle(.tertiary)
		}
	}
}

#Preview {
	EventRow(event: GitHubEvent(
		id: "1",
		type: "PushEvent",
		repo: GitHubEvent.EventRepo(name: "Messerr/ShopLog"),
		createdAt: .now,
		isPublic: true
	))
}
