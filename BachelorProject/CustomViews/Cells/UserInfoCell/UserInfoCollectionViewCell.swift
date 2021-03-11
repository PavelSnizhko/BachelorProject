//
//  UserInfoCollectionViewCell.swift
//  BachelorProject
//
//  Created by Павел Снижко on 03.03.2021.
//

import UIKit

class UserInfoCollectionViewCell: UICollectionViewCell, NibLoadable {
    @IBOutlet private weak var photoView: PhotoView!
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var surnameField: UITextField!
    
    var nameIsChanged: ItemClosure<String>?
    var surnameIsChanged: ItemClosure<String>?

    var photoViewTapped: VoidClosure? {
        didSet {
            photoView.tapped = photoViewTapped
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        addTargets()
        // Initialization code
    }
    
    
    func setAvatarImage(image: UIImage?) {
        self.photoView.addAvatarImage(image: image)
    }
    
    private func addTargets() {
        nameField.addTarget(self, action: #selector(changedNameField(sender:)), for: .editingChanged)
        surnameField.addTarget(self, action: #selector(changedSurnameField(sender:)), for: .editingChanged)
    }
    
    @objc private func changedNameField(sender: UITextField) {
        nameIsChanged?(sender.text ?? "")
    }
    
    @objc private func changedSurnameField(sender: UITextField) {
        surnameIsChanged?(sender.text ?? "")
    }
}
