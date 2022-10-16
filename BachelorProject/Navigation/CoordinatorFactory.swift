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
    
    func makeTabBarCoordinator(router: Router) -> TabBarCoordinator
    
    func makeRegisterCoordinator(router: Router) -> RegisterCoordinator
    
    func makeMenuCoordinator(with router: Router, and viewController: MenuViewController) -> MenuCoordinator
    
    func makeStartCoordinator(router: Router) -> StartCoordinator
    
    func makeSettingCoordinator(router: Router) -> SettingCoordinator
    
    func makeAirAlarmCoordinator(router: Router) -> AirAlarmCoordinator
    
    func makeSosCoordinator(router: Router) -> SOSCoordinator

}


final class CoordinatorFactoryImpl: CoordinatorFactory {
  
    private let screenFactory: ScreenFactory
    
    init(screenFactory: ScreenFactory){
        self.screenFactory = screenFactory
    }
        
    func makeApplicationCoordinator(router: Router) -> ApplicationCoordinator {
        ApplicationCoordinator(router: router, coordinatorFactory: self)
    }
    
    func makeLoginCoordinator(router: Router) -> LoginCoordinator {
        LoginCoordinator(router: router, screenFactory: screenFactory)
    }

    func makeRegisterCoordinator(router: Router) -> RegisterCoordinator {
        RegisterCoordinator(router: router, screenFactory: screenFactory)
    }
    
    func makeMenuCoordinator(with router: Router, and viewController: MenuViewController) -> MenuCoordinator {
        MenuCoordinator(router: router, screenFactory: screenFactory, coordinatorFactory: self, menuScreen: viewController)
    }
    
    func makeTabBarCoordinator(router: Router) -> TabBarCoordinator {
        TabBarCoordinator(router: router, screenFactory: screenFactory, coordinatorFactory: self)
    }
    
    func makeSettingCoordinator(router: Router) -> SettingCoordinator {
        SettingCoordinator(router: router, screenFactory: screenFactory)
    }
    
    func makeStartCoordinator(router: Router) -> StartCoordinator {
        StartCoordinator(router: router, screenFactory: screenFactory)
    }
    
    func makeAirAlarmCoordinator(router: Router) -> AirAlarmCoordinator {
        AirAlarmCoordinator(router: router, screenFactory: screenFactory)
    }
    
    func makeSosCoordinator(router: Router) -> SOSCoordinator {
        SOSCoordinator(router: router, screenFactory: screenFactory)
    }
}
