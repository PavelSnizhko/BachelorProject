//
//  DI.swift
//  BachelorProject
//
//  Created by pavlo.snizhko on 30.09.2022.
//

import UIKit

protocol DependencyContainer: AnyObject {
    var authService: Authorization { get }
}

final class Di: DependencyContainer {
    lazy var coordinatorFactory: CoordinatorFactory = {
        CoordinatorFactoryImpl(screenFactory: ScreenFactoryImpl(di: self))
    }()
    let authService: Authorization = FirebaseAuthService()
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
