//
//  ContentView.swift
//  DevPulse
//
//  Created by David Messer on 4/28/26.
//

import SwiftUI

struct ContentView: View {
    @AppStorage("github_username") private var username = ""
    @State private var showOnboarding = false
    
    var body: some View {
        if username.isEmpty {
            OnboardingScreen(username: $username)
        } else {
            MainTabView(username: $username)
        }
    }
}

#Preview {
    ContentView()
}
