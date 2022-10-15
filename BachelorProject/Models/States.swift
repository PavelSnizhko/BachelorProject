//
//  States.swift
//  BachelorProject
//
//  Created by Павел Снижко on 13.10.2022.
//

import Foundation

// MARK: - StateList
struct StateList: Codable {
    let states: [State]
    let lastUpdate: String?
    
    enum CodingKeys: String, CodingKey {
        case states
        case lastUpdate = "last_update"
    }
}

// MARK: - State
struct State: Codable, Hashable {
    let id: Int
    let name: String
    let nameEn: String
    let alert: Bool
    let changed: String?
    
    enum CodingKeys: String, CodingKey {
        case id, name
        case nameEn = "name_en"
        case alert, changed
    }
}


// MARK: - Welcome
struct StateContainer: Codable {
    let state: State
    let notificationID: String

    enum CodingKeys: String, CodingKey {
        case state
        case notificationID = "notification_id"
    }
}
