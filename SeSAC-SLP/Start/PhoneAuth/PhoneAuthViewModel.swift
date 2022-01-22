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
import Moya

enum TextError: Error {
    case idError
    case codeError
}

enum ViewCase {
    case phoneNum
    case code
    case nickname
    case email
}

enum validationFieldText: String {
    
    case phoneNumber = "XXX-XXXX-XXXX"
    case oldPhoneNumber = "XXX-XXX-XXXX"
    case code = "XXXXXX"
}

class PhoneAuthViewModel {
    
    var disposeBag = DisposeBag()

    struct Input {
        let text: ControlProperty<String?>
        let tap: ControlEvent<Void>
    }

    struct Output {
        let validStatus: Observable<Bool>
        let newText: Observable<String>
        let sceneTransition: ControlEvent<Void>
        
    }

    func transform(input: Input, valid: ViewCase) -> Output {
        
        let validStatus: Observable<Bool>
        let newText: Observable<String>
        
        switch valid {
        case .phoneNum:
            validStatus = input.text
                .orEmpty
                .map { $0.count < 12 || !$0.validatePhoneNumber }
                .share(replay: 1, scope: .whileConnected)
        case .code:
            validStatus = input.text
                .orEmpty
                .map { $0.count < 6 }
                .share(replay: 1, scope: .whileConnected)
        case .nickname:
            validStatus = input.text
                .orEmpty
                .map { $0.count < 1}
                .share(replay: 1, scope: .whileConnected)
        case .email:
            validStatus = input.text
                .orEmpty
                .map { !$0.validateEmail}
                .share(replay: 1, scope: .whileConnected)
        }
        
        switch valid {
        case .phoneNum:
            newText = input.text
                .orEmpty
                .map {
                    if $0.count < 13 {
                        return self.validationNumberFormat(with: validationFieldText.oldPhoneNumber.rawValue, text: $0)
                    } else {
                        return self.validationNumberFormat(with: validationFieldText.phoneNumber.rawValue, text: $0)
                    }
                }
                .share(replay: 1, scope: .whileConnected)
            
        case .nickname:
            newText = input.text
                .orEmpty
                .map {String($0.prefix(10)) }
                .share(replay: 1, scope: .whileConnected)
            
        default:
            newText = input.text
                .orEmpty
                .asObservable()
                .share(replay: 1, scope: .whileConnected)
        }
 
            
        return Output(validStatus: validStatus, newText: newText, sceneTransition: input.tap)
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
                    UserDefaultManager.verifyId = id
                    let toRemove: Set = [3, 6, 11]
                    let phoneNumber = num.enumerated().filter { !toRemove.contains($0.offset) }.map { $0.element }
                    UserDefaultManager.phoneNumber = String(phoneNumber)
                    completion(nil)
                }
            }
    }
    
    func credentialCheck(verifyCode: String?, completion: @escaping (Error?, AuthDataResult?) -> (Void)) {
        
        let id = UserDefaultManager.verifyId
        
        guard let code = verifyCode else {
            completion(TextError.codeError, nil)
            return
        }
        
        let credential = PhoneAuthProvider.provider().credential(withVerificationID: id, verificationCode: code)
        
        Auth.auth().signIn(with: credential) { result, error in
            if error != nil {
                completion(error, nil)
                return
            } else {
                self.getIdToken { error in
                    if let error = error {
                        completion(error, nil)
                        return
                    }
                }
                completion(error, result)
            }
        }
    }
    
    func getIdToken(completion: @escaping (_ error: Error?) -> Void) {
        let currentUser = Auth.auth().currentUser
        currentUser?.getIDTokenForcingRefresh(true) { idToken, error in
          if let error = error {
              completion(error)
              return;
          }
            UserDefaultManager.idtoken = idToken!
            print(idToken as Any)
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
    
    func getUserData(completion: @escaping (_ code: Int) -> Void) {
        let provider = MoyaProvider<APIService>()
        provider.request(.getUserData) { result in
            
            switch result {
            case let .success(response):
                if response.statusCode == 200 {
                    let data = try? response.map(UserData.self)
                    UserDefaultManager.userData = data
                    completion(response.statusCode)
                } else {
                    completion(response.statusCode)
                }
            case let .failure(error):
                completion(error.errorCode)
            }
        }
    }
    
    func checkDateValue(_ date: String) -> Bool {
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyyMMdd"
        
        guard let age = formatter.date(from: date) else {return true}
        guard let minAge = Calendar.current.date(byAdding: .year, value: -17, to: Date()) else {return true}
        
        return age > minAge
    }
}

