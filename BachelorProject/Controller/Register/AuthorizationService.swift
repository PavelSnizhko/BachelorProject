//
//  AuthorizationService.swift
//  BachelorProject
//
//  Created by Павел Снижко on 02.04.2021.
//

import Foundation

protocol LogInService {

    func logIn(phone: String, password: String, completion: @escaping (Error?) -> Void)

}

protocol RegistrationService {

    func registrate(phone: String, password: String, name: String, completion: @escaping (Error?) -> Void)

}


struct AuthorizationService: LogInService, RegistrationService {

    private let service: LogInService & RegistrationService

    init(authorizationService: LogInService & RegistrationService) {
        service = authorizationService
    }

    func logIn(phone: String, password: String, completion: @escaping (Error?) -> Void) {
        service.logIn(phone: phone, password: password, completion: completion)
    }

    func registrate(phone: String, password: String, name: String, completion: @escaping (Error?) -> Void) {
        service.registrate(phone: phone, password: password, name: name, completion: completion)
    }

}
