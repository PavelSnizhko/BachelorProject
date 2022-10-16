//
//  SOSCoordinator.swift
//  BachelorProject
//
//  Created by pavlo.snizhko on 16.10.2022.
//

import Foundation
import UIKit

class SOSCoordinator: BaseCoordinator {
    private let screenFactory: ScreenFactory
    private let router: Router
    var finishFlow: VoidClosure?
    var mainPageViewController: UIViewController!
    
    init(router: Router, screenFactory: ScreenFactory) {
        self.screenFactory = screenFactory
        self.router = router
    }
    
    override func start() {
        let mainPageViewController = screenFactory.makeSOSPageScreen()
        self.mainPageViewController = mainPageViewController
    }
}
