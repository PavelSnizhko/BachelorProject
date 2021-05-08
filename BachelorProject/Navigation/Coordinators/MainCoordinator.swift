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
    
    private var containerScreen: ContainerViewController!
    
    private var menuViewController: MenuViewController!
    private var swipingViewController: SwipingViewController!
    
    private let coordinatorFactory: CoordinatorFactory
    
    var isMenuPresenting: Bool = false
    var isMenuAdded: Bool = false
    
    private var firstCall: Bool = false {
        didSet {
            router.push(containerScreen)
            router.manageBar(true)
        }
    }
    
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
            if !firstCall {
                firstCall.toggle()
            }
        }
    }
    
    func runMenuCoordinatorFlow(with menuVC: MenuViewController, and router: Router) {
        
        if !isMenuAdded {
            let coordinator = coordinatorFactory.makeMenuCoordinator(with: router,
                                                                     and: menuVC)
                
            addDependency(coordinator)
            
            coordinator.start()
            
            isMenuAdded.toggle()

        } else {
            guard let coordinator = childCoordinators.last else { return }

            coordinator.start()
        }
        
    }

    
    func showContainer() {
        //TODO: check if it's not awoke every time
        //make checking maybe bool propery for not repiting creation of screen
        if containerScreen == nil {
            containerScreen = screenFactory.makeContainerScreen()
            menuViewController = screenFactory.makeMenuScreen()

            swipingViewController = screenFactory.makeSwipingScreen()
        }
        
       
        
        swipingViewController.menuPressed = { [weak self] in
            guard let self = self else { return }

            self.isMenuPresenting.toggle()
            
            self.containerScreen.moveCenterViewController(self.isMenuPresenting)
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
        
    }
    
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
