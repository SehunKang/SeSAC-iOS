//
//  Moya_QueueAPI.swift
//  SeSAC-SLP
//
//  Created by Sehun Kang on 2022/02/05.
//

import Foundation
import Moya

enum APIServiceQueue {
    case onqueue(data: [String: Any])
    case queue(data: [String: Any])
}

extension APIServiceQueue: TargetType {
    
    public var baseURL: URL {
        return URL(string: "http://test.monocoding.com:35484")!
    }

    var path: String {
        switch self {
        case .onqueue:
            return "/queue/onqueue"
        case .queue:
            return "/queue"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .onqueue:
            return .post
        case .queue:
            return .post
        }
    }
    
    var task: Task {
        switch self {
        case .onqueue(let data):
            return .requestParameters(parameters: data, encoding: URLEncoding.httpBody)
        case .queue(let data):
            return .requestParameters(parameters: data, encoding: URLEncoding.httpBody)
        }
    }
    
    var headers: [String : String]? {
        switch self {
        case .onqueue:
            return ["idtoken": UserDefaultManager.idtoken]
        case .queue:
            return ["idtoken": UserDefaultManager.idtoken]
        }
    }
    
}
