//
//  FirebaseAuthService.swift
//  BachelorProject
//
//  Created by pavlo.snizhko on 01.10.2022.
//

import Foundation
import FirebaseAuth
import FirebaseDatabase

protocol LogOut {
    func logOut(completion: (Error?) -> Void)
}

struct FirebaseAuthService: RegistrationService, LogInService {

    private let authService = Auth.auth()
    private let dataBase = Database.database().reference()
    private let sessionStorage = SessionStorage()
    
    func registrate(registerModel: RegisterModel, completion: @escaping (Error?) -> Void) {
        //TODO: avoid unwraping optionality here
        guard let email = registerModel.email, let password = registerModel.password else {
            return completion(ValidationError.wrongEmailFormat(ValidationError.Content.invalidEmail))
        }
        
        authService.createUser(withEmail: email, password: password) { authResult, error in
            if error != nil {
                return completion(error)
            }
            
            if let authResult {
                //TODO: now we store just UID, however there should be a token from firebase,
                let uid = authResult.user.uid
                sessionStorage.sessionId = uid
                save(model: registerModel, for: uid)
            }
        }
    }
    
    func logIn(authModel: AuthModel, completion: @escaping (Error?) -> Void) {
        return
    }
    
    private func retriveSessionToken() {
        
    }
    
    private func save(model: RegisterModel, for uid: String) {
        do {
            let jsonEncoder = JSONEncoder()
            let registrationData = try jsonEncoder.encode(model)
            let json = try JSONSerialization.jsonObject(with: registrationData)
            
            dataBase.child("users/\(uid)/").setValue(json)
        } catch let error {
            print("We come up with error \(error.localizedDescription)")
        }
    }
}

extension FirebaseAuthService: LogOut {
    func logOut(completion: (Error?) -> Void) {
        do {
            try authService.signOut()
        } catch let error {
            completion(error)
        }
        completion(nil)
    }
}
