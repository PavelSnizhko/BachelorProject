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
    var isMenuPresenting: Bool = false
    var showingMenuScreen: VoidClosure?
    
    // MARK: - Override

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        navigationItem.largeTitleDisplayMode = .never
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.setNavigationBarHidden(true, animated: animated)

    }
    
    func configureHomeViewController(swipingViewController: SwipingViewController) {
        
        if centerViewController == nil {
            centerViewController = UINavigationController(rootViewController: swipingViewController)
            
            addChild(centerViewController)
            view.addSubview(centerViewController.view)
            centerViewController.didMove(toParent: self)
        }
     
    }
    
    func configureMenuController(menuViewController: MenuViewController) {
        
            menuController = menuViewController
            view.insertSubview(menuController.view, at: 0)
            menuController.view.frame = view.bounds
            centerViewController.didMove(toParent: self)
        
    }
    
    
    func moveCenterViewController(_ shouldExpend: Bool ) {
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
