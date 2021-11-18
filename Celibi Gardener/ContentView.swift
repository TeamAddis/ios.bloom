//
//  ContentView.swift
//  Celibi Gardener
//
//  Created by Andrew Addis on 2021/11/18.
//

import SwiftUI
import Alamofire


struct ContentView: View {
    var body: some View {
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
    AF.request("http://192.168.1.118/H").response { response in
        debugPrint(response)
    }
}

func offButtonPressed() {
    AF.request("http://192.168.1.118/L").response { response in
        debugPrint(response)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
