//
//  APIServiceForShop.swift
//  SeSAC-SLP
//
//  Created by Sehun Kang on 2022/02/22.
//

import Foundation
import Moya

class APIServiceForShop {
    
    static func update(sesacImage: Int, backgroundImage: Int, completion: @escaping (_ result: Int) -> ()) {
        let provider = MoyaProvider<APIServiceShop>()
        provider.request(.update(sesac: sesacImage, background: backgroundImage)) { result in
            switch result {
            case .success(let response):
                completion(response.statusCode)
            case .failure(let error):
                fatalError(error.localizedDescription)
            }
        }
    }
    
    static func validate(receipt: String, productIdentifier: String, completion: @escaping (_ result: Int) -> ()) {
        let provider = MoyaProvider<APIServiceShop>()
        provider.request(.validate(receipt: receipt, productIdentifier: productIdentifier)) { result in
            switch result {
            case .success(let response):
                completion(response.statusCode)
            case .failure(let error):
                fatalError(error.localizedDescription)
            }
        }
    }

    static func myInfo(completion: @escaping (_ myInfo: MyInfo?, _ result: Int?) ->()) {
        let provider = MoyaProvider<APIServiceShop>()
        provider.request(.myInfo) { result in
            switch result {
            case .success(let response):
                if response.statusCode == 200 {
                    guard let resultData = try? response.map(MyInfo.self) else {print("myinfo map error");return}
                    completion(resultData, nil)
                } else {
                    completion(nil, response.statusCode)
                }
            case .failure(_):
                completion(nil, nil)
            }
        }
    }
}

struct MyInfo: Codable {
    let id: String
    let v: Int
    let uid, phoneNumber, email, fcMtoken: String
    let nick: String
    let gender: Int
    let hobby: String
    let comment: [String]
    let reputation: [Int]
    let sesac: Int
    let sesacCollection: [Int]
    let background: Int
    let backgroundCollection: [Int]
    let purchaseToken, transactionID, reviewedBefore: [String]
    let reportedNum: Int
    let reportedUser: [String]
    let dodgepenalty, dodgeNum, ageMin, ageMax: Int
    let searchable: Int
    let createdAt, birth: Date

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case v = "__v"
        case uid, phoneNumber, email
        case fcMtoken = "FCMtoken"
        case nick, birth, gender, hobby, comment, reputation, sesac, sesacCollection, background, backgroundCollection, purchaseToken
        case transactionID = "transactionId"
        case reviewedBefore, reportedNum, reportedUser, dodgepenalty, dodgeNum, ageMin, ageMax, searchable, createdAt
    }
}
