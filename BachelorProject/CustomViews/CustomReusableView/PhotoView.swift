//
//  PhotoView.swift
//  BachelorProject
//
//  Created by Павел Снижко on 03.03.2021.
//

import UIKit

final class PhotoView: UIView {
    private let imageView: UIImageView = UIImageView()
    private let label: UILabel = UILabel()
    private var avatarImageView: UIImageView = UIImageView()
    var tapped: VoidClosure?
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        addImageView()
        addAvatarImageView()
        clipsToBounds = true
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        Decorator.changeViewsLayerShape(self)
        Decorator.decorate(self)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        tapped?()
        print("fuck it works")
    }
}

// MARK: private extension
private extension PhotoView {
    func addAvatarImageView() {
        self.addSubview(avatarImageView)
        avatarImageView.isHidden = true
        avatarImageView.contentMode = .scaleAspectFill
        setUpAvatarImageViewConstraints()
    }
    
    
    func setUpAvatarImageViewConstraints() {
        avatarImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.avatarImageView.topAnchor.constraint(equalTo: self.topAnchor),
            self.avatarImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            self.avatarImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.avatarImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor)
        ])
    }
    
    func addImageView() {
        imageView.image = UIImage(named: "camera")
        imageView.contentMode = .scaleAspectFit
        self.addSubview(imageView)
        setUpImageConstraints()
    }
    
    func addLabel() {
        label.text = "Photo"
        label.textAlignment = .center
    }
    
    func setUpImageConstraints() {
        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.imageView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.4),
            self.imageView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.4),
            self.imageView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            self.imageView.centerXAnchor.constraint(equalTo: self.centerXAnchor)
        ])
    }
}

// MARK: Decorator extension
extension PhotoView {
    
    func addAvatarImage(image: UIImage?) {
        avatarImageView.image = image
        avatarImageView.isHidden = image == nil
    }
    
    
    //TODO: think is it ok??
    fileprivate final class Decorator {
        static func decorate(_ view: PhotoView) {
            view.layer.borderColor = UIColor.green.cgColor
            view.layer.borderWidth = 1
        }
        
        static func changeViewsLayerShape(_ view: PhotoView) {
            view.layer.cornerRadius = view.frame.height / 2
        }
    }
}



