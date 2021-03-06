//
//  SettingCoordinator.swift
//  BachelorProject
//
//  Created by Павел Снижко on 03.04.2021.
//

import Foundation


class SettingCoordinator: BaseCoordinator {
    
    private let screenFactory: ScreenFactory
    private let router: Router
    var finishFlow: VoidClosure?
    
    init(router: Router, screenFactory: ScreenFactory) {
        self.screenFactory = screenFactory
        self.router = router
    }
    
    override func start() {
        let settingScreen = screenFactory.makeSettingScreen()
        settingScreen.choosenOption = { [weak self] option in
            guard let self = self else { return }
            switch option {
            case .account:
                //TODO: make account screen
                print("Type on account screen")
            case .voice:
                let fackeVoiceVC = self.screenFactory.makeFackeVoiceScreen()
                self.router.push(fackeVoiceVC, animated: true)
            case .audio:
                let audioVC = self.screenFactory.makeRecordingSetting()
                self.router.push(audioVC, animated: true)
            case .password:
                print("password")
            case .logout:
                self.finishFlow?()
            }
            
        }
        router.push(settingScreen, animated: true)
        
    }
    
}
