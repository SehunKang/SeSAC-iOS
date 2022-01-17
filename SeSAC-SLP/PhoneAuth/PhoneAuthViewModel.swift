//
//  PhoneAuthViewModel.swift
//  SeSAC-SLP
//
//  Created by Sehun Kang on 2022/01/17.
//

import Foundation
import RxSwift
import FirebaseAuth
import RxCocoa

enum TextError: Error {
    case idError
    case codeError
}

class PhoneAuthViewModel {
    
    var verifyId: String?
    
    var disposeBag = DisposeBag()

    struct Input {
        let text: ControlProperty<String?>
    }

    struct Output {
        let validStatus: Observable<Bool>
        let newText: Observable<String>
        
    }

    func transform(input: Input) -> Output {
        let newText = input.text
            .orEmpty
            .map { text in
                self.phoneNumberFormat(with: "XXX-XXXX-XXXX", phone: text)
            }
            .share(replay: 1, scope: .whileConnected)
        
        let textToBool = input.text
            .orEmpty
            .map { $0.count > 12 }
            .share(replay: 1, scope: .whileConnected)
        
        return Output(validStatus: textToBool, newText: newText)
    }
    
}

extension PhoneAuthViewModel {
    
    
    func requestVerifyId(phoneNumber: String?, completion: @escaping (Error?) -> (Void) ) {
        guard var num = phoneNumber else {return}
        num = "+82\(num)"
        print(num)
        PhoneAuthProvider.provider()
            .verifyPhoneNumber(num, uiDelegate: nil) { id, error in
                if error != nil {
                    completion(error)
                    return
                } else {
                    self.verifyId = id
                    print("code = ", self.verifyId!)
                }
                Auth.auth().languageCode = "kr"
            }
    }
    
    func credentialCheck(verifyCode: String?, completion: @escaping (Error?, AuthDataResult?) -> (Void)) {
        
        guard let id = self.verifyId else {
            completion(TextError.idError, nil)
            return
        }
        guard let code = verifyCode else {
            completion(TextError.codeError, nil)
            return
        }
        
        let credential = PhoneAuthProvider.provider().credential(withVerificationID: id, verificationCode: code)
        
        Auth.auth().signIn(with: credential) { result, error in
            completion(error, result)
        }
        
    }
    
    
    func phoneNumberFormat(with mask: String, phone: String) -> String {
        let numbers = phone.replacingOccurrences(of: "[^0-9]", with: "", options: .regularExpression)
        var result = ""
        var index = numbers.startIndex // numbers iterator

        // iterate over the mask characters until the iterator of numbers ends
        for ch in mask where index < numbers.endIndex {
            if ch == "X" {
                // mask requires a number in this place, so take the next one
                result.append(numbers[index])

                // move numbers iterator to the next index
                index = numbers.index(after: index)

            } else {
                result.append(ch) // just append a mask character
            }
        }
        return result
    }
}
