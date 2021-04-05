//
//  SocketIOManagerDefault.swift
//  BachelorProject
//
//  Created by Павел Снижко on 05.04.2021.
//

import Foundation
import SocketIO

class SocketIOManagerDefault: NSObject, SocketIOManager {
    
    //MARK: - Instance Properties
    
    private var manager: SocketManager!
    private var socket: SocketIOClient!
    
    //MARK: - Initializers
    
    override init() {
        super.init()
        
        manager = SocketManager(socketURL: URL(string: "http://10.17.33.93:3000")!)
        socket = manager.defaultSocket
    }
    
    //MARK: - Instance Methods
    
    func establishConnection() {
        socket.connect()
    }
    
    func closeConnection() {
        socket.disconnect()
    }
    
    func connectToChat(with name: String) {
        socket.emit("connectUser", name)
    }
    
    func observeUserList(completionHandler: @escaping ([[String: Any]]) -> Void) {
        socket.on("userList") { dataArray, _ in
            completionHandler(dataArray[0] as! [[String: Any]])
        }
    }
    
    func send(message: String, username: String) {
        socket.emit("chatMessage", username, message)
    }
    
    func observeMessages(completionHandler: @escaping ([String: Any]) -> Void) {
        socket.on("newChatMessage") { dataArray, _ in
            var messageDict: [String: Any] = [:]
            
            messageDict["nickname"] = dataArray[0] as! String
            messageDict["message"] = dataArray[1] as! String
            
            completionHandler(messageDict)
        }
    }
}
