//
//  Alerting.swift
//  BachelorProject
//
//  Created by Павел Снижко on 04.03.2021.
//

import UIKit

protocol AlertProvider {
    func showAlert(from controller: UIViewController, with title: String, and message: String)
}


extension AlertProvider {
    func showAlert(from controller: UIViewController, with title: String, and message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alert.addAction(okAction)
        controller.present(alert, animated: true, completion: nil)
    }
}
