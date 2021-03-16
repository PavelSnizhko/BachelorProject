//
//  MenuItemTableViewCell.swift
//  BachelorProject
//
//  Created by Павел Снижко on 13.03.2021.
//

import UIKit

class MenuItemTableViewCell: UITableViewCell, NibLoadable {
    @IBOutlet private weak var titleLable: UILabel!
    @IBOutlet private weak var menuImage: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        titleLable.font = .preferredFont(forTextStyle: .headline)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 0, left: 0, bottom: 10, right: 0))

    }
    
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        titleLable.text = nil
        menuImage.image = nil
    }
    
    func setLable(_ text: String) {
        titleLable.text = text
    }
    
    func setImage(_ image: UIImage?) {
        menuImage.image = image
    }
}
