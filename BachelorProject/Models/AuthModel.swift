//
//  AuthModel.swift
//  BachelorProject
//
//  Created by Павел Снижко on 02.04.2021.
//

import Foundation

struct AuthModel: Codable {
    var email: String?
    var password: String?
    
    var isFilled: Bool {
        !(email ?? "").isEmpty && !(password ?? "").isEmpty
    }
    
    private enum CodingKeys : String, CodingKey {
        case email
        case password
    }
}
