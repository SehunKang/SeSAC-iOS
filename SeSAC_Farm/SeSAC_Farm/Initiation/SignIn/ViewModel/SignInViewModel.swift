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
//    var check: Observable<Bool> = Observable(false)
    var check: Observable<Bool> = Observable(false)
    
    func postSignIn(completion: @escaping (APIError?) -> Void) {
        
        APIService.signIn(email: email.value, password: password.value) { data, error in
            if data != nil {
                g_token = data!.jwt
                g_userId = data!.user.id
                if self.check.value == true {
                    UserDefaults.standard.set(self.email.value, forKey: "email")
                    UserDefaults.standard.set(self.password.value, forKey: "password")
                } else {
                    UserDefaults.standard.set(nil, forKey: "email")
                    UserDefaults.standard.set(nil, forKey: "password")
                }
            }
            completion(error)
        }
        
    }
}

extension SignInViewModel {
    
    
    
}
