//
//  AuthorizationService.swift
//  BachelorProject
//
//  Created by Павел Снижко on 02.04.2021.
//

import Foundation

typealias Authorization = LogInService & RegistrationService & LogOut

protocol LogInService {
    func logIn(authModel: AuthModel, completion: @escaping (Error?) -> Void)
}

protocol RegistrationService {
    func registrate(registerModel: RegisterModel, completion: @escaping (Error?) -> Void)
}

struct AuthorizationService: Authorization {

    private let service: LogInService & RegistrationService
    private var sessionStorage = SessionStorage()
    
    var isLogged: Bool {
        sessionStorage.sessionId != nil
    }
    
    init(authorizationService: LogInService & RegistrationService) {
        service = authorizationService
    }

    func logIn(authModel: AuthModel, completion: @escaping (Error?) -> Void) {
        service.logIn(authModel: authModel) {error in
            DispatchQueue.main.async {
                completion(error)
            }
        }
    }

    func registrate(registerModel: RegisterModel, completion: @escaping (Error?) -> Void) {
        service.registrate(registerModel: registerModel) {error in
            DispatchQueue.main.async {
                completion(error)
            }
        }
    }
    
    func logOut(completion: (Error?) -> Void) {
        
    }

}
