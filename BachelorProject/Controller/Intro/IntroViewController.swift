//
//  ViewController.swift
//  BachelorProject
//
//  Created by Павел Снижко on 03.03.2021.
//

import UIKit

class IntroViewController: UIViewController, NibLoadable {
    @IBOutlet weak var moveToLoginButton: UIButton!
    var isLogin: ItemClosure<Bool>?

    private var authService: AuthorizationService = AuthorizationService(authorizationService: NetworkService())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //TODO: move to coordinator
        if authService.isLogged {
            isLogin?(authService.isLogged)
        }
    }
    
    

    @IBAction func moveForwardPressed(_ sender: Any) {
        let loginVC = LoginViewController(nibName: LoginViewController.name, bundle: .main)
        self.navigationController?.isToolbarHidden = true
        self.navigationController?.pushViewController(loginVC, animated: true)

        isLogin?(false)

    
    }
}

