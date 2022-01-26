//
//  Model.swift
//  CollectionViewPrac
//
//  Created by Sehun Kang on 2022/01/26.
//

import Foundation

struct UserData: Codable, Hashable {
    let hobby: [String]
    let comment: String?
    let reputation: [Int]
    
    let identifier = UUID()

    enum CodingKeys: String, CodingKey {
        case hobby, comment, reputation
    }
}
