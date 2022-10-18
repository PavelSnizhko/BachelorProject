//
//  ApplicationCoordinator.swift
//  BachelorProject
//
//  Created by Павел Снижко on 02.04.2021.
//

import Foundation

/// The coordinator is responsible only for navigation and don't have nested buisness logic
final class ApplicationCoordinator: BaseCoordinator {
    private let firstLaunchKey = "firstLaunch"

    private let coordinatorFactory: CoordinatorFactory
    private let router: Router
    
    private var isFirstLaunch: Bool {
        !UserDefaults.standard.bool(forKey: firstLaunchKey)
    }
    private var isLogin = false
    private var isRegister = true
    
    init(router: Router, coordinatorFactory: CoordinatorFactory) {
        self.router = router
        self.coordinatorFactory = coordinatorFactory
    }
    
    override func start() {
        
        if isFirstLaunch {
            runStartFlow()
            UserDefaults.standard.setValue(true, forKey: firstLaunchKey)
            return
        }
        
        if isLogin {
            mainFlow()
        } else if !isRegister {
            router.manageBar(false)
            runRegisterFlow()
        } else {
            runLoginFlow()
        }
    }
    
    private func runStartFlow() {
        
        let coordinator = coordinatorFactory.makeStartCoordinator(router: router)
        
        coordinator.finishFlow = { [weak self, weak coordinator] isLogin in
            
            self?.isLogin = isLogin
            self?.start()
            self?.removeDependency(coordinator)
            
        }
        self.addDependency(coordinator)
        coordinator.start()
    }
    
    private func runLoginFlow() {
        let coordinator = coordinatorFactory.makeLoginCoordinator(router: router)
        
        coordinator.finishFlow = { [weak self, weak coordinator] in
            
            self?.isLogin = true
            self?.start()
            self?.removeDependency(coordinator)
            
        }
        
        coordinator.onRegister = { [weak self, weak coordinator] in
            
            self?.isRegister = false
            self?.start()
            self?.removeDependency(coordinator)
        }
        
        self.addDependency(coordinator)
        coordinator.start()
    }
    
    private func runRegisterFlow() {
        
        let coordinator = coordinatorFactory.makeRegisterCoordinator(router: router)
        
        coordinator.finishFlow = { [weak self, weak coordinator] in
            
                self?.isLogin = true
                self?.start()
                self?.removeDependency(coordinator)
            
            }
        
        coordinator.onLogin = { [weak self, weak coordinator] in
            
            self?.isRegister = true
            self?.start()
            self?.removeDependency(coordinator)
        }

        self.addDependency(coordinator)
        coordinator.start()
    }
    
    private func mainFlow() {

        //TODO: add tab bar with nested routers        
        let coordinator = coordinatorFactory.makeTabBarCoordinator(router: router)
        
        coordinator.finishFlow = { [weak self, weak coordinator] in
            
            self?.isLogin = false
            self?.start()
            self?.removeDependency(coordinator)
            
        }
        
        self.addDependency(coordinator)
        coordinator.start()
    }
}
    

