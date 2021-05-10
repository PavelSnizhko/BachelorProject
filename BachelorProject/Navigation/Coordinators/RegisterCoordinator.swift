//
//  RegisterCoordinator.swift
//  BachelorProject
//
//  Created by Павел Снижко on 03.04.2021.
//

import Foundation


final class RegisterCoordinator: BaseCoordinator {
    
    var finishFlow: VoidClosure?
    var onLogin: VoidClosure?
    
    private let router: Router
    private let screenFactory: ScreenFactory
    
    init(router: Router, screenFactory: ScreenFactory) {
        self.router = router
        self.screenFactory = screenFactory
    }
    
    override func start() {
        showRegister()
    }
    
    private func showRegister() {
        let registerScreen = screenFactory.makeRegisterScreen()
        
        registerScreen.finishFlow = { [weak self] in

            self?.finishFlow?()
            
        }
        
        registerScreen.onLogin = { [weak self, weak router] in
            
            router?.dismissModule(animated: true, completion: nil)
            self?.onLogin?()
            
        }
        
        router.setRootModule(registerScreen, hideBar: false)
    }
}
