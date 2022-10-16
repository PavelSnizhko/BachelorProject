//
//  AirAlarmCoordinator.swift
//  BachelorProject
//
//  Created by pavlo.snizhko on 16.10.2022.
//

import Foundation
import UIKit

class AirAlarmCoordinator: BaseCoordinator {
    
    private let screenFactory: ScreenFactory
    private let router: Router
    var finishFlow: VoidClosure?
    var airAlarmViewController: UIViewController!
    
    init(router: Router, screenFactory: ScreenFactory) {
        self.screenFactory = screenFactory
        self.router = router
    }
    
    override func start() {
        let airAlarmViewController = screenFactory.makeAirAlarmScreen()
        self.airAlarmViewController = airAlarmViewController
    }
    
}
