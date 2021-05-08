//
//  LoginCoordinator.swift
//  BachelorProject
//
//  Created by Павел Снижко on 02.04.2021.
//

import Foundation


final class LoginCoordinator: BaseCoordinator {
    
    var finishFlow: VoidClosure?
    var onRegister: VoidClosure?
    
    private let screenFactory: ScreenFactory
    private let router: Router
    
    init(router: Router, screenFactory: ScreenFactory) {
        self.screenFactory = screenFactory
        self.router = router
    }
    
    override func start() {
        showLogin()
    }
    
    private func showLogin() {
        let loginScreen = screenFactory.makeLoginScreen()
        loginScreen.onLogin = { [weak self] in
            
            self?.finishFlow?()
        }
        
        loginScreen.onRegister = { [weak self] in
            
            self?.onRegister?()
            
        }
                
        router.setRootModule(loginScreen, hideBar: false)
    }
}
