//
//  MyInfoViewModel.swift
//  SeSAC-SLP
//
//  Created by Sehun Kang on 2022/02/02.
//

import UIKit
import Moya

class MyInfoViewModel {
    
    
    func numberOfRowsInSection() -> Int {
        return MyInfoList.allCases.count
    }
    
    func getCellItems() -> [String] {
        return MyInfoList.allCases.map {$0.title}
    }
    
    func getCellImages() -> [UIImage] {
        return MyInfoList.allCases.map {$0.image}
    }
    
    func getUserData(completion: @escaping (_ code: Int) -> Void) {
        let provider = MoyaProvider<APIServiceUser>()
        provider.request(.getUserData) { result in
            switch result {
            case let .success(response):
                switch response.statusCode {
                case 200:
                    let data = try? response.map(UserData.self)
                    UserDefaultManager.userData = data
                    completion(response.statusCode)
                default:
                    completion(response.statusCode)
                }
            case let .failure(error):
                completion(error.errorCode)
            }
        }
    }
    
}

