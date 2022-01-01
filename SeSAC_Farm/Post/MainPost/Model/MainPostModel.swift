//
//  MainPostModel.swift
//  SeSAC_Farm
//
//  Created by Sehun Kang on 2022/01/01.
//

import Foundation

struct EasyPost: Codable {
    let id: Int
    let text: String
    let user: EasyUser
    let updatedAt: String
    let comments: [EasyComment]
    
    enum CodingKeys: String, CodingKey {
        case id, text, user, comments
        case updatedAt = "updated_at"
    }
}

struct EasyUser: Codable {
    let username: String
}

struct EasyComment: Codable {
    let id: Int
}
