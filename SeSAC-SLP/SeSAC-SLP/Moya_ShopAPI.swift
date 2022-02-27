//
//  Moya_ShopAPI.swift
//  SeSAC-SLP
//
//  Created by Sehun Kang on 2022/02/22.
//

import Foundation
import Moya

enum APIServiceShop {
    case update(sesac: Int, background: Int)
    case validate(receipt: String, productIdentifier: String)
    case myInfo
}

extension APIServiceShop: TargetType {
    
    var baseURL: URL {
        return URL(string: "http://test.monocoding.com:35484")!
    }
    
    var path: String {
        switch self {
        case .update:
            return "/user/update/shop"
        case .validate:
            return "/user/shop/ios"
        case .myInfo:
            return "/user/shop/myinfo"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .update:
            return .post
        case .validate:
            return .post
        case .myInfo:
            return .get
        }
    }
    
    var task: Task {
        switch self {
        case .update(let sesac, let background):
            return .requestParameters(parameters: ["sesac": sesac, "background": background], encoding: URLEncoding.httpBody)
        case .validate(let receipt, let productIdentifier):
            return .requestParameters(parameters: ["receipt": receipt, "product": productIdentifier], encoding: URLEncoding.httpBody)
        case .myInfo:
            return .requestPlain
        }
    }
    
    var headers: [String : String]? {
        return ["idtoken": UserDefaultManager.idtoken]
    }
    
    
}
