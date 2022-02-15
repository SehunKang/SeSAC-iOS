//
//  SocketManager.swift
//  SeSAC-SLP
//
//  Created by Sehun Kang on 2022/02/15.
//

import Foundation
import SocketIO

class SocketIOManager: NSObject {
    
    static let shared = SocketIOManager()
    
    var manager: SocketManager!
    
    var socket: SocketIOClient!
    
    override init() {
        super.init()
        
        let url = URL(string: "http://test.monocoding.com:35484/")!
        manager = SocketManager(socketURL: url, config: [
            .log(true),
            .compress,
            .extraHeaders(["auth": UserDefaultManager.idtoken])
        ])
        
        socket = manager.defaultSocket
        
        socket.on(clientEvent: .connect) { data, ack in
            print("socket is connected", data, ack)
        }
        
        socket.on(clientEvent: .disconnect) { data, ack in
            print("socket is disconnected", data, ack)
        }
        
        socket.on("chat") { dataArray, ack in
            print("chat received", dataArray, ack)
            let data = dataArray[0] as! NSDictionary
            let __v = data["__v"] as! Int
            let _id = data["_id"] as! String
            let chat = data["chat"] as! String
            let createdAt = data["createdAt"] as! String
            let from = data["from"] as! String
            let to = data["to"] as! String
            
            NotificationCenter.default.post(name: NSNotification.Name("getMessage"), object: self, userInfo: ["__v": __v, "_id": _id, "chat": chat, "createdAt": createdAt, "from": from, "to": to])
        }
    }
    
    func establishConnection() {
        socket.connect()
    }
    
    func closeConnection() {
        socket.disconnect()
    }
}
