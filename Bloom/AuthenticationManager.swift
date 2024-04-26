//
//  AuthenticationManager.swift
//  Bloom
//
//  Created by Andrew Addis on 2024/04/21.
//

import Foundation
import AWSIoT



class AuthenticationManager: ObservableObject {
    static let shared = AuthenticationManager()
    
    @Published var isConnected: Bool = false
    
    private(set) var identityPoolId: String = ""
    private(set) var clientId: String = ""
    
    init() {
        // open secrets file to get the items we need
        let secrets = readPlist(name: "secrets")
        identityPoolId = secrets?["identityPoolId"] as? String ?? ""
        
        let credentials = AWSCognitoCredentialsProvider(regionType: .APNortheast1, identityPoolId: identityPoolId)
        let configuration = AWSServiceConfiguration(region: .APNortheast1, credentialsProvider: credentials)
        
        AWSIoT.register(with: configuration!, forKey: "aAWSIoT")
        
        let endPoint = AWSEndpoint(urlString: secrets?["iotEndPoint"] as? String ?? "")
        let dataConfiguration = AWSServiceConfiguration(region: .APNortheast1, endpoint: endPoint, credentialsProvider: credentials)
        
        AWSIoTDataManager.register(with: dataConfiguration!, forKey: "aDataManager")
        
        credentials.getIdentityId().continueWith(block: { (task:AWSTask<NSString>) -> Any? in
            if let error = task.error as NSError? {
                print("Failed to get client ID: \(error)")
                return nil
            }
            
            self.clientId = task.result! as String
            print("Got client ID => \(self.clientId)")
            return nil
        })
        
        connectToAWSIoT()
    }
    
    private func connectToAWSIoT() {
        // Function to handle mqtt event callback
        func mqttEventCallback(_ status: AWSIoTMQTTStatus ) {
            switch status {
            case .connecting: print("Connecting to AWS IoT")
            case .connected:
                print("Connected to AWS IoT")
                DispatchQueue.main.async {
                    self.isConnected = true
                }
            case .connectionError: print("AWS IoT connection error")
            case .connectionRefused: print("AWS IoT connection refused")
            case .protocolError: print("AWS IoT protocol error")
            case .disconnected: print("AWS IoT disconnected")
            case .unknown: print("AWS IoT unknown state")
            default: print("Error - unknown MQTT state")
            }
        }
        
        DispatchQueue.global(qos: .background).async {
            print("Attempting to connect to IoT device gateway with ID = \(self.clientId)")
            let dataManager = AWSIoTDataManager(forKey: "aDataManager")
            dataManager.connectUsingWebSocket(withClientId: self.clientId, cleanSession: true, statusCallback: mqttEventCallback)
        }
    }
}
