//
//  AuthDataCollectionViewCell.swift
//  BachelorProject
//
//  Created by Павел Снижко on 11.03.2021.
//

import UIKit

class AuthDataCollectionViewCell: UICollectionViewCell, NibLoadable {

    @IBOutlet private weak var emailTextField: UITextField!
    @IBOutlet private weak var passwordTextField: UITextField!
    
    var emailText: ItemClosure<String>?
    var passwordText: ItemClosure<String>?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        addTargets()
        self.passwordTextField.isSecureTextEntry = true
        // Initialization code
    }

    private func addTargets() {
        emailTextField.addTarget(self, action: #selector(changedPhoneText(sender:)), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(changePasswordText(sender:)), for: .editingChanged)
    }
    
    @objc private func changedPhoneText(sender: UITextField) {
        emailText?(sender.text ?? "")
    }
    
    @objc private func changePasswordText(sender: UITextField) {
        passwordText?(sender.text ?? "")
    }
    
}
