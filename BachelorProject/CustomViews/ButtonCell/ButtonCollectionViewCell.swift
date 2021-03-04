//
//  ButtonCollectionViewCell.swift
//  BachelorProject
//
//  Created by Павел Снижко on 04.03.2021.
//

import UIKit

class ButtonCollectionViewCell: UICollectionViewCell, NibLoadable {
    
    @IBOutlet weak var button: UIButton!
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
    
    @IBAction func didTapButton(sender: UIButton) {
        buttonTapped?()
    }

}
