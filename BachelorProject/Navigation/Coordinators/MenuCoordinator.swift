//
//  MenuCoordinator.swift
//  BachelorProject
//
//  Created by Павел Снижко on 03.04.2021.
//

import UIKit

class MenuCoordinator: BaseCoordinator {
    
    //MARK: - Properties
    let router: Router
    let screenFactory: ScreenFactory
    
    weak var menuScreen: MenuViewController?
    
    var currentPage: MenuViewController.MenuItem?
    private var coordinatorFactory: CoordinatorFactoryImpl
    var finishFlow: VoidClosure?
    
    
    init(router: Router,
         screenFactory: ScreenFactory,
         coordinatorFactory: CoordinatorFactoryImpl,
         menuScreen: MenuViewController) {
        
        self.router = router
        self.screenFactory = screenFactory
        self.coordinatorFactory = coordinatorFactory
        self.menuScreen = menuScreen
        
    }
    
    //MARK: - override methods

    
    override func start() {

        menuScreen?.selectedOption = { [weak self] option in
            
            switch option {
            case .home:
                print("Home")
            case .setting:
                self?.runSettingFlow()
            case .chat:
                print("Move to chat")
                self?.router.manageBar(true)
                self?.showChat()

            }
            
        }
    }
    
    //MARK: - methods

    
    func runSettingFlow() {
        let settingCoordinator = coordinatorFactory.makeSettingCoordinator(router: router)
        
        settingCoordinator.finishFlow = finishFlow
        
        //Or remove before dependency?
                             
        self.addDependency(settingCoordinator)
        settingCoordinator.start()
    }
    
    func showChat() {
        let chatScreen = screenFactory.makeChatScreen()
        
        router.manageBar(true)
        router.push(chatScreen)
    }
    
    
    func showMenu() {
        let menuScreen = screenFactory.makeMenuScreen()
        
        menuScreen.selectedOption = { [weak self]  option in
            switch option {
            case .home:
                self?.currentPage = .home
                self?.start()
            case .setting:
                self?.currentPage = .setting
                self?.start()
            case .chat:
                self?.currentPage = .chat
                self?.start()
            }
        }
    }
    
}
