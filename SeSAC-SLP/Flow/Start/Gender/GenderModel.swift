//
//  GenderModel.swift
//  SeSAC-SLP
//
//  Created by Sehun Kang on 2022/01/23.
//

import Foundation

struct SignInData: Codable {
    var phoneNumber, fcMtoken, nick: String
    var birth: Date
    var email: String
    var gender: Int

    enum CodingKeys: String, CodingKey {
        case phoneNumber
        case fcMtoken = "FCMtoken"
        case nick, birth, email, gender
    }
}
