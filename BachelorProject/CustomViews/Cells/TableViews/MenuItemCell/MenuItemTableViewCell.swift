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
        // Initialization code
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
