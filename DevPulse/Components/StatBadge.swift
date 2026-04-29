//
//  StatBadge.swift
//  DevPulse
//
//  Created by David Messer on 4/28/26.
//

import SwiftUI

struct StatBadge: View {
    let value: Int
    let label: String
    
    var body: some View {
        VStack(spacing: 2) {
            Text("\(value)")
                .font(.headline)
            Text(label)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
    }
}

#Preview {
    StatBadge(
        value: 10,
        label: "Followers"
    )
}
