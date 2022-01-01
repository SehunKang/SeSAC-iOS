//
//  MainPostModel.swift
//  SeSAC_Farm
//
//  Created by Sehun Kang on 2022/01/01.
//

import Foundation

struct Post: Codable {
    let id: Int
    let text: String
    let user: UserFromPost
    let createdAt, updatedAt: String
    let comments: [Comment]

    enum CodingKeys: String, CodingKey {
        case id, text, user
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case comments
    }
}


// MARK: - User
struct UserFromPost: Codable {
    let id: Int
    let username, email, provider: String
    let confirmed: Bool
    let blocked: Bool?
    let role: Int
    let createdAt, updatedAt: String

    enum CodingKeys: String, CodingKey {
        case id, username, email, provider, confirmed, blocked, role
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}

