//
//  SignUpModel.swift
//  SeSAC_Farm
//
//  Created by Sehun Kang on 2021/12/31.
//

import Foundation

// MARK: - SignUp
struct SignData: Codable {
    let jwt: String
    let user: User
}

// MARK: - User
struct User: Codable {
    let id: Int
    let username, email, provider: String
    let confirmed: Bool
    let role: Role
    let createdAt, updatedAt: String
    let posts: [PostFromUser]
    let comments: [Comment]

    enum CodingKeys: String, CodingKey {
        case id, username, email, provider, confirmed, role
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case posts, comments
    }
}

struct PostFromUser: Codable {
    let id: Int
    let text: String
    let user: Int
    let createdAt, updatedAt: String
//    let comments: [Comment?]

    enum CodingKeys: String, CodingKey {
        case id, text, user
        case createdAt = "created_at"
        case updatedAt = "updated_at"
//        case comments
    }
}


// MARK: - Comment
struct Comment: Codable {
    let id: Int
    let comment: String
    let user: Int
    let post: Int?
    let createdAt, updatedAt: String

    enum CodingKeys: String, CodingKey {
        case id, comment, user, post
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}

// MARK: - Role
struct Role: Codable {
    let id: Int
    let name, roleDescription, type: String

    enum CodingKeys: String, CodingKey {
        case id, name
        case roleDescription = "description"
        case type
    }
}
