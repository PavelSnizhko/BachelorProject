//
//  LinkingLabelsCollectionViewCell.swift
//  BachelorProject
//
//  Created by Павел Снижко on 12.03.2021.
//

import UIKit

class LinkingLabelsCollectionViewCell: UICollectionViewCell, NibLoadable {
    @IBOutlet private  weak var aboveLabel: UILabel!
    @IBOutlet private weak var belowLabel: UILabel!
    @IBOutlet private weak var button: UIButton!
    var buttonTapped: VoidClosure?
    
    var bellowLabelTapped: VoidClosure?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.aboveLabel.text = nil
        self.belowLabel.text = nil
    }
    
    func setAboveLabelTitle(title: String) {
        self.aboveLabel.text = title
    }

    func setBelowLabel(title: String) {
        self.belowLabel.text = title
        setBelowGestureRecognizer()
        
    }
    
    func setBelowGestureRecognizer() {
        belowLabel.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(bellowLabelTapped(_:)))
        belowLabel.addGestureRecognizer(tap)
    }
    
    @objc func bellowLabelTapped(_ sender: UITapGestureRecognizer) {
        self.belowLabel.textColor = UIColor(named: "redColor")
        bellowLabelTapped?()
    }

    func setButtonLabel(title: String) {
        self.button.setTitle(title, for: .normal)
    }
    
    //Probably it should gone
    @IBAction func tapppedButton(_ sender: Any) {
        buttonTapped?()
    }
}
