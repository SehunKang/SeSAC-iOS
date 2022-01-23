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
    
    func signIn(completion: @escaping (_ statusCode: Int) -> Void) {
        
        
        let phone = UserDefaultManager.phoneNumber
        let fcm = UserDefaultManager.FCMtoken
        let nick = UserDefaultManager.nick
        let birth = UserDefaultManager.birth
        let email = UserDefaultManager.email
        let gender = UserDefaultManager.gender
        
        let data = SignInData(phoneNumber: phone, fcMtoken: fcm, nick: nick, birth: birth, email: email, gender: gender)

        print("phone = \(phone)\nfcm = \(fcm)\nnick = \(nick)\nbirth = \(birth)\nemail = \(email)\ngender = \(gender)")
        
        let provider = MoyaProvider<APIService>()
        provider.request(.signIn(data: data)) { result in
            
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
    
    
    
}
