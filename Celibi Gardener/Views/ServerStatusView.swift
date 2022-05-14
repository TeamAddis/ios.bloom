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
            Text("Server Status: \(serverStatus.status.name)")
            
            Text("Server Version: \(serverStatus.serverVersion)")
            
            Button(action: serverStatus.getServerStatus, label: {
                Text("Refresh")
            })
                .padding()
        }
    }
    
    func checkForServerUpdate() {
        
    }
}
