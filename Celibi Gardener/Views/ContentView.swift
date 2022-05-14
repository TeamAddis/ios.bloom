//
//  ContentView.swift
//  Celibi Gardener
//
//  Created by Andrew Addis on 2021/11/18.
//

import SwiftUI
import Alamofire

enum PickerContent: Int {
    case manual = 0, timers = 1
}

struct ContentView: View {
    @StateObject var serverStatus = ServerStatus()
    
    @State private var pickerContent: PickerContent = .manual
    
    
    var body: some View {
        VStack {
            ServerStatusView()
            
            Picker("View", selection: $pickerContent) {
                Text("Manual").tag(PickerContent.manual)
                Text("Timers").tag(PickerContent.timers)
            }
            .pickerStyle(.segmented)
            .padding()
            
            switch pickerContent {
            case .timers:
                TimersView()
            case .manual:
                ManualView()
            }
            
            Spacer()
        }
        .environmentObject(serverStatus)
    }

    

    
}
