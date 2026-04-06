//
//  PumpModels.swift
//  Bloom
//
//  Created by Andrew Addis on 2026/04/06.
//

import Foundation

// Matches commandhub.iot models
struct PumpControlRequest: Codable {
	let state: String // "on" or "off"
}

struct PumpStatusResponse: Codable {
	let status: String // "on" or "off"
}

struct McuStatusResponse: Codable {
	let version: Int?
}

struct Alarm: Codable {
	let hour: Int
	let minute: Int
	let enabled: Bool
}

