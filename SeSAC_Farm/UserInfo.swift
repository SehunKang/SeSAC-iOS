//
//  UserInfo.swift
//  SeSAC_Farm
//
//  Created by Sehun Kang on 2022/01/04.
//

import Foundation

var g_token: String = "" {
    didSet {
        UserDefaults.standard.set(g_token, forKey: "token")
        print(g_token)
    }
}

var g_userId: Int = 0 {
    didSet {
        UserDefaults.standard.set(g_userId, forKey: "userId")
        print(g_userId)
    }
}
