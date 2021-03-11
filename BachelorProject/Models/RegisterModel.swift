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
    var email: String?
    
    var isFilled: Bool {
        
        let isFilledUserInfo = image != nil && !(firstName ?? " ").isEmpty && !(secondName ?? " ").isEmpty &&  birthday != nil
        
        let isFilledAuthInfo = !(password ?? " ").isEmpty  && !(email ?? " ").isEmpty
        
        guard  isFilledUserInfo && isFilledAuthInfo  else {
            return false
        }
        
        return true
    }
}
