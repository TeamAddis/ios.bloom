//
//  ApiClientModelTests.swift
//  BloomTests
//
//  Created by AI assistant on 2026/04/06.
//

import XCTest
@testable import Bloom

final class ApiClientModelTests: XCTestCase {
    func testPumpStatusResponseDecoding() throws {
        let json = """
        { "status": "on" }
        """.data(using: .utf8)!

        let decoder = JSONDecoder()
        let resp = try decoder.decode(PumpStatusResponse.self, from: json)
        XCTAssertEqual(resp.status, "on")
    }

    func testPumpControlRequestEncoding() throws {
        let req = PumpControlRequest(state: "off")
        let encoder = JSONEncoder()
        let data = try encoder.encode(req)
        let str = String(data: data, encoding: .utf8)
        XCTAssertEqual(str, "{\"state\":\"off\"}")
    }

    func testMappingToPumpStatusBool() throws {
        let decoder = JSONDecoder()
        let jsonOn = "{ \"status\":\"on\" }".data(using: .utf8)!
        let on = try decoder.decode(PumpStatusResponse.self, from: jsonOn)
        XCTAssertTrue(on.status.lowercased() == "on")
    }
}
