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
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        addImageView()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        Decorator.changeViewsLayerShape(self)
        Decorator.decorate(self)
    }
}

// MARK: private extension
private extension PhotoView {
    
    func addImageView() {
        imageView.image = UIImage(named: "camera")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        self.addSubview(imageView)
        setUpImageConstraints()
    }
    
    func addLabel() {
        label.text = "Photo"
        label.textAlignment = .center
    }
    
    func setUpImageConstraints() {
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



