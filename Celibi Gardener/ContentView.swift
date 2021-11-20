//
//  ContentView.swift
//  Celibi Gardener
//
//  Created by Andrew Addis on 2021/11/18.
//

import SwiftUI
import Alamofire


struct ContentView: View {
    @State private var currentDate = Date()
    
    var body: some View {
        VStack {
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
        print(response)
    }
}

func offButtonPressed() {
    AF.request(PumpEndpoint.manual(PumpState(isOn: false))).response { response in
        print(response)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
