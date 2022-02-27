//
//  Moya_ChatAPI.swift
//  SeSAC-SLP
//
//  Created by Sehun Kang on 2022/02/15.
//

import Foundation
import Moya

enum APIServiceChat {
    case lastChatDate(from: String, lastChatDate: String)
    case chatTo(to: String, text: String)
    case report(data: [String: Any])
    case dodge(uid: String)
    case review(data: [String: Any])
}


extension APIServiceChat: TargetType {
    
    public var baseURL: URL {
        return URL(string: "http://test.monocoding.com:35484")!
    }
    
    var path: String {
        switch self {
        case .lastChatDate(let from, _):
            return "/chat/\(from)"
        case .chatTo(let to, _):
            return "/chat/\(to)"
        case .report:
            return "/user/report"
        case .dodge:
            return "/queue/dodge"
        case .review(let data):
            return "queue/rate/\(data["otheruid"]!)"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .lastChatDate:
            return .get
        case .chatTo:
            return .post
        case .report:
            return .post
        case .dodge:
            return .post
        case .review:
            return .post
        }
    }
    
    var task: Task {
        switch self {
        case .lastChatDate(_, let date):
            return .requestParameters(parameters: ["lastchatDate": date], encoding: URLEncoding.queryString)
        case .chatTo(_, let text):
            return .requestParameters(parameters: ["chat": text], encoding: URLEncoding.httpBody)
        case .report(let data):
            return .requestParameters(parameters: data, encoding: URLEncoding.init(destination: .httpBody, arrayEncoding: .noBrackets, boolEncoding: .literal))
        case .dodge(let uid):
            return .requestParameters(parameters: ["otheruid": uid], encoding: URLEncoding.httpBody)
        case .review(let data):
            return .requestParameters(parameters: data, encoding: URLEncoding.init(destination: .httpBody, arrayEncoding: .noBrackets, boolEncoding: .literal))
        }
    }
    
    var headers: [String : String]? {
        switch self {
        default:
            return ["idtoken": UserDefaultManager.idtoken]
        }
    }
    
    
}
