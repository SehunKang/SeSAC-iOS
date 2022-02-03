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
    case signIn(data: SignInData)
    case updateMyPage(data: [String: Any])
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
        case .updateMyPage:
            return "/user/update/mypage"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getUserData:
            return .get
        case .signIn:
            return .post
        case .updateMyPage:
            return .post
        }
    }
    
    var task: Task {
        switch self {
        case .getUserData:
            return .requestPlain
        case .signIn(let data):
            return .requestParameters(parameters: ["phoneNumber": data.phoneNumber, "FCMtoken": data.fcMtoken, "nick": data.nick, "birth": data.birth, "email": data.email, "gender": data.gender], encoding: URLEncoding.httpBody)
        case .updateMyPage(let data):
            return .requestParameters(parameters: data, encoding: URLEncoding.httpBody)
        }
    }
    
    var headers: [String : String]? {
        switch self {
        case .getUserData:
            return ["idtoken": UserDefaultManager.idtoken]
        case .signIn:
            return ["idtoken": UserDefaultManager.idtoken]
        case .updateMyPage:
            return ["idtoken": UserDefaultManager.idtoken]
        }
    }
    
}
