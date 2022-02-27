//
//  NetworkCheck.swift
//  SeSAC-SLP
//
//  Created by Sehun Kang on 2022/01/23.
//

import Foundation
import Alamofire

//NWPathMonitor 참조할것
struct Connectivity {
    static let shared = NetworkReachabilityManager()!
    static var isConnectedToInternet: Bool {
        return self.shared.isReachable
    }
}

