//
//  CreateNewAlarmFormView.swift
//  Celibi Gardener
//
//  Created by Andrew Addis on 2022/05/15.
//

import SwiftUI
import Alamofire

struct CreateNewAlarmFormView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var serverStatus: ServerStatus
    
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
    
    func getNextAlarmID() -> Int {
        return serverStatus.alarms.count
    }
    
    func setAlarmButtonPressed() {
        var hours = Calendar.current.component(.hour, from: currentDate) - GMT
        if hours < 0 {
            hours += 24
        }
        let minutes = Calendar.current.component(.minute, from: currentDate)
        AF.request(PumpEndpoint.alarm(AlarmObjectMessage(id: getNextAlarmID(), hours: hours, minutes: minutes, enabled: true))).response { response in
            print(response)
        }
        dismiss()
    }
}
