//
//  SettingsScreen.swift
//  DevPulse
//
//  Created by David Messer on 5/2/26.
//

import SwiftUI

struct SettingsScreen: View {
    @Binding var username: String
	@State private var token: String = ""
	@State private var isAuthenticated = false
	
    var body: some View {
		Form {
			Section {
				SecureField("PAT", text: $token)
				Button("Save Token") {
					GitHubAPI.authToken = token
					KeychainHelper.save(key: "github_token", value: token)
					isAuthenticated = true
				}
				.disabled(token.isEmpty)
				
				Button("Clear Token", role: .destructive) {
					GitHubAPI.authToken = nil
					KeychainHelper.delete(key: "github_token")
					token = ""
					isAuthenticated = false
				}
			} header: {
				Text("GitHub Token")
			} footer: {
				if isAuthenticated {
					Label("Token saved", systemImage: "checkmark.circle.fill")
						.foregroundStyle(.green)
				} else {
					Text("No token set.")
				}
			}
            
            Section {
                Button("Switch User", role: .destructive) {
                    username = ""
                }
            }
		}
		.onAppear {
			if let saved = KeychainHelper.load(key: "github_token") {
				GitHubAPI.authToken = saved
				isAuthenticated = true
			}
		}
    }
}

#Preview {
    @Previewable @State var username = ""
    
    SettingsScreen(username: $username)
}
