//
//  SectionCard.swift
//  DevPulse
//
//  Created by David Messer on 5/2/26.
//

import SwiftUI

struct SectionCard<Content: View>: View {
    let title: String
    let icon: String
    @ViewBuilder let content: () -> Content
    
    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            Label(title, systemImage: icon)
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(.secondary)
            
            content()
        }
        .padding(20)
        .background(.background, in: RoundedRectangle(cornerRadius: 14))
        .shadow(color: .black.opacity(0.04), radius: 6, y: 3)
    }
}

#Preview {
    SectionCard(title: "Tool Info", icon: "wrench.and.screwdriver") {
        LabeledContent("Diameter", value: "12mm")
        LabeledContent("Flute Count", value: "4")
        LabeledContent("Overhang", value: "65mm")
    }
}
