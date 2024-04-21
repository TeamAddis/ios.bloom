//
//  MQTTManager.swift
//  Celibi Gardener
//
//  Created by Andrew Addis on 2024/04/21.
//

import Foundation
import AWSIoT

class MQTTManager: ObservableObject {
    static let shared = MQTTManager()
    
    let topic = "celebi/manual_pump"
    
    func publishMQTTMessage(message: MQTTMessage) {
        let dataManager = AWSIoTDataManager(forKey: "aDataManager")
        
        // Convert the message to JSON
        let encoder = JSONEncoder()
        guard let data = try? encoder.encode(message),
              let messageString = String(data: data, encoding: .utf8) else {
            print("Error encoding message")
            return
        }
        
        dataManager.publishString(messageString, onTopic: topic, qoS: .messageDeliveryAttemptedAtLeastOnce)
        print("sending \(message.message) to topic \(topic)")
    }
}
