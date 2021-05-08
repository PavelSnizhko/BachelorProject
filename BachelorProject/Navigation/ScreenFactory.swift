//
//  ScreenFactory.swift
//  BachelorProject
//
//  Created by Павел Снижко on 03.04.2021.
//

import Foundation


protocol ScreenFactory {
    
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

    
}

final class ScreenFactoryImpl: ScreenFactory {
    
    func makeSwipingScreen() -> SwipingViewController {
        SwipingViewController()
    }
    
    func makeContainerScreen() -> ContainerViewController {
        ContainerViewController()
    }
    
    func makeLoginScreen() -> LoginViewController {
        LoginViewController(nibName: LoginViewController.name, bundle: .main)
    }
    
    func makeIntroScreen() -> IntroViewController {
        IntroViewController(nibName: IntroViewController.name, bundle: .main)
    }
    
    func makeRegisterScreen() -> RegisterViewController {
        RegisterViewController(nibName: RegisterViewController.name, bundle: .main)
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
        SettingsViewController(nibName: SettingsViewController.name, bundle: .main)

    }
    
    func makeFackeVoiceScreen() -> FackeVoiceViewController {
        FackeVoiceViewController(nibName: FackeVoiceViewController.name, bundle: .main)

    }
    
    func makeRecordingSetting() -> RecordingVoiceViewController {
        RecordingVoiceViewController(nibName: RecordingVoiceViewController.name, bundle: .main)

    }
    
    fileprivate weak var di: Di!
    init(){}
    
    
}
