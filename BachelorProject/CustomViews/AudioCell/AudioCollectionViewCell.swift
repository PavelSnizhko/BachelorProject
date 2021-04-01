//
//  AudioCollectionViewCell.swift
//  BachelorProject
//
//  Created by Павел Снижко on 31.03.2021.
//

import UIKit

class AudioCollectionViewCell: UICollectionViewCell, NibLoadable {
    
    @IBOutlet private weak var buttonImageView: UIImageView!
    @IBOutlet private weak var containerView: UIView!
    var isChosen: Bool = false
    var isAudioPlaying: Bool = false
    var buttonTapped: VoidClosure?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setButtonImageTapGesture()
    }
    
    
    func setButtonImageTapGesture() {
        
        let tapGesture = UITapGestureRecognizer(target: self,
                                                action: #selector(didTappedImageView(_:)))
        tapGesture.delegate = self
        buttonImageView.isUserInteractionEnabled = true
        buttonImageView.addGestureRecognizer(tapGesture)
    }
    
    
    @objc func didTappedImageView(_ sender: UIGestureRecognizer) {
        
        buttonTapped?()
        
        isAudioPlaying.toggle()
        
        if isAudioPlaying {
            changeImage(image: UIImage(named: "stop-button"))
        }
        else {
            changeImage(image: UIImage(named: "play"))
        }
        
    }
    
    func setBackgoundActiveColor() {
        isChosen.toggle()
        if isChosen {
            containerView.layer.borderWidth = 2
            containerView.layer.borderColor = UIColor.black.cgColor
            containerView.backgroundColor = UIColor.systemGreen
        } else {
            containerView.layer.borderWidth = 1
            containerView.layer.borderColor = UIColor.lightGray.cgColor
            containerView.backgroundColor = .clear
        }
        
    }
    
    private func changeImage(image: UIImage?) {
        guard let image = image else {
            return
        }
        self.buttonImageView.image = image
    }
    
    

}

extension AudioCollectionViewCell: UIGestureRecognizerDelegate {
    
}
