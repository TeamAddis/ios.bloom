//
//  StatusManager.swift
//  Bloom
//
//  Created by Andrew Addis on 2024/08/20.
//

import Foundation

enum PumpStatus: String {
    case on = "On"
    case off = "Off"
}

enum ControllerStatus: String {
    case offline = "Offline"
    case online = "Online"
}

// make it easy to decode the JSON payload
struct StatusMessage: Codable {
    var pumpOn: Bool
}

class StatusManager: ObservableObject {
    static let shared = StatusManager()
    
    @Published var pumpStatus: PumpStatus
    @Published var controllerStatus: ControllerStatus
    
    private init() {
        pumpStatus = .off
        controllerStatus = .offline
    }
    
    func getControllerStatus() {
        APIClient.shared.getPumpStatus { result in
            switch result {
            case .success(let resp):
                DispatchQueue.main.async {
                    self.controllerStatus = .online
                    self.pumpStatus = (resp.status.lowercased() == "on" ? .on : .off)
                }
            case .failure(let err):
                print("API getPumpStatus error: \(err)")
                DispatchQueue.main.async {
                    self.controllerStatus = .offline
                }
            }
        }
    }
    
    func handleStatusUpdate(data: Data) {
        let decoder = JSONDecoder()
        guard let statusMessage = try? decoder.decode(StatusMessage.self, from: data) else {
            print("Error decoding status message")
            return
        }
        
        
        DispatchQueue.main.async {
            self.controllerStatus = .online
            // convert from bool -> enum and update the pump status
            self.pumpStatus = (statusMessage.pumpOn ? .on : .off)
        }
    }
}
