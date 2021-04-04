//
//  AuthModel.swift
//  BachelorProject
//
//  Created by Павел Снижко on 02.04.2021.
//

import Foundation

struct AuthModel: Codable {
    var phoneNumber: String?
    var password: String?
    
    var isFilled: Bool {
        !(phoneNumber ?? "").isEmpty && !(password ?? "").isEmpty
    }
    
    private enum CodingKeys : String, CodingKey {
        case phoneNumber = "number"
        case password
    }
}
