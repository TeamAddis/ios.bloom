//
//  Endpoints.swift
//  Celibi Gardener
//
//  Created by Andrew Addis on 2021/11/20.
//

import Alamofire
import UIKit

protocol APIConfiguration: URLRequestConvertible {
    var path: String { get }
}

enum PumpEndpoint: APIConfiguration {
    func asURLRequest() throws -> URLRequest {
        let url = URL(string: HOST_URL + path)!
        var request = URLRequest(url: url)
        request.method = .post
        
        switch self {
        case .manual(let pumpState):
            request = try JSONParameterEncoder().encode(pumpState, into: request)
        case .alarm(let alarm):
            request = try JSONParameterEncoder().encode(alarm, into: request)
        }
        
        return request
    }
    
    case manual(_ pumpState: PumpState)
    case alarm(_ alarm: AlarmObjectMessage)
    
    var path: String {
        switch self {
        case .manual:
            return "/m"
        case .alarm:
            return "/a"
        }
    }
}


enum StatusEndpoint: APIConfiguration {
    case pumpStatus
    
    var path: String {
        switch self {
        case .pumpStatus:
            return "/ps"
        }
    }
    
    func asURLRequest() throws -> URLRequest {
        let url = URL(string: HOST_URL + path)!
        var request = URLRequest(url: url)
        request.method = .get
        
        switch self {
        case .pumpStatus:
            return request
        }

    }
}
