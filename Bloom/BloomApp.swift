//
//  BloomApp.swift
//  Bloom
//
//  Created by Andrew Addis on 2021/11/18.
//

import SwiftUI

@main
struct BloomApp: App {
    init() {
        seedApiKeyFromSecretsPlist()
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }

    private func seedApiKeyFromSecretsPlist() {
        // If Keychain already contains an API key, do nothing.
        if KeychainService.shared.getApiKey() != nil {
            return
        }

        // Attempt to read an untracked Bloom/secrets.plist and copy API_KEY into Keychain.
        if let secrets = readPlist(name: "secrets"),
           let apiKey = secrets["API_KEY"] as? String,
           !apiKey.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            let saved = KeychainService.shared.saveApiKey(apiKey)
            print("BloomApp: seeded API key into Keychain -> \(saved)")
        } else {
            print("BloomApp: no secrets.plist/API_KEY found; skipping Keychain seed")
        }
    }
}
