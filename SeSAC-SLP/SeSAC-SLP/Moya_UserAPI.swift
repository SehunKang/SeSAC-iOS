//
//  Moya.swift
//  SeSAC-SLP
//
//  Created by Sehun Kang on 2022/01/20.
//

import Foundation
import Moya

enum APIServiceUser {
    case getUserData
    case signIn(data: SignInData)
    case updateMyPage(data: [String: Any])
    case withdraw
    case updateFcm(fcmToken: String)
}

extension APIServiceUser: TargetType {
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
        case .withdraw:
            return "/user/withdraw"
        case .updateFcm:
            return "user/update_fcm_token"
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
        case .withdraw:
            return .post
        case .updateFcm:
            return .put
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
        case .withdraw:
            return .requestPlain
        case .updateFcm(let fcmToken):
            return .requestParameters(parameters: ["FCMtoken": fcmToken], encoding: URLEncoding.httpBody)
        }
    }
    
    var headers: [String : String]? {
        switch self {
        default:
            return ["idtoken": UserDefaultManager.idtoken]
        }
    }
    
}
