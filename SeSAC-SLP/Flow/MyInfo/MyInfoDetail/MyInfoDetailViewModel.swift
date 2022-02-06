//
//  MyInfoDetailViewModel.swift
//  SeSAC-SLP
//
//  Created by Sehun Kang on 2022/02/03.
//

import Foundation
import Moya
import RxSwift

class MyInfoDetailViewModel {
    
    let disposeBag = DisposeBag()
    
    let userData = UserDefaultManager.userData
    
    func updateMyPage(data: DataForUpdate, completion: @escaping (_ code: Int) -> Void ) {
        
        let updateData = ["searchable": data.searchable, "ageMin": data.ageMin, "ageMax": data.ageMax, "gender": data.gender, "hobby": data.hobby] as [String : Any]
        
        let provider = MoyaProvider<APIServiceUser>()
        
        provider.request(.updateMyPage(data: updateData)) { result in
            switch result {
            case let .success(response):
                completion(response.statusCode)
                self.getUserData()
            case let .failure(error):
                completion(error.errorCode)
            }
        }
    }
    
    func getUserData() {
        let provider = MoyaProvider<APIServiceUser>()
        provider.request(.getUserData) { result in
            switch result {
            case let .success(response):
                switch response.statusCode {
                case 200:
                    let data = try? response.map(UserData.self)
                    UserDefaultManager.userData = data
                default:
                    print(response)
                }
            case let .failure(error):
                print(error)
            }
        }
    }
    
    func withdraw(completion: @escaping (_ code: Int) -> Void) {
        
        let provider = MoyaProvider<APIServiceUser>()
        
        provider.request(.withdraw) { result in
            switch result {
            case let .success(response):
                completion(response.statusCode)
            case let .failure(error):
                completion(error.errorCode)
            }
        }
        
    }
    
    
}

