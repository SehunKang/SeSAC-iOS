//
//  DetailPostModel.swift
//  SeSAC_Farm
//
//  Created by Sehun Kang on 2022/01/02.
//

import Foundation

struct DetailComment: Codable {
    let id: Int
    let comment: String
    let user: UserFromComment
    let createdAt, updatedAt: String

    enum CodingKeys: String, CodingKey {
        case id, comment, user
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}

struct UserFromComment: Codable {
    let id: Int
    let username: String
    let email: String
    
}
