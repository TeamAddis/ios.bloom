//
//  ManualView.swift
//  Celibi Gardener
//
//  Created by Andrew Addis on 2022/05/14.
//

import SwiftUI
import Alamofire

struct ManualView: View {
    @EnvironmentObject var serverStatus: ServerStatus
    
    @State private var pumpToggleStatus: Bool = false
    
    var body: some View {
        Form {
            Section {
                Toggle("Pump", isOn: $pumpToggleStatus)
                    .onChange(of: pumpToggleStatus) { value in
                        if value {
                            onButtonPressed()
                        } else {
                            offButtonPressed()
                        }
                    }
            }
        }
    }
    
    func onButtonPressed() {
        AF.request(PumpEndpoint.manual(PumpState(isOn: true))).response { response in
            serverStatus.getServerStatus()
        }
    }

    func offButtonPressed() {
        AF.request(PumpEndpoint.manual(PumpState(isOn: false))).response { response in
            serverStatus.getServerStatus()
        }
    }
}
