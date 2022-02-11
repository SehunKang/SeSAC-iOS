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
    case delete
    case hobbyRequest(data: [String: String])
    case hobbyAccept(data: [String: String])
    case myQueueState
    case rate(data: [String: Any], id: String)
    case dodge(data: [String: String])
}

extension APIServiceQueue: TargetType {
    
    public var baseURL: URL {
        return URL(string: "http://test.monocoding.com:35484")!
    }

    var path: String {
        switch self {
        case .onqueue:
            return "/queue/onqueue"
        case .queue, .delete:
            return "/queue"
        case .hobbyRequest:
            return "/queue/hobbyrequest"
        case .hobbyAccept:
            return "/queue/hobbyaccept"
        case .myQueueState:
            return "/queue/myQueueState"
        case .rate(_, let id):
            return "/queue/rate/\(id)"
        case .dodge:
            return "/queue/dodge"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .onqueue:
            return .post
        case .queue:
            return .post
        case .delete:
            return .delete
        case .hobbyRequest:
            return .post
        case .hobbyAccept:
            return .post
        case .myQueueState:
            return .get
        case .rate:
            return .post
        case .dodge:
            return .post
        }
    }
    
    var task: Task {
        switch self {
        case .onqueue(let data):
            return .requestParameters(parameters: data, encoding: URLEncoding.httpBody)
        case .queue(let data):
            return .requestParameters(parameters: data, encoding: URLEncoding.init(destination: .httpBody, arrayEncoding: .noBrackets, boolEncoding: .literal))
        case .delete:
            return .requestPlain
        case .hobbyRequest(let data):
            return .requestParameters(parameters: data, encoding: URLEncoding.httpBody)
        case .hobbyAccept(let data):
            return .requestParameters(parameters: data, encoding: URLEncoding.httpBody)
        case .myQueueState:
            return .requestPlain
        case .rate(let data, _):
            return .requestParameters(parameters: data, encoding: URLEncoding.init(destination: .httpBody, arrayEncoding: .noBrackets, boolEncoding: .literal))
        case .dodge(let data):
            return .requestParameters(parameters: data, encoding: URLEncoding.httpBody)
        }
    }
    
    var headers: [String : String]? {
        switch self {
        default:
            return ["idtoken": UserDefaultManager.idtoken]
        }
    }
    
}
