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
    
    func setTitles(with titles: [String]) {
        segmentedControll.removeAllSegments()
        titles.enumerated().forEach{
            segmentedControll.insertSegment(withTitle: $1, at: $0, animated: true)
        }
    }
    
    private func addTarget() {
        segmentedControll.addTarget(self, action: #selector(changeIndex(sender:)), for: .valueChanged)
    }
    
    @objc private func changeIndex(sender: UISegmentedControl) {
        indexChanged?(sender.selectedSegmentIndex)
    }

}
