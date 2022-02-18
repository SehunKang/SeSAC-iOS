//
//  APIServiceForChat.swift
//  SeSAC-SLP
//
//  Created by Sehun Kang on 2022/02/15.
//

import Foundation
import Moya

class APIServiceForChat {
    
    static func sendChat(to uid: String, text: String, completion: @escaping (_ result: Result<Response, MoyaError>) -> () ) {
        let provider = MoyaProvider<APIServiceChat>()
        provider.request(.chatTo(to: uid, text: text)) { result in
            completion(result)
        }
    }
    
    static func lastChat(to uid: String, at date: String, completion: @escaping (_ result:  Result<Response, MoyaError>) -> ()) {
        let provider = MoyaProvider<APIServiceChat>()
        provider.request(.lastChatDate(from: uid, lastChatDate: date)) { result in
            completion(result)
        }
    }
    
    static func report(data: [String: Any], completion: @escaping (_ result:  Int) -> ()) {
        let provider = MoyaProvider<APIServiceChat>()
        provider.request(.report(data: data)) { result in
            switch result {
            case .success(let response):
                completion(response.statusCode)
            case .failure(let error):
                fatalError(error.localizedDescription)
            }
        }
    }
    
}
