//
//  Credentials.swift
//  BachelorProject
//
//  Created by pavlo.snizhko on 02.10.2022.
//

import Foundation

struct Credentials: Codable {
    var email: String?
    var password: String?
    
    var isFilled: Bool {
        !password.isEmpty && !email.isEmpty
    }
}
