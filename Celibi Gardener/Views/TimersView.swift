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
                AlarmListItemView(hours: alarm.hours, minutes: alarm.minutes)
            }
            .navigationTitle(Text("Alarms"))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        self.showCreateAlarmForm = true
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
}

struct AlarmListItemView: View {
    let hours: Int
    let minutes: Int
    
    var body: some View {
        HStack {
            Text("Alarm: ")
            Text("\(String(hours)):\(String(minutes))")
        }
    }
}
