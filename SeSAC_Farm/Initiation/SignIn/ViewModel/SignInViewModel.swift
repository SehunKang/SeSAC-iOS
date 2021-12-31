//
//  SignInViewModel.swift
//  SeSAC_Farm
//
//  Created by Sehun Kang on 2021/12/31.
//

import Foundation

class SignInViewModel {
    
    var email: Observable<String> = Observable("")
    var password: Observable<String> = Observable("")
    
    func postSignIn(completion: @escaping (APIError?) -> Void) {
        
        APIService.signIn(email: email.value, password: password.value) { data, error in
            if data != nil {
                token = data!.jwt
            }
            completion(error)
        }
        
    }
}
