//
//  UserDefaults.swift
//  SeSAC-SLP
//
//  Created by Sehun Kang on 2022/01/20.
//

import Foundation


@propertyWrapper
struct UserDefault<T> {
    
    let key: String
    let defaultValue: T
    let storage: UserDefaults
    
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

class UserInfoManager {
    
    @UserDefault(key: "phoneNumber", defaultValue: "")
    static var phoneNumber: String
    
    @UserDefault(key: "FCMtoken", defaultValue: "")
    static var FCMtoken: String
    
    @UserDefault(key: "nick", defaultValue: "")
    static var nick: String
    
    @UserDefault(key: "birth", defaultValue: Date())
    static var birth: Date
    
    @UserDefault(key: "email", defaultValue: "")
    static var email: String
    
    @UserDefault(key: "gender", defaultValue: 2)
    static var gender: Int
    
    @UserDefault(key: "idtoken", defaultValue: "")
    static var idtoken: String
    
}
