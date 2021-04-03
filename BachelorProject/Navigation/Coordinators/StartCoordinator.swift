//
//  StartCoordinator.swift
//  BachelorProject
//
//  Created by Павел Снижко on 03.04.2021.
//

import Foundation


final class StartCoordinator: BaseCoordinator {
    var finishFlow: ItemClosure<Bool>?
    
    private let router: Router
    private let screenFactory: ScreenFactory
    
    init(router: Router, screenFactory: ScreenFactory) {
        self.router = router
        self.screenFactory = screenFactory
    }
    
    override func start() {
        showSplash()
    }
    
    private func showSplash() {
        let introScreen = screenFactory.makeIntroScreen()
        introScreen.isLogin = { [weak self] status in
         
            self?.finishFlow?(status)
            
        }
        
        router.setRootModule(introScreen, hideBar: false)

    }
}
