//
//  TimersView.swift
//  Celibi Gardener
//
//  Created by Andrew Addis on 2022/05/14.
//

import SwiftUI
import Alamofire

struct TimersView: View {
    @State private var currentDate = Date()
    
    private let GMT = 9
    
    var body: some View {
        VStack {
            HStack {
                DatePicker("", selection: $currentDate, displayedComponents: .hourAndMinute)
                    .labelsHidden()
            }
            Button(action: setAlarmButtonPressed, label: {
                Text("Set Pump Alarm")
            })
        }
    }
    
    func setAlarmButtonPressed() {
        let hours = Calendar.current.component(.hour, from: currentDate) - GMT
        let minutes = Calendar.current.component(.minute, from: currentDate)
        AF.request(PumpEndpoint.alarm(AlarmObjectMessage(hours: hours, minutes: minutes))).response { response in
            print(response)
        }
    }
}
