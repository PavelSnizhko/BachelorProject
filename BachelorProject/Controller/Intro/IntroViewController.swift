//
//  ViewController.swift
//  BachelorProject
//
//  Created by Павел Снижко on 03.03.2021.
//

import UIKit

class IntroViewController: UIViewController {
    @IBOutlet weak var moveToLoginButton: UIButton!
    
    private var authService: AuthorizationService = AuthorizationService(authorizationService: NetworkService())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //TODO: move to coordinator
        
        if authService.isLogged {
            let contrainerController = ContainerViewController()
            self.navigationController?.isToolbarHidden = true
            self.navigationController?.pushViewController(contrainerController, animated: true)
        }
        
    }
    
    

    @IBAction func moveForwardPressed(_ sender: Any) {
        let loginVC = LoginViewController(nibName: LoginViewController.name, bundle: .main)
        self.navigationController?.isToolbarHidden = true
        self.navigationController?.pushViewController(loginVC, animated: true)
    }
}

