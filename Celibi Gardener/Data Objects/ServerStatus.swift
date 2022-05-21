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
    
    var name: String {
        switch self {
        case .connected:
            return "Connected"
        case .unavailable:
            return "Unavailable"
        }
    }
}

class ServerStatus: ObservableObject {
    @Published var pumpStatus: Bool = false
    @Published var serverVersion: Int = 0
    @Published var status: Status = .unavailable
    @Published var alarms: [AlarmObjectMessage] = []
    
    init() {
        getServerStatus()
    }
    
    private func addAlarm(newAlarm: AlarmObjectMessage) {
        for i in 0..<alarms.count {
            if alarms[i].id == newAlarm.id {
                alarms[i].minutes = newAlarm.minutes
                alarms[i].hours = newAlarm.hours
                alarms[i].enabled = newAlarm.enabled
                return
            }
        }
        
        alarms.append(newAlarm)
    }
    
    func getServerStatus() {
        AF.request(StatusEndpoint.pumpStatus).response { response in
            guard let data = response.data else {
                self.status = .unavailable
                return
            }
            if response.response?.statusCode == 200 {
                self.status = .connected
                
                if let json = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any] {
                    DispatchQueue.main.async {
                        if json["pumpIsActive"] as? Int == 1 {
                            self.pumpStatus = true
                        } else {
                            self.pumpStatus = false
                        }
                        
                        self.serverVersion = json["softwareVersion"] as? Int ?? 0
                        
                        if json["alarmValid"] as? Bool == true {
                            var tAlarm = AlarmObjectMessage(id: json["alarmId"] as! Int,hours: json["alarmHours"] as! Int, minutes: json["alarmMinutes"] as! Int)
                            tAlarm.enabled = (json["alarmEnabled"] != nil)
                            self.addAlarm(newAlarm: tAlarm)
                        }
                    }
                }
            }
        }
    }
    
    // Makes it easy to test displaying multiple alarms
    func createTestAlarms() {
        alarms.append(AlarmObjectMessage(id: 0, hours: 10, minutes: 10))
        alarms.append(AlarmObjectMessage(id: 1, hours: 12, minutes: 57))
        alarms.append(AlarmObjectMessage(id: 2, hours: 2, minutes: 24))
        alarms.append(AlarmObjectMessage(id: 3, hours: 22, minutes: 53))
    }
}
