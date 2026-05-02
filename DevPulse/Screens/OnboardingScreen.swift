//
//  OnboardingScreen.swift
//  DevPulse
//
//  Created by David Messer on 5/2/26.
//

import SwiftUI

struct OnboardingScreen: View {
    @Binding var username: String
    @State private var input = ""
    
    var body: some View {
        VStack(spacing: 24) {
            Image(systemName: "person.circle")
                .font(.system(size: 80))
                .foregroundStyle(.blue)
            
            Text("Welcome to DevPulse")
                .font(.title.bold())
            
            Text("Enter your GitHub username to get started")
                .foregroundStyle(.secondary)
            
            TextField("GitHub username", text: $input)
                .textFieldStyle(.roundedBorder)
                .textInputAutocapitalization(.never)
                .autocorrectionDisabled()
                .padding(.horizontal, 40)
            
            Button("Get Started") {
                username = input.trimmingCharacters(in: .whitespaces)
            }
            .buttonStyle(.borderedProminent)
            .disabled(input.trimmingCharacters(in: .whitespaces).isEmpty)
        }
    }
}

#Preview {
    @Previewable @State var username = ""
    
    OnboardingScreen(
        username: $username
    )
}
