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
}


extension APIServiceChat: TargetType {
    
    public var baseURL: URL {
        return URL(string: "http://test.monocoding.com:35484")!
    }
    
    var path: String {
        switch self {
        case .lastChatDate(let from, let lastChatDate):
            return "/chat/\(from)?lastchatDate=\(lastChatDate)"
        case .chatTo(let to, _):
            return "/chat/\(to)"
        case .report:
            return "/user/report"
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
        }
    }
    
    var task: Task {
        switch self {
        case .lastChatDate:
            return .requestPlain
        case .chatTo(_, let text):
            return .requestParameters(parameters: ["chat": text], encoding: URLEncoding.httpBody)
        case .report(let data):
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
