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
        let tap: ControlEvent<Void>
    }

    struct Output {
        let validStatus: Observable<Bool>
        let validCodeStatus: Observable<Bool>
        let newText: Observable<String>
        let sceneTransition: ControlEvent<Void>
        
    }

    func transform(input: Input) -> Output {
        let textToBool = input.text
            .orEmpty
            .map { $0.count < 13 }
            .share(replay: 1, scope: .whileConnected)
        
        let codeToBool = input.text
            .orEmpty
            .map { $0.count < 6 }
            .share(replay: 1, scope: .whileConnected)
        
        let newText = input.text
            .orEmpty
            .asObservable()
            .share(replay: 1, scope: .whileConnected)
        
                
        return Output(validStatus: textToBool, validCodeStatus: codeToBool, newText: newText, sceneTransition: input.tap)
    }
    
    
}

extension PhoneAuthViewModel {
    
    
    func requestVerifyId(phoneNumber: String?, completion: @escaping (Error?) -> (Void) ) {
        
        Auth.auth().languageCode = "ko";
        
        guard var num = phoneNumber else {return}
        num = "+82\(num)"
        PhoneAuthProvider.provider()
            .verifyPhoneNumber(num, uiDelegate: nil) { id, error in
                if error != nil {
                    completion(error)
                    return
                } else {
                    guard let id = id else {return}
                    UserInfoManager.idtoken = id
                    let toRemove: Set = [3, 6, 11]
                    let phoneNumber = num.enumerated().filter { !toRemove.contains($0.offset) }.map { $0.element }
                    UserInfoManager.phoneNumber = String(phoneNumber)
                    completion(nil)
                }
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
    
    
    func validationNumberFormat(with mask: String, text: String) -> String {
        let numbers = text.replacingOccurrences(of: "[^0-9]", with: "", options: .regularExpression)
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

enum validationFieldText: String {
    
    case phoneNumber = "XXX-XXXX-XXXX"
    case code = "XXXXXX"
}
