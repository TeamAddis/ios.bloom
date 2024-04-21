//
//  ContentView.swift
//  Celibi Gardener
//
//  Created by Andrew Addis on 2021/11/18.
//

import SwiftUI

struct ContentView: View {
    @State private var isOn = false
    @StateObject var authenticationManager = AuthenticationManager.shared
    

    var body: some View {
        Button(action: {
            let message = MQTTMessage(message: (self.isOn ? "off" : "on"))
            MQTTManager.shared.publishMQTTMessage(message: message)
            self.isOn.toggle()
        }) {
            Text(isOn ? "Turn Off" : "Turn On")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
