//
//  MainCoordinator.swift
//  BachelorProject
//
//  Created by Павел Снижко on 03.04.2021.
//

import UIKit


class MainCoordinator: BaseCoordinator {
    
    var finishFlow: VoidClosure?
    
    private let router: Router
    private let screenFactory: ScreenFactory
    private var controllers: [UIViewController] = []
    
//    private var containerController: ContainerViewController
    
    private var menuViewController: MenuViewController!
    private var swipingViewController: SwipingViewController!
    
    private let coordinatorFactory: CoordinatorFactory
    
    var isMenuPresenting: Bool = false
    var isMenuAdded: Bool = false

    
    init(router: Router,
         screenFactory: ScreenFactory,
         coordinatorFactory: CoordinatorFactory) {
        
        self.router = router
        self.screenFactory = screenFactory
        self.coordinatorFactory = coordinatorFactory
        
    }
    
    override func start() {
        if isMenuPresenting {
            router.manageBar(true)
            runMenuCoordinatorFlow(with: menuViewController, and: router)
        }
        else {
            showContainer()
            
        }
    }
    
    func runMenuCoordinatorFlow(with menuVC: MenuViewController, and router: Router) {
        
        if !isMenuAdded {
            let coordinator = coordinatorFactory.makeMenuCoordinator(with: router,
                                                                     and: menuVC)
            
            
            
            
            addDependency(coordinator)
            
            coordinator.start()

        } else {
            guard let coordinator = childCoordinators.last else { return }
            coordinator.start()
        }
        
    }

    
    func showContainer() {
        
        let containerScreen = screenFactory.makeContainerScreen()
        
        menuViewController = screenFactory.makeMenuScreen()
        
        swipingViewController = screenFactory.makeSwipingScreen()
        
        swipingViewController.menuPressed = { [weak self] in
            guard let self = self else { return }

            self.isMenuPresenting.toggle()
            
            containerScreen.moveCenterViewController(self.isMenuPresenting)
            self.start()
        }
        
        containerScreen.configureHomeViewController(swipingViewController: swipingViewController)
        containerScreen.configureMenuController(menuViewController: menuViewController)
        
//        let newRoot = UINavigationController(rootViewController: swippingScreen)
        
//        containerScreen.showingMenuScreen { [weak self] in
//
//            self?.runMenuCoordinatorFlow()
//
//        }
        
        router.setRootModule(containerScreen)
        print(router)
    }
    
//    func showMenu() {
//        let coordinator = coordinatorFactory.makeMenuCoordinator(router: router)
//        coordinator.finishFlow = { [weak self, weak coordinator] isLogin in
//            self?.isFirstLaunch = false
//            self?.isLogin = isLogin
//            self?.start()
////            self?.removeDependency(coordinator)
//        }
//        self.addDependency(coordinator)
//        coordinator.start()
//
//    }
    
    func showMainPage() {
        
    }
    
    
    enum ControllersType: CaseIterable {
        case swipingMain
        case menu
        
        
        
        var tag: Int {
            switch self {
            case .swipingMain:
                return 0
            case .menu:
                return 1
            }
        }
    }
}
