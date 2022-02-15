//
//  RealmModel.swift
//  SeSAC-SLP
//
//  Created by Sehun Kang on 2022/02/14.
//

import Foundation
import RealmSwift

class ChatData: Object {
    
    @Persisted var uid: String
    @Persisted var payload: List<Payload>
    
    @Persisted(primaryKey: true) var _id: ObjectId
    
    convenience init(uid: String) {
        self.init()
        
        self.uid = uid
    }
}

///payload in chat API
class Payload: Object {
    
    @Persisted var __v: Int = 0
    @Persisted var _id: String = ""
    @Persisted var chat: String = ""
    @Persisted var createdAt = Date()
    @Persisted var from: String = ""
    @Persisted var to: String = ""
    
    convenience init(__v: Int, _id: String, chat: String, createdAt: Date, from: String, to: String) {
        self.init()

        self.__v = __v
        self._id = _id
        self.chat = chat
        self.createdAt = createdAt
        self.from = from
        self.to = to
    }
}

//
//extension RealmSwift.List: Decodable where Element: Decodable {
//    public convenience init(from decoder: Decoder) throws {
//        self.init()
//        let container = try decoder.singleValueContainer()
//        let decodedElements = try container.decode([Element].self)
//        self.append(objectsIn: decodedElements)
//    }
//}
//
//extension RealmSwift.List: Encodable where Element: Encodable {
//    public func encode(to encoder: Encoder) throws {
//        var container = encoder.singleValueContainer()
//        try container.encode(self.map {$0} )
//    }
//}
//
