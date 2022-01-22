//
//  GenderViewModel.swift
//  SeSAC-SLP
//
//  Created by Sehun Kang on 2022/01/23.
//

import Foundation
import RxSwift
import Moya

class GenderViewModel {
    
    let disposeBag = DisposeBag()
    
    func signIn(completion: @escaping (Response?, Error?) -> Void) {
        let provider = MoyaProvider<APIService>()
        provider.request(.signIn) { result in
            
            let res = result.map { response in
                response.debugDescription
            }
            print("signin result: ", res)
            
            switch result {
            case let .success(response):
                completion(response, nil)
            case let .failure(error):
                completion(nil, error)
            }
        }
    }
    
}
