//
//  ValidationService.swift
//  BachelorProject
//
//  Created by Павел Снижко on 02.04.2021.
//

import Foundation


import Foundation

 protocol ValidationService {
     func validate(password: String?) throws
     func validate(email: String?) throws
     func validate(name: String?) throws
     func validate(for registerModel: RegisterModel) throws
     func validate(for credentials: Credentials) throws
 }


 enum ValidationError: Error {
     case badPassword(String)
     case wrongEmailFormat(String)
     case badName(String)
 }

 extension ValidationError {
     struct Content {
         static let badPasswordLenght = "Password must be at least 8 chars and not more than 64"
         static let nonUpperChar = "Password must include at least one char from [A-Z]"
         static let nonlowerChar = "Password must include at least one char from [a-z]"
         static let nonNumber = "Password must include at 1 number"
         static let badSymbols = "Password must include latin symbols"
         static let passwordRequired = "Please, fill this field. Password is required!"
         static let invalidEmail = "Your email is not correct!"
         static let badNameFormat = "Not allowed symbols in the name"
         static let badNameLenght = "Now allowed lenght of your name"
         static let unknown = "A wrong password or login"
     }
 }

struct DefaultValidationService: ValidationService {
    
    func validate(for credentials: Credentials) throws {
        try validate(password: credentials.password)
        try validate(email: credentials.email)
    }

     func validate(password: String?) throws {
         guard let password = password, password.count >= 8, password.count <= 64  else {
             throw ValidationError.badPassword(ValidationError.Content.badPasswordLenght)
         }
         
         let upperMatch = NSPredicate(format: "SELF MATCHES %@", "(?=.*[A-Z]).*?")

         guard upperMatch.evaluate(with: password) else {
             throw ValidationError.badPassword(ValidationError.Content.nonUpperChar)
         }


         let numberMatch = NSPredicate(format: "SELF MATCHES %@", "(?=.*[0-9]).*?")

         guard numberMatch.evaluate(with: password) else {
             throw ValidationError.badPassword(ValidationError.Content.nonNumber)
         }

         let lowerMatch = NSPredicate(format: "SELF MATCHES %@", "(?=.*[a-z]).*?")

         guard lowerMatch.evaluate(with: password) else {
             throw ValidationError.badPassword(ValidationError.Content.nonlowerChar)
         }
     }

     func validate(email: String?) throws {

         guard let email = email  else {
             throw ValidationError.wrongEmailFormat(ValidationError.Content.invalidEmail)
         }

         let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
         let emmailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)

         guard emmailPredicate.evaluate(with: email) else {
             throw ValidationError.wrongEmailFormat(ValidationError.Content.invalidEmail)
         }
     }

     func validate(name: String?) throws {

         guard let name = name, name.count >= 2, name.count <= 64 else {
             throw ValidationError.badName(ValidationError.Content.badNameLenght)
         }
     }

     func validate(for registerModel: RegisterModel) throws {
         try self.validate(password: registerModel.credentials.password)

         try self.validate(email: registerModel.credentials.email)

         try self.validate(name: registerModel.firstName)
        
         try self.validate(name: registerModel.secondName)
        

     }
 }
