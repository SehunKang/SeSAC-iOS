//
//  Moya.swift
//  SeSAC-SLP
//
//  Created by Sehun Kang on 2022/01/20.
//

import Foundation
import Moya

enum APIService {
    case getUserData
    case signIn
}

extension APIService: TargetType {
    public var baseURL: URL {
        return URL(string: "http://test.monocoding.com:35484")!
    }
    
    public var path: String {
        switch self {
        case .getUserData:
            return "/user"
        case .signIn:
            return "/user"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getUserData:
            return .get
        case .signIn:
            return .post
        }
    }
    
    var task: Task {
        switch self {
        case .getUserData:
            return .requestPlain
        case .signIn:
            return .requestParameters(parameters: [
                "phoneNumber": UserDefaultManager.phoneNumber,
                "FCMtoken": UserDefaultManager.FCMtoken,
                "nick": UserDefaultManager.nick,
                "birth": UserDefaultManager.birth,
                "email": UserDefaultManager.email,
                "gender": UserDefaultManager.gender
            ], encoding: JSONEncoding.default)
        }
    }
    
    var headers: [String : String]? {
        switch self {
        case .getUserData:
            return ["idtoken": UserDefaultManager.idtoken]
        case .signIn:
            return ["idtoken": UserDefaultManager.idtoken]
        }
    }
    
}
