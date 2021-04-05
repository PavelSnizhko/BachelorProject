//
//  SocketIOManager.swift
//  BachelorProject
//
//  Created by Павел Снижко on 05.04.2021.
//

import Foundation


protocol SocketIOManager {
    
    func establishConnection()
    func closeConnection()
    func connectToChat(with name: String)
    func observeUserList(completionHandler: @escaping ([[String: Any]]) -> Void)
    func send(message: String, username: String)
    func observeMessages(completionHandler: @escaping ([String: Any]) -> Void)
    
}
