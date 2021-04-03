//
//  MenuCoordinator.swift
//  BachelorProject
//
//  Created by Павел Снижко on 03.04.2021.
//

import UIKit

class MenuCoordinator: BaseCoordinator {
    
    let router: Router
    let screenFactory: ScreenFactory
    weak var menuScreen: MenuViewController?
    var currentPage: MenuViewController.MenuItem?
    var coordinatorFactory: CoordinatorFactoryImpl
    
    //TODO: maybe make for coordinator factory delegate to folow srp principle
    
    init(router: Router, screenFactory: ScreenFactory, coordinatorFactory: CoordinatorFactoryImpl, menuScreen: MenuViewController) {
        
        self.router = router
        self.screenFactory = screenFactory
        self.coordinatorFactory = coordinatorFactory
        self.menuScreen = menuScreen
        
    }
    
    
    
    override func start() {
        print("Start")
        
        menuScreen?.selectedOption = { [weak self] option in
            
            switch option {
                
            case .home:
                print("Home")
            case .setting:
                print("Setting")
            case .chat:
                print("Move to chat")
                self?.showChat()
            }
            
            
        }
        
//        if currentPage == nil {
//            showMenu()
//        } else {
//            switch currentPage {
//
//            case .setting:
//                runSettingFlow()
//
//            case .chat:
//                print("chat")
//                showChat()
//                currentPage = nil
//            case .home:
//
//                print("home")
//
//            case .none:
//                 print("fdfd")
//            }
//        }
    }
    
    func runSettingFlow() {
//        let settingCoordinator = coordinatorFactory.se
    }
    
    func showChat() {
        let chatScreen = screenFactory.makeChatScreen()
        
        print(router)
//        router.push(chatScreen, animated: true, hideBottomBar: false, completion: nil)
        router.push(chatScreen)
    }
    
    func showMenu() {
        let menuScreen = screenFactory.makeMenuScreen()
        
        menuScreen.selectedOption = { [weak self]  option in
            switch option {
            case .home:
                
                // TODO: throw above
                print("home")
            case .setting:
                self?.currentPage = .setting
                self?.start()
            case .chat:
                self?.currentPage = .chat
                self?.start()
            }
        }
    }
    
    enum Pages {
        case chat
        case setting
        case logOut
        case home
        
    }
    
}




//class FackeVoiceCoordinator {
//
//}
//
//class RecordingSettingCoordinator {
//
//}
