//
//  Alerting.swift
//  BachelorProject
//
//  Created by Павел Снижко on 04.04.2021.
//

import UIKit

protocol Alerting {
    func showAlert(from viewController: UIViewController, title: String, message: String)
}

extension Alerting {

    func showAlert(from viewController: UIViewController, title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { [weak viewController] (_) in
            viewController?.dismiss(animated: false, completion: nil)
//            viewController?.navigationController?.popToRootViewController(animated: true)
        }))
        viewController.present(alert, animated: true, completion: nil)
    }
}
