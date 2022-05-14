//
//  ServerStatusView.swift
//  Celibi Gardener
//
//  Created by Andrew Addis on 2022/05/14.
//

import SwiftUI

struct ServerStatusView: View {
    @EnvironmentObject var serverStatus: ServerStatus
    
    var body: some View {
        VStack {
            HStack {
                Text("Server Version: \(serverStatus.serverVersion)")
                    .padding()
                Spacer()
                Button(action: checkForServerUpdate, label: {
                    Text("Check for Updates")
                })
                    .padding()
            }
            
            HStack {
                Text("Pump Status: \(serverStatus.pumpStatus.status)")
                    .padding()
                Spacer()
                Button(action: serverStatus.getServerStatus, label: {
                    Text("Refresh")
                })
                    .padding()
            }
        }
    }
    
    func checkForServerUpdate() {
        
    }
}
