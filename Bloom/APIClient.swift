//
//  APIClient.swift
//  Bloom
//
//  Created by Andrew Addis on 2026/04/06.
//

import Foundation
import Alamofire

final class APIClient {
	static let shared = APIClient()

	private let baseURL: URL

	private init() {
		if let urlString = ConfigurationService.shared.apiBaseURLString,
		   let url = URL(string: urlString) {
			baseURL = url
		} else {
			baseURL = URL(string: "http://127.0.0.1:8000")!
		}
	}

	private func apiKeyHeaders() -> HTTPHeaders {
		var headers: HTTPHeaders = ["Content-Type": "application/json"]
		if let key = KeychainService.shared.getApiKey() {
			headers.add(name: "X-API-Key", value: key)
		}
		return headers
	}

	func getPumpStatus(completion: @escaping (Result<PumpStatusResponse, AFError>) -> Void) {
		let url = baseURL.appendingPathComponent("/pump/status")
		AF.request(url, method: .get, headers: apiKeyHeaders()).validate().responseDecodable(of: PumpStatusResponse.self) { resp in
			completion(resp.result)
		}
	}

	func setPump(state: PumpControlRequest, completion: @escaping (Result<PumpStatusResponse, AFError>) -> Void) {
		let url = baseURL.appendingPathComponent("/pump")
		AF.request(url, method: .post, parameters: state, encoder: JSONParameterEncoder.default, headers: apiKeyHeaders()).validate().responseDecodable(of: PumpStatusResponse.self) { resp in
			completion(resp.result)
		}
	}

	// Additional endpoints (runtime, alarms, mcu) can be added here.
}

