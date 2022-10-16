//
//  ScreenFactory.swift
//  BachelorProject
//
//  Created by Павел Снижко on 03.04.2021.
//

import Foundation
import UIKit


protocol ScreenFactory: AnyObject {
    func makeSwipingScreen() -> SwipingViewController
    func makeContainerScreen() -> ContainerViewController
    func makeIntroScreen() -> IntroViewController
    func makeRegisterScreen() -> RegisterViewController
    func makeLoginScreen() -> LoginViewController
    func makeHomeScreen() -> ContainerViewController
    func makeChatScreen() -> ChatViewController
    func makeSettingScreen() -> SettingsViewController
    func makeFackeVoiceScreen() -> FackeVoiceViewController
    func makeRecordingSetting() -> RecordingVoiceViewController
    func makeMenuScreen() -> MenuViewController
    func makeSOSPageScreen() -> MainPageViewController
    func makeAirAlarmScreen() -> AirAlarmViewController
    func makeChatViewController() -> ChatViewController
}

final class ScreenFactoryImpl: ScreenFactory {
    func makeSOSPageScreen() -> MainPageViewController {
        let viewController = MainPageViewController(nibName: MainPageViewController.name,
                                                    bundle: .main)
        let image = UIImage(named: "sos")

        viewController.tabBarItem = UITabBarItem(title: "Main", image: image, tag: 0)
        
        return viewController
    }
    
    func makeAirAlarmScreen() -> AirAlarmViewController {
        let viewController = AirAlarmViewController(collectionViewLayout: .init())
        let image = UIImage(named: "alarm")

        viewController.tabBarItem = UITabBarItem(title: "Air Alarm", image: image, tag: 1)
        return viewController
    }
    
    private weak var di: DependencyContainer!
        
    func makeSwipingScreen() -> SwipingViewController {
        SwipingViewController(authService: di.authService)
    }
    
    func makeContainerScreen() -> ContainerViewController {
        ContainerViewController()
    }
    
    func makeLoginScreen() -> LoginViewController {
        LoginViewController(authService: di.authService, nibName: LoginViewController.name, bundle: .main)
    }
    
    func makeIntroScreen() -> IntroViewController {
        IntroViewController(nibName: IntroViewController.name, bundle: .main)
    }
    
    func makeRegisterScreen() -> RegisterViewController {
        RegisterViewController(authService: di.authService, nibName: RegisterViewController.name, bundle: .main)
    }
    
    func makeHomeScreen() -> ContainerViewController {
        ContainerViewController()
    }
    
    func makeMenuScreen() -> MenuViewController {
        MenuViewController(nibName: MenuViewController.name, bundle: .main)
    }
    
    func makeChatScreen() -> ChatViewController {
        ChatViewController(nibName: ChatViewController.name, bundle: .main)
    }
    
    func makeSettingScreen() -> SettingsViewController {
        let viewController = SettingsViewController(nibName: SettingsViewController.name, bundle: .main)
        let image = UIImage(named: "settings")
        viewController.tabBarItem = UITabBarItem(title: "Settings", image: image, tag: 2)
        viewController.authService = di.authService
        return viewController
    }
    
    func makeFackeVoiceScreen() -> FackeVoiceViewController {
        FackeVoiceViewController(nibName: FackeVoiceViewController.name, bundle: .main)
    }
    
    func makeRecordingSetting() -> RecordingVoiceViewController {
        RecordingVoiceViewController(nibName: RecordingVoiceViewController.name, bundle: .main)
    }
    
    func makeChatViewController() -> ChatViewController {
        let viewController = ChatViewController(nibName: ChatViewController.name,
                                                bundle: .main)
        
//        viewController.tabBarItem = UITabBarItem(title: "Chat", image: .checkmark, tag: 1)
        
        return viewController
    }
        
    init(di: DependencyContainer){
        self.di = di
    }
}
