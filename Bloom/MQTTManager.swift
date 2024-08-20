//
//  MQTTManager.swift
//  Bloom
//
//  Created by Andrew Addis on 2024/04/21.
//

import Foundation
import AWSIoT

class MQTTManager: ObservableObject {
    static let shared = MQTTManager()
    
    private let dataManager: AWSIoTDataManager
    
    private init() {
        dataManager = AWSIoTDataManager(forKey: "aDataManager")
        setupSubscriptions()
    }
    
    func publishMQTTMessage(topic: MQTTTopic, message: MQTTMessage) {
        // Convert the message to JSON
        let encoder = JSONEncoder()
        guard let data = try? encoder.encode(message),
              let messageString = String(data: data, encoding: .utf8) else {
            print("Error encoding message")
            return
        }
        
        dataManager.publishString(messageString, onTopic: topic.rawValue, qoS: .messageDeliveryAttemptedAtLeastOnce)
        print("sending \(message.message) to topic \(topic)")
    }
    
    private func setupSubscriptions() {
        // Subscribe to topics
        dataManager.subscribe(toTopic: MQTTTopic.status.rawValue, qoS: .messageDeliveryAttemptedAtLeastOnce, messageCallback: {payload in
            StatusManager.shared.handleStatusUpdate(data: payload)
        })
    }
}
