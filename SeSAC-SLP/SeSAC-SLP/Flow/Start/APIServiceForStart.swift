//
//  APIServiceForStart.swift
//  SeSAC-SLP
//
//  Created by Sehun Kang on 2022/01/23.
//

import Foundation
import Moya

class APIServiceForStart {
    
    static func signIn(completion: @escaping (_ statusCode: Int) -> Void) {
        
        let provider = MoyaProvider<APIServiceUser>()
        provider.request(.signIn(data: UserDefaultManager.signInData)) { result in
            
            let res = result.map { response in
                response.debugDescription
            }
            print("signin result: ", res)
            
            switch result {
            case let .success(response):
                completion(response.statusCode)
            case let .failure(error):
                completion(error.errorCode)
            }
        }
    }
    
    static func getUserData(completion: @escaping (_ code: Int) -> Void) {
        let provider = MoyaProvider<APIServiceUser>()
        provider.request(.getUserData) { result in
            
            switch result {
            case let .success(response):
                if response.statusCode == 200 {
                    let data = try? response.map(UserData.self)
                    UserDefaultManager.userData = data
                    completion(response.statusCode)
                } else {
                    completion(response.statusCode)
                }
            case let .failure(error):
                completion(error.errorCode)
            }
        }
    }
    
    //언제 해야하고 결과값을 어떻게 해야하나?
    static func fcmTokenUpdate(fcmToken: String) {
        let provider = MoyaProvider<APIServiceUser>()
        provider.request(.updateFcm(fcmToken: fcmToken)) { result in
            switch result {
            case .success(let response):
                print(response.statusCode)
            case .failure(let error):
                print(error.errorCode)
            }
        }
    }


}
