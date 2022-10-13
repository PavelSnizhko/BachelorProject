//
//  StateDescriptionConfiguration.swift
//  BachelorProject
//
//  Created by Павел Снижко on 08.10.2022.
//

import UIKit

struct Configuration: UIContentConfiguration {
    let text: String
    
    func makeContentView() -> UIView & UIContentView {
        DescriptionContentView(configuration: self)
    }
    
    func updated(for state: UIConfigurationState) -> Configuration {
        self
    }

}

class DescriptionContentView: UIView, UIContentView {
    var configuration: UIContentConfiguration {
        didSet {
            self.configure()
        }
    }
    
    private let label = UILabel()
    
    init(configuration: UIContentConfiguration) {
        self.configuration = configuration
        super.init(frame: .zero)
        label.numberOfLines = 0 
        self.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: leadingAnchor),
            label.trailingAnchor.constraint(equalTo: trailingAnchor),
            label.topAnchor.constraint(equalTo: topAnchor),
            label.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
        
        self.configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        guard let config = self.configuration as? Configuration else {
            return
        }
        
        self.label.text = config.text
    }
}
