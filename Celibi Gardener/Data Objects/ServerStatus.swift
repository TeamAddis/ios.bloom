//
//  ServerStatus.swift
//  Celibi Gardener
//
//  Created by Andrew Addis on 2022/05/14.
//

import Foundation
import Alamofire

enum PumpStatus: Equatable {
    
    case on, off, none
    
    var status: String {
        switch self {
        case .off:
            return "OFF"
        case .on:
            return "ON"
        case .none:
            return "NONE"
        }
    }
}

enum Status: Equatable {
    case connected, unavailable
    
    var status: String {
        switch self {
        case .connected:
            return "Connected"
        case .unavailable:
            return "Unavailable"
        }
    }
}

class ServerStatus: ObservableObject {
    @Published var pumpStatus: PumpStatus = .none
    @Published var serverVersion: Int = 0
    @Published var status: Status = .unavailable
    @Published var alarms: [AlarmObjectMessage] = []
    
    init() {
        getServerStatus()
    }
    
    func getServerStatus() {
        AF.request(StatusEndpoint.pumpStatus).response { response in
            guard let data = response.data else {
                self.pumpStatus = .none
                return
            }
            
            if let json = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Int] {
                DispatchQueue.main.async {
                    if json["pumpIsActive"] == 0 {
                        self.pumpStatus = .off
                    } else {
                        self.pumpStatus = .on
                    }
                    
                    self.serverVersion = json["softwareVersion"] ?? 0
                }
            }
        }
    }
    
    // Makes it easy to test displaying multiple alarms
    func createTestAlarms() {
        alarms.append(AlarmObjectMessage(hours: 10, minutes: 10))
        alarms.append(AlarmObjectMessage(hours: 12, minutes: 57))
        alarms.append(AlarmObjectMessage(hours: 2, minutes: 24))
        alarms.append(AlarmObjectMessage(hours: 22, minutes: 53))
    }
}
