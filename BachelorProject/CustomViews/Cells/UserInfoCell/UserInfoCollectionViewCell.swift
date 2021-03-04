//
//  UserInfoCollectionViewCell.swift
//  BachelorProject
//
//  Created by Павел Снижко on 03.03.2021.
//

import UIKit

class UserInfoCollectionViewCell: UICollectionViewCell, NibLoadable {
    @IBOutlet private weak var photoView: PhotoView!
    var photoViewTapped: VoidClosure?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        photoView.tapped = photoViewTapped
    }
    
    func setAvatarImage(image: UIImage?) {
        photoView.setAvatarImage(image)
    }

}
