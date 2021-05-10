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
        
        if authService.isLogged {
            isLogin?(authService.isLogged)
        }
    }

    @IBAction func moveForwardPressed(_ sender: Any) {
        isLogin?(false)
    }
}

