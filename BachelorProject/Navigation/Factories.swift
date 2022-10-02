//
//  Factories.swift
//  BachelorProject
//
//  Created by Павел Снижко on 02.04.2021.
//

import UIKit

protocol AppFactory {
    func makeKeyWindowWithCoordinator(windowScene: UIWindowScene) -> (UIWindow, Coordinator)
}



