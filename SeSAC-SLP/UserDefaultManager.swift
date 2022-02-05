//
//  UserDefaults.swift
//  SeSAC-SLP
//
//  Created by Sehun Kang on 2022/01/20.
//

import Foundation
import SwiftUI

enum Gender: Int {
    case none = -1
    case male = 1
    case female = 0
}

enum UserStatus: String {
    case normal = "normal"
    case searching = "searching"
    case doneMatching = "doneMatching"
}

@propertyWrapper
struct UserDefault<T> {
    
    private let key: String
    private let defaultValue: T
    private let storage: UserDefaults
    
    var wrappedValue: T {
        get { self.storage.object(forKey: self.key) as? T ?? self.defaultValue}
        set { self.storage.set(newValue, forKey: self.key)}
    }
    
    init(key: String, defaultValue: T, storage: UserDefaults = .standard) {
        self.key = key
        self.defaultValue = defaultValue
        self.storage = storage
    }
}

@propertyWrapper
struct UserDefaultStruct<T: Codable> {
    
    private let key: String
    private let defaultValue: T?
    
    var wrappedValue: T? {
        get {
            if let savedData = UserDefaults.standard.object(forKey: key) as? Data {
                let decoder = JSONDecoder()
                if let object = try? decoder.decode(T.self, from: savedData) {
                    return object
                }
            }
            return defaultValue
        }
        set {
            let encoder = JSONEncoder()
            if let encoded = try? encoder.encode(newValue) {
                UserDefaults.standard.setValue(encoded, forKey: key)
            }
        }
    }
    
    init(key: String, defaultValue: T?) {
        self.key = key
        self.defaultValue = defaultValue
    }
    
}

class UserDefaultManager {
    
    @UserDefault(key: "verifyToken", defaultValue: "")
    static var verifyId: String
    
    @UserDefault(key: "idtoken", defaultValue: "")
    static var idtoken: String
    
    ///1일 경우 invalid
    @UserDefault(key: "validNickFlag", defaultValue: 0)
    static var validNickFlag: Int
    
    @UserDefault(key: "userStatus", defaultValue: UserStatus.normal.rawValue)
    static var userStatus: UserStatus.RawValue
    
    @UserDefaultStruct(key: "userData", defaultValue: nil)
    static var userData: UserData?
    
    @UserDefaultStruct(key: "signInData", defaultValue: SignInData(phoneNumber: "", fcMtoken: "", nick: "", birth: Date(), email: "", gender: Gender.none.rawValue))
    static var signInData: SignInData!
}
