//
//  ButtonCollectionViewCell.swift
//  BachelorProject
//
//  Created by Павел Снижко on 04.03.2021.
//

import UIKit

class ButtonCollectionViewCell: UICollectionViewCell, NibLoadable {
    
    @IBOutlet private weak var button: UIButton!
    var buttonTapped: VoidClosure?
    
    var buttonTitle: String? {
        didSet {
            button.setTitle(buttonTitle, for: .normal)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        buttonTitle = nil
    }
    
    func changeButtonEnabling(state: Bool) {
        self.button.isEnabled = state
        self.button.backgroundColor = state ? UIColor(named: "redColor") :  UIColor.gray
    }
    
    func setButtonCollor(color: UIColor? = UIColor(named: "redColor")) {
        self.button.backgroundColor = color
    }
    
    @IBAction func didTapButton(sender: UIButton) {
        buttonTapped?()
    }

}
