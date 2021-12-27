//
//  SignUpVIewModel.swift
//  SeSAC_Week14
//
//  Created by Sehun Kang on 2021/12/27.
//

import Foundation
import UIKit

class SignUpViewModel {
    
    var username: Observable<String> = Observable("")
    var password: Observable<String> = Observable("")
    var email: Observable<String> = Observable("")
    
    //viewModel에서 컴플리션으로 뷰컨트롤러에 전달해도 되나? 동작은 한다
    func postUserSignUp(completion: @escaping (APIError?) -> Void) {
        
        APIService.signUp(id: username.value, password: password.value, email: email.value) { userData, error in
            completion(error)
        }
    }
    
}
