//
//  GenderModel.swift
//  SeSAC-SLP
//
//  Created by Sehun Kang on 2022/01/23.
//

import Foundation

struct SignInData: Codable {
    let phoneNumber, fcMtoken, nick: String
    let birth: Date
    let email: String
    let gender: Int

    enum CodingKeys: String, CodingKey {
        case phoneNumber
        case fcMtoken = "FCMtoken"
        case nick, birth, email, gender
    }
}
