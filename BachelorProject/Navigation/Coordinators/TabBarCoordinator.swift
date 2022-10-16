//
//  MainCoordinator.swift
//  BachelorProject
//
//  Created by Павел Снижко on 03.04.2021.
//

import UIKit


class TabBarCoordinator: BaseCoordinator {
    
    var finishFlow: VoidClosure?
    
    private let router: Router
    private let screenFactory: ScreenFactory

    let tabBarViewController = UITabBarController()

    private let coordinatorFactory: CoordinatorFactory
    
    init(router: Router,
         screenFactory: ScreenFactory,
         coordinatorFactory: CoordinatorFactory) {
        
        self.router = router
        self.screenFactory = screenFactory
        self.coordinatorFactory = coordinatorFactory
        
    }
    
    override func start() {
        let sosCoordinator = coordinatorFactory.makeSosCoordinator(router: router)
        sosCoordinator.start()
        
        let sosVC = sosCoordinator.mainPageViewController
        
        let airAlarmCoordinator = coordinatorFactory.makeAirAlarmCoordinator(router: router)
        airAlarmCoordinator.start()
        let airAlarmVC = airAlarmCoordinator.airAlarmViewController
        
        
        let settingCoordinator = coordinatorFactory.makeSettingCoordinator(router: router)
        settingCoordinator.start()
        let settingVC = settingCoordinator.settingViewController
        
        settingCoordinator.finishFlow = finishFlow
        
        guard let sosVC, let airAlarmVC, let settingVC else {
            return
        }
        
        [sosCoordinator, airAlarmCoordinator, settingCoordinator].forEach(addDependency(_:))
        tabBarViewController.viewControllers = [sosVC, airAlarmVC, settingVC]
        router.setRootModule(tabBarViewController, hideBar: true)
    }
}
