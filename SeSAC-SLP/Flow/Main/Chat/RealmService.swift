//
//  RealmService.swift
//  SeSAC-SLP
//
//  Created by Sehun Kang on 2022/02/15.
//

import Foundation
import RealmSwift
import RxSwift

class RealmService {
    
    private init() {}
    
    static let shared = RealmService()

    var realm = try! Realm()
    
    ///uid와의 챗으로 새로운 DB 생성
    func createNewChatData(of uid: String) {
        let object = ChatData(uid: uid)
//        object.payload.append(Payload())
        do {
            try realm.write {
                realm.add(object)
            }
        } catch {
            fatalError("realm creteNewChatData failed")
        }
    }
    
    ///uid와의 모든 채팅 내역을 불러옴
    func getAllChatData(from uid: String) -> [Payload] {
        guard let object = realm.objects(ChatData.self).filter("uid == %@", uid).first else {return []}
        let payload = Array(object.payload.sorted(byKeyPath: "createdAt", ascending: false))
        return payload
    }
    
    ///uid와의 마지막 채팅을 불러옴
    func lastChatDate(with uid: String) -> String {
        guard let object = realm.objects(ChatData.self).filter("uid == %@", uid).first?.payload.sorted(byKeyPath: "createdAt", ascending: false).last?.createdAt else {return "2000-01-01T00:00:00.000Z" }
        return object.toString
    }
    
    ///uid의 DB에 새로운 데이터 추가
    func appendChatData(of uid: String, payload: [Payload] ) {
        guard let object = realm.objects(ChatData.self).filter("uid == %@", uid).first else {return}
        do {
            try realm.write {
                object.payload.append(objectsIn: payload)
            }
        } catch {
            fatalError("realm appendChatData failed")
        }
    }
    
    //첫 채팅이면 true를 리턴
    func isFirstChat(with uid: String) -> Bool {
        return realm.objects(ChatData.self).filter("uid == %@", uid).isEmpty
    }
    
    func deleteDB(of uid: String) {
        guard let object = realm.objects(ChatData.self).filter("uid == %@", uid).first else {return}
        do {
            try realm.write {
                realm.delete(object.payload)
                realm.delete(object)
            }
        } catch {
            fatalError("deleteDB failed")
        }
    }
    
    
    
    
//    func realmBind(with uid: String) -> Observable<Payload> {
////        guard let object = realm.objects(ChatData.self).filter("uid == %@", uid).first else {return nil}
//        guard let object = realm.objects(ChatData.self).filter("uid == %@", uid).first?.payload else {fatalError("realm bind failed")}
//
//        let observable = Observable.collection(from: object)
//            .map { payload in
//                payload.sorted(byKeyPath: "createdAt", ascending: false) .last!
//            }
//        return observable
//    }
    
    
}
