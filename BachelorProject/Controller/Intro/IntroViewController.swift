//
//  ViewController.swift
//  BachelorProject
//
//  Created by Павел Снижко on 03.03.2021.
//

import UIKit

class IntroViewController: UIViewController, NibLoadable {
    @IBOutlet weak var moveToLoginButton: UIButton!
    
    //TODO: make checking is user logged
    
    
    var isLogin: ItemClosure<Bool>?
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    

    @IBAction func moveForwardPressed(_ sender: Any) {
        isLogin?(false)

        
        
//        let registrationVC = RegisterViewController(nibName: "RegisterViewController", bundle: Bundle.main)
//        self.navigationController?.pushViewController(registrationVC, animated: true)
    }
}

