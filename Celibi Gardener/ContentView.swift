//
//  ContentView.swift
//  Celibi Gardener
//
//  Created by Andrew Addis on 2021/11/18.
//

import SwiftUI
import Alamofire

enum PumpStatus: Equatable {
    
    case on
    case off
    case none
    
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

struct ContentView: View {
    @State private var currentDate = Date()
    @State private var pumpStatus: PumpStatus = .none
    @State private var serverVersion: Int = 0
    
    var body: some View {
        VStack {
            HStack {
                Text("Server Version: \(serverVersion)")
                    .padding()
                Spacer()
                Button(action: checkForServerUpdate, label: {
                    Text("Check for Updates")
                })
                    .padding()
            }
            .onAppear(perform: getServerStatus)
            
            HStack {
                Text("Pump Status: \(pumpStatus.status)")
                    .padding()
                Spacer()
                Button(action: getServerStatus, label: {
                    Text("Refresh")
                })
                    .padding()
            }
            
            Spacer()
            
            VStack {
                HStack {
                    DatePicker("", selection: $currentDate, displayedComponents: .hourAndMinute)
                        .labelsHidden()
                }
                Button(action: setAlarmButtonPressed, label: {
                    Text("Set Pump Alarm")
                })
            }
            
            HStack {
                Spacer()
                Button(action: onButtonPressed, label: {
                    Text("Turn On")
                })
                    .padding()
                Button(action: offButtonPressed, label: {
                    Text("Turn Off")
                })
                    .padding()
                Spacer()
            }
            
            Spacer()
        }
    }
    
    func checkForServerUpdate() {
        
    }
    
    func getServerStatus() {
        AF.request(StatusEndpoint.pumpStatus).response { response in
            guard let data = response.data else {
                pumpStatus = .none
                return
            }
            
            if let json = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Int] {
                DispatchQueue.main.async {
                    if json["pumpIsActive"] == 0 {
                        pumpStatus = .off
                    } else {
                        pumpStatus = .on
                    }
                    
                    serverVersion = json["softwareVersion"] ?? 0
                }
            }
        }
    }

    func setAlarmButtonPressed() {
        AF.request(PumpEndpoint.alarm(AlarmObjectMessage(hours: 1, minutes: 24))).response { response in
            print(response)
        }
    }

    func onButtonPressed() {
        AF.request(PumpEndpoint.manual(PumpState(isOn: true))).response { response in
            getServerStatus()
        }
    }

    func offButtonPressed() {
        AF.request(PumpEndpoint.manual(PumpState(isOn: false))).response { response in
            getServerStatus()
        }
    }
}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
