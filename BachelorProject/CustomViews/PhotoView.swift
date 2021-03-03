//
//  PhotoView.swift
//  BachelorProject
//
//  Created by Павел Снижко on 03.03.2021.
//

import UIKit

@IBDesignable
final class PhotoView: UIView {
    private let imageView: UIImageView = UIImageView()
    private let label: UILabel = UILabel()
    private let stackView = UIStackView()
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        addStackView()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        Decorator.changeViewsLayerShape(self)
        Decorator.decorate(self)
    }
}

// MARK: private extension
private extension PhotoView {
    func addStackView() {
        self.addSubview(stackView)
        setUpStackViewConstraints()
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.alignment = .fill
        stackView.spacing = 0
        addImageView()
        addLabel()
    
    }
    
    func setUpStackViewConstraints() {
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([stackView.topAnchor.constraint(equalTo: self.topAnchor, constant:  self.bounds.height / 4),
                                     stackView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: self.bounds.width / 4),
                                     stackView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
                                     stackView.trailingAnchor.constraint(equalTo: self.trailingAnchor)])
        
    }
    
    func addImageView() {
        imageView.image = UIImage(named: "camera")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        stackView.addArrangedSubview(imageView)
    }
    
    func addLabel() {
        label.text = "Photo"
        label.textAlignment = .center
        stackView.addArrangedSubview(label)
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



