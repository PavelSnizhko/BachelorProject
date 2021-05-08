//
//  SettingCoordinator.swift
//  BachelorProject
//
//  Created by Павел Снижко on 03.04.2021.
//

import Foundation


class SettingCoordinator: BaseCoordinator {
    
    private let screenFactory: ScreenFactory
    private let router: Router
    
    init(router: Router, screenFactory: ScreenFactory) {
        self.screenFactory = screenFactory
        self.router = router
    }
    
    override func start() {
        
    }
    
}
