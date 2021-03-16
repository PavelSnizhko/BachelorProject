//
//  SettingsTableViewCell.swift
//  BachelorProject
//
//  Created by Павел Снижко on 16.03.2021.
//

import UIKit

class SettingsTableViewCell: UITableViewCell, NibLoadable {
    @IBOutlet private weak var optionLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        statusLabel.isHidden = true
    }

    
    func setLabel(_ title: String) {
        optionLabel.text = title
    }
    
    func configStatusLabelIfNeeded(_ title: String) {
        statusLabel.text = title
        statusLabel.isHidden = false
    }
    
    func changeAccessoryTypeVisibility(accessoryType: AccessoryType = .disclosureIndicator) {
        self.accessoryType = accessoryType
    }
    
}
