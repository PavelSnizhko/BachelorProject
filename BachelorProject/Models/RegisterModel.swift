//
//  RegisterModel.swift
//  BachelorProject
//
//  Created by Павел Снижко on 04.03.2021.
//

import UIKit

enum Sex: String {
    case male
    case female
}


struct RegisterModel {
    var image: UIImage?
    var firstName: String?
    var secondName: String?
    var password: String?
    var sex: Sex = .male
    var birthday: Date?
    
    var isFilled: Bool {
        guard image != nil, !(firstName ?? " ").isEmpty, !(secondName ?? " ").isEmpty, !(password ?? " ").isEmpty, birthday != nil  else {
            return false
        }
        return true
    }
}
