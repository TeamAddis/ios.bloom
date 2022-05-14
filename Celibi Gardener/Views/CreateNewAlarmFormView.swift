//
//  CreateNewAlarmFormView.swift
//  Celibi Gardener
//
//  Created by Andrew Addis on 2022/05/15.
//

import SwiftUI
import Alamofire

struct CreateNewAlarmFormView: View {
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

struct CreateNewAlarmFormView_Previews: PreviewProvider {
    static var previews: some View {
        CreateNewAlarmFormView()
    }
}
