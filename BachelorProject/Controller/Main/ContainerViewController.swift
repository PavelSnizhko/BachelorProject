//
//  ContainerViewController.swift
//  BachelorProject
//
//  Created by Павел Снижко on 12.03.2021.
//

import UIKit

class ContainerViewController: UIViewController {

    // MARK: - Properties
    
    var menuController: MenuViewController!
    var centerViewController: UIViewController!
//    var navigationCenterController: UINavigationController!
    var isMenuPresenting: Bool = false
    
    
    // MARK: - Init

    override func viewDidLoad() {
        super.viewDidLoad()
        configureHomeViewController()
        navigationController?.setNavigationBarHidden(true, animated: false)

        title = "fsdfsdds"
        // Do any additional setup after loading the view.
    }
    

    // MARK: - Handlers
    
    func configureHomeViewController() {
        
        let swipingViewController = SwipingViewController()
        swipingViewController.menuDelegate = self
        centerViewController = UINavigationController(rootViewController: swipingViewController)
        addChild(centerViewController)
        view.addSubview(centerViewController.view)
        centerViewController.didMove(toParent: self)
    }
    
    func configureMenuController() {
        if menuController == nil {
            print("New menuController")
            menuController = MenuViewController(nibName: MenuViewController.name, bundle: .main)
            menuController.delegate = self
            view.insertSubview(menuController.view, at: 0)
            menuController.view.frame = view.bounds
            centerViewController.didMove(toParent: self)
        } else {
            print("I've already created")
        }
        
        isMenuPresenting.toggle()
        moveCenterViewController(isMenuPresenting)
    }
    
    
    func moveCenterViewController(_ shouldExpend: Bool ) { //moving home controller
        if shouldExpend {
            UIView.animate(withDuration: 0.8,
                           delay: 0,
                           usingSpringWithDamping: 0.8,
                           initialSpringVelocity: 0,
                           options: .curveEaseInOut,
                           animations: { [weak self] in
                            guard let self = self else { return }
                            self.centerViewController.view.frame.origin.x = self.centerViewController.view.frame.width - 80
                           },
                           completion: nil)
        }
        else {
            UIView.animate(withDuration: 0.8,
                           delay: 0,
                           usingSpringWithDamping: 0.8,
                           initialSpringVelocity: 0,
                           options: .curveEaseInOut,
                           animations: { [weak self] in
                            
                            self?.centerViewController.view.frame.origin.x = 0
                           
                           },
                           completion: nil)
        }
    }

}


extension ContainerViewController {
    private func handleMenuOption() {
        
    }
}


extension ContainerViewController: MenuControllerDelegate {
    func handleMenuTapped() {
        configureMenuController()
    }

}

extension ContainerViewController: SelectOptionDelegate {
    func choseOption(with item: MenuViewController.MenuItem) {
        switch item {
        case .chat:
            let chatVC = ChatViewController(nibName: ChatViewController.name, bundle: .main)
            self.navigationController?.isNavigationBarHidden = false
            navigationController?.pushViewController(chatVC, animated: true)
        case .setting:
            let settingsVC = SettingsViewController(nibName: SettingsViewController.name, bundle: .main)
            navigationController?.pushViewController(settingsVC, animated: true)
        case .home:
            moveCenterViewController(isMenuPresenting)
            isMenuPresenting.toggle()
        }
    }
    
    
}
