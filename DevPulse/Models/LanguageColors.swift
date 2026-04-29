//
//  LanguageColors.swift
//  DevPulse
//
//  Created by David Messer on 4/28/26.
//

import Foundation
import SwiftUI

struct LanguageColors {
    static func color(for language: String) -> Color {
        switch language {
        case "Swift": .orange
        case "Python": .blue
        case "JavaScript": .yellow
        case "TypeScript": .blue
        case "HTML": .red
        case "CSS": .purple
        case "Ruby": .red
        case "Go": .cyan
        case "Rust": .brown
        case "Java": .red
        default: .gray
        }
    }
}
