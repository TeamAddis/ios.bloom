//
//  ConfigurationService.swift
//  Bloom
//
//  Created by Andrew Addis on 2026/04/06.
//

import Foundation

final class ConfigurationService {
	static let shared = ConfigurationService()

	private init() {}

	// Attempt to read API base URL from Info.plist key "API_BASE_URL"
	var apiBaseURLString: String? {
		if let info = Bundle.main.infoDictionary, let url = info["API_BASE_URL"] as? String {
			return url
		}
		return nil
	}
}

