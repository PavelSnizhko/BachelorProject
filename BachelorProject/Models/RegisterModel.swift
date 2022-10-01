//
//  RegisterModel.swift
//  BachelorProject
//
//  Created by Павел Снижко on 04.03.2021.
//

import UIKit

enum Sex: String, Codable {
    case male
    case female
}

struct RegisterModel: Codable {
    var _image: Data?
    
    var image: UIImage? {
        didSet {
            self._image = image?.pngData()
        }
    }
    
    var firstName: String?
    var secondName: String?
    var password: String?
    var sex: Sex = .male
    var birthday: String?
    var email: String?
    
    var isFilled: Bool {
        let isFilledUserInfo = image != nil && !firstName.isEmpty && !secondName.isEmpty && birthday != nil
        let isFilledAuthInfo = !password.isEmpty && !email.isEmpty
        
        if isFilledUserInfo && isFilledAuthInfo {
            return true
        }
        
        return false
    }
    
    private enum CodingKeys : String, CodingKey {
        case _image = "image"
        case firstName, birthday, password, email, secondName
    }
    
}


