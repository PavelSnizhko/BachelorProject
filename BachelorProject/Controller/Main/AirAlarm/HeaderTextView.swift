//
//  HeaderTextView.swift
//  BachelorProject
//
//  Created by Павел Снижко on 09.10.2022.
//

import UIKit

extension UICollectionReusableView {
    static var reuseIdentifier: String {
        return String(describing: Self.self)
    }
}

class HeaderTextView: UICollectionReusableView {
    private var label: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.font = UIFont.preferredFont(forTextStyle: .footnote)
        return label
    }()
    
    func set(text: String) {
        label.text = text
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .systemRed
        
        addSubview(label)
        

        NSLayoutConstraint.activate([
            label.centerYAnchor.constraint(equalTo: centerYAnchor),
            label.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
