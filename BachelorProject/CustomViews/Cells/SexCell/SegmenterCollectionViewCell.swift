//
//  SegmenterCollectionViewCell.swift
//  BachelorProject
//
//  Created by Павел Снижко on 04.03.2021.
//

import UIKit

class SegmenterCollectionViewCell: UICollectionViewCell, NibLoadable {
    @IBOutlet private weak var segmentedControll: UISegmentedControl!
    var indexChanged: ItemClosure<Int>?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        addTarget()
        // Initialization code
    }
    
    private func addTarget() {
        segmentedControll.addTarget(self, action: #selector(changeIndex(sender:)), for: .valueChanged)
    }
    
    @objc private func changeIndex(sender: UISegmentedControl) {
        indexChanged?(sender.selectedSegmentIndex)
    }

}
