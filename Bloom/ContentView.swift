//
//  ContentView.swift
//  Bloom
//
//  Created by Andrew Addis on 2021/11/18.
//

import SwiftUI

struct ContentView: View {
    @StateObject var authenticationManager = AuthenticationManager.shared
    @ObservedObject var statusManager = StatusManager.shared
    

    var body: some View {
        VStack {
            // Display the AWS IoT connection status only if it is "Not Connected"
            if authenticationManager.awsiotStatus == .notConnected {
                Text("AWS IoT Status: \(authenticationManager.awsiotStatus.rawValue)")
                    .padding()
            }
            
            // Display the current controller status
            Text("Controller Status: \(statusManager.controllerStatus.rawValue)")
                .padding()
            
            // Display the current status of the pump
            Text("Pump Status: \(statusManager.pumpStatus.rawValue)")
                .padding()
            
            HStack {
                Text("Alarms")
                    .font(.title2)
                Spacer()
            }
            .padding(.horizontal)
                
            List {
                Text("HH:MM")
                Text("HH:MM")
                Text("HH:MM")
            }
            .listStyle(.plain)
            .frame(height: 44 * 3) // Adjust the height to show exactly 3 items
            
            Spacer()
            
            // Button to toggle the pump
            Button(action: {
                let newStatus: PumpStatus = (statusManager.pumpStatus == .on) ? .off : .on
                let message = MQTTMessage(message: newStatus.rawValue)
                MQTTManager.shared.publishMQTTMessage(topic: MQTTTopic.manualPump,message: message)
            }) {
                Text(statusManager.pumpStatus == .on ? "Turn Off" : "Turn On")
                    .padding()
                    .background(statusManager.pumpStatus == .on ? Color.red : Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
            .padding()
        }
        .onAppear(perform: {
            statusManager.getControllerStatus()
        })
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
