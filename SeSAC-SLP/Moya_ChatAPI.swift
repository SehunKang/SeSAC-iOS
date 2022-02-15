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
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .lastChatDate:
            return .get
        case .chatTo:
            return .post
        }
    }
    
    var task: Task {
        switch self {
        case .lastChatDate:
            return .requestPlain
        case .chatTo(_, let text):
            return .requestParameters(parameters: ["chat": text], encoding: URLEncoding.httpBody)
        }
    }
    
    var headers: [String : String]? {
        switch self {
        default:
            return ["idtoken": UserDefaultManager.idtoken]
        }
    }
    
    
}
