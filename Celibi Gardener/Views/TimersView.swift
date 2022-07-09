//
//  TimersView.swift
//  Celibi Gardener
//
//  Created by Andrew Addis on 2022/05/14.
//

import SwiftUI
import Alamofire

struct TimersView: View {
    @EnvironmentObject var serverStatus: ServerStatus
    
    @State private var showCreateAlarmForm: Bool = false
    
    var body: some View {
        NavigationView {
            List(serverStatus.alarms) { alarm in
                AlarmListItemView(hours: alarm.hours, minutes: alarm.minutes, toogle: alarm.enabled)
            }
            .navigationTitle(Text("Alarms"))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        if canCreateNewAlarm() {
                            self.showCreateAlarmForm = true
                        }
                    }, label: {
                        Image(systemName: "plus")
                    })
                }
            }
        }
        .sheet(isPresented: $showCreateAlarmForm, onDismiss: {
            self.showCreateAlarmForm = false
        }, content: {
            CreateNewAlarmFormView()
        })
    }
    
    func canCreateNewAlarm() -> Bool {
        return (serverStatus.alarms.count < serverStatus.MAX_NUMBER_OF_ALARMS)
    }
}

struct AlarmListItemView: View {
    let hours: Int
    let minutes: Int
    private let GMT = 9
    
    @State var toogle: Bool
    
    var body: some View {
        HStack {
            Text("Alarm: ")
            Text("\(String(updateHoursForTimezone(hours: hours))):\(String(minutes))")
            Spacer()
            Toggle("", isOn: $toogle)
        }
    }
    
    func updateHoursForTimezone(hours: Int) -> Int {
        var newHours = hours
        newHours += GMT
        if newHours > 24 {
            newHours -= 24
        }
        return newHours
    }
}
