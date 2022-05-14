//
//  ManualView.swift
//  Celibi Gardener
//
//  Created by Andrew Addis on 2022/05/14.
//

import SwiftUI
import Alamofire

struct ManualView: View {
    @EnvironmentObject var serverStatus: ServerStatus
    
    var body: some View {
        VStack {
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
    
    func onButtonPressed() {
        AF.request(PumpEndpoint.manual(PumpState(isOn: true))).response { response in
            serverStatus.getServerStatus()
        }
    }

    func offButtonPressed() {
        AF.request(PumpEndpoint.manual(PumpState(isOn: false))).response { response in
            serverStatus.getServerStatus()
        }
    }
}

struct ManualView_Previews: PreviewProvider {
    static var previews: some View {
        ManualView()
    }
}
