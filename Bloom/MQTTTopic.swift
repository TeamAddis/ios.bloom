//
//  MQTTTopic.swift
//  Bloom
//
//  Created by Andrew Addis on 2024/08/20.
//

import Foundation

enum MQTTTopic: String {
    case manualPump = "bloom/device/command/manual_pump"
    case getStatus = "bloom/device/command/get_status"
    case status = "bloom/device/status"
}
