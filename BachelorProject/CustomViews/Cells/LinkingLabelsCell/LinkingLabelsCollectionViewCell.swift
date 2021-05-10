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

    var aboveLabelTapped: VoidClosure?
    
    var bellowLabelTapped: VoidClosure?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    func setAboveLabelTitle(title: String) {
        self.aboveLabel.text = title
        setAboveGestureRecognizer()
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
    
    func setAboveGestureRecognizer() {
        aboveLabel.isUserInteractionEnabled = true    
        let tap = UITapGestureRecognizer(target: self, action: #selector(aboveLabelTapped(_:)))
        aboveLabel.addGestureRecognizer(tap)
    }
    
    @objc func bellowLabelTapped(_ sender: UITapGestureRecognizer) {
        self.belowLabel.textColor = UIColor(named: "redColor")
        bellowLabelTapped?()
    }
    
    @objc func aboveLabelTapped(_ sender: UITapGestureRecognizer) {
        self.aboveLabel.textColor = UIColor(named: "redColor")
        aboveLabelTapped?()
    }
    
    
}
