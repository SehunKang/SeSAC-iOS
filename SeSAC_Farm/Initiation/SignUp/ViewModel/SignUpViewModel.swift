//
//  SignUpViewModel.swift
//  SeSAC_Farm
//
//  Created by Sehun Kang on 2021/12/31.
//

import Foundation
import UIKit

class SignUpViewModel {
    
    var email: Observable<String> = Observable("")
    var nickName: Observable<String> = Observable("")
    var password: Observable<String> = Observable("")
    var passwordCheck: Observable<String> = Observable("")
    
    func postSignUp(completion: @escaping (APIError?) -> Void) {
        
        APIService.signUp(username: nickName.value, email: email.value, password: password.value) { SignUpData, error in
            
            if SignUpData != nil {
                g_token = SignUpData!.jwt
                g_userId = SignUpData!.user.id
            }
            completion(error)
        }
    }
    
    
}
