//
//  ContainerViewController.swift
//  BachelorProject
//
//  Created by Павел Снижко on 12.03.2021.
//

import UIKit

class ContainerViewController: UIViewController {

    // MARK: - Properties
    
    var menuController: UIViewController!
    var centerViewController: UIViewController!
    var navigationCenterController: UINavigationController!
    var isMenuPresenting: Bool = false
    
    
    // MARK: - Init

    override func viewDidLoad() {
        super.viewDidLoad()
        configureHomeViewController()
        title = "fsdfsdds"
        // Do any additional setup after loading the view.
    }
    

    // MARK: - Handlers
    
    func configureHomeViewController() {
        
        let swipingViewController = SwipingViewController()
        swipingViewController.menuDelegate = self
        swipingViewController.view.frame = view.frame
        
        centerViewController = swipingViewController
        
        navigationCenterController = UINavigationController(rootViewController: centerViewController)
        
        addChild(navigationCenterController)
        navigationCenterController.view.frame = view.frame
        view.addSubview(navigationCenterController.view)
        navigationCenterController.didMove(toParent: self)
        
        
//        view.addSubview(mainPage.view)
//        addChild(mainPage)
//        navigationController.didMove(toParent: self)
        
    }
    
    func configureMenuController() {
        if menuController == nil {
            print("New menuController")
            menuController = MenuViewController(nibName: MenuViewController.name, bundle: .main)
            view.insertSubview(menuController.view, at: 0)
            menuController.didMove(toParent: self)
        } else {
            print("Fuck you)))")
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
                            self.navigationCenterController.view.frame.origin.x = self.navigationCenterController.view.frame.width - 80
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
                            
                            self?.navigationCenterController.view.frame.origin.x = 0
                           
                           },
                           completion: nil)
        }
    }

}


extension ContainerViewController: MenuControllerDelegate {
    func handleMenuTapped() {
        configureMenuController()
    }
}
