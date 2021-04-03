//
//  CoordinatorFactory.swift
//  BachelorProject
//
//  Created by Павел Снижко on 02.04.2021.
//

import Foundation


protocol CoordinatorFactory {
    
    func makeApplicationCoordinator(router: Router) -> ApplicationCoordinator
    
    func makeLoginCoordinator(router: Router) -> LoginCoordinator
    
    func makeMainCoordinator(router: Router) -> MainCoordinator
    
    func makeRegisterCoordinator(router: Router) -> RegisterCoordinator
    
    func makeMenuCoordinator(with router: Router, and viewController: MenuViewController) -> MenuCoordinator
    
    func makeStartCoordinator(router: Router) -> StartCoordinator
}


final class CoordinatorFactoryImpl: CoordinatorFactory {
    
    private let screenFactory: ScreenFactory
    
    init(screenFactory: ScreenFactory){
        self.screenFactory = screenFactory
    }
    
    func makeApplicationCoordinator(router: Router) -> ApplicationCoordinator {
        return ApplicationCoordinator(router: router, coordinatorFactory: self)
    }
    
    func makeLoginCoordinator(router: Router) -> LoginCoordinator {
        return LoginCoordinator(router: router, screenFactory: screenFactory)
    }

    func makeRegisterCoordinator(router: Router) -> RegisterCoordinator {
        RegisterCoordinator(router: router, screenFactory: screenFactory)
    }
    
    func makeMenuCoordinator(with router: Router, and viewController: MenuViewController) -> MenuCoordinator {
        MenuCoordinator(router: router, screenFactory: screenFactory, coordinatorFactory: self, menuScreen: viewController)
    }
    
    func makeMainCoordinator(router: Router) -> MainCoordinator {
        MainCoordinator(router: router, screenFactory: screenFactory, coordinatorFactory: self)
    }
    
    func makeStartCoordinator(router: Router) -> StartCoordinator {
        return StartCoordinator(router: router, screenFactory: screenFactory)
    }
}
