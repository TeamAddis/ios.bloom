//
//  KeychainService.swift
//  Bloom
//
//  Created by Andrew Addis on 2026/04/06.
//

import Foundation
import Security

final class KeychainService {
	static let shared = KeychainService()

	private init() {}

	private let service = "io.bloom.commandhub"
	private let account = "api_key"

	func saveApiKey(_ key: String) -> Bool {
		guard let data = key.data(using: .utf8) else { return false }

		let query: [String: Any] = [kSecClass as String: kSecClassGenericPassword,
									kSecAttrService as String: service,
									kSecAttrAccount as String: account]

		let attributes: [String: Any] = [kSecValueData as String: data]

		let status = SecItemCopyMatching(query as CFDictionary, nil)
		if status == errSecSuccess {
			let statusUpdate = SecItemUpdate(query as CFDictionary, attributes as CFDictionary)
			return statusUpdate == errSecSuccess
		} else {
			var addQuery = query
			addQuery[kSecValueData as String] = data
			let statusAdd = SecItemAdd(addQuery as CFDictionary, nil)
			return statusAdd == errSecSuccess
		}
	}

	func getApiKey() -> String? {
		let query: [String: Any] = [kSecClass as String: kSecClassGenericPassword,
									kSecAttrService as String: service,
									kSecAttrAccount as String: account,
									kSecReturnData as String: kCFBooleanTrue!,
									kSecMatchLimit as String: kSecMatchLimitOne]

		var item: AnyObject?
		let status = SecItemCopyMatching(query as CFDictionary, &item)
		guard status == errSecSuccess, let data = item as? Data, let str = String(data: data, encoding: .utf8) else {
			return nil
		}
		return str
	}
}

