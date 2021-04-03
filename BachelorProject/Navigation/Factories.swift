//
//  Factories.swift
//  BachelorProject
//
//  Created by Павел Снижко on 02.04.2021.
//

import UIKit 

final class Di {
    let coordinatorFactory: CoordinatorFactory = CoordinatorFactoryImpl(screenFactory: ScreenFactoryImpl())
}



protocol AppFactory {
    func makeKeyWindowWithCoordinator(windowScene: UIWindowScene) -> (UIWindow, Coordinator)
}

extension Di: AppFactory {
    
    func makeKeyWindowWithCoordinator(windowScene: UIWindowScene) -> (UIWindow, Coordinator) {
        
        let window = UIWindow()
        window.windowScene = windowScene
        
        let rootVC = UINavigationController()
        rootVC.navigationBar.prefersLargeTitles = true
        
        let router = RouterImp(rootController: rootVC)
        
        let cooridnator = coordinatorFactory.makeApplicationCoordinator(router: router)
        window.rootViewController = rootVC
        
        return (window, cooridnator)
    }
    
}




