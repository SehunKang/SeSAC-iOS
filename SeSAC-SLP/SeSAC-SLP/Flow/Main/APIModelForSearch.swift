//
//  APIModelForSearch.swift
//  SeSAC-SLP
//
//  Created by Sehun Kang on 2022/02/12.
//

import Foundation


// MARK: - onqueue
struct QueueData: Codable {
    let fromQueueDB, fromQueueDBRequested: [FromQueueDB]
    let fromRecommend: [String]
}

struct FromQueueDB: Codable, Hashable {
    let uid, nick: String
    let lat, long: Double
    let reputation: [Int]
    let hf, reviews: [String]
    let gender, type, sesac, background: Int
}

// MARK: - Location
struct UserLocation: Codable {
    let region: Int
    let lat: Double
    let long: Double
    
    init(region: Int, lat: Double, long: Double) {
        self.region = region
        self.lat = lat
        self.long = long
    }
}

struct MyQueueStatus: Codable {
    let dodged, matched, reviewed: Int
    let matchedNick, matchedUid: String
}
