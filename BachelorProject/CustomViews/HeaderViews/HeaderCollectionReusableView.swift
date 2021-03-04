//
//  HeaderCollectionReusableView.swift
//  BachelorProject
//
//  Created by Павел Снижко on 04.03.2021.
//

import UIKit

class HeaderCollectionReusableView: UICollectionReusableView, NibLoadable {

    @IBOutlet private weak var label: UILabel!
    
    var title: String? {
        didSet {
            label.text = title
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        label.font = .systemFont(ofSize: 20)
        // Initialization code
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        title = nil
    }
    
}
