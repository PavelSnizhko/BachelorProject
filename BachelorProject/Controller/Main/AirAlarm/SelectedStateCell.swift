//
//  SelectedStateCell.swift
//  BachelorProject
//
//  Created by Павел Снижко on 08.10.2022.
//

import UIKit

typealias TextClosure = ((String) -> Void)

class SelectedStateCell: UICollectionViewCell {
    
    var labelTextUpdate: TextClosure?
    
    private lazy var selectedStateView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 5
        view.layer.masksToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .green
        return view
    }()
    
    private let stateLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .blue
        
        selectedStateView.addSubview(stateLabel)
        stateLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stateLabel.leadingAnchor.constraint(equalTo: selectedStateView.leadingAnchor),
            stateLabel.trailingAnchor.constraint(equalTo: selectedStateView.trailingAnchor),
            stateLabel.topAnchor.constraint(equalTo: selectedStateView.topAnchor),
            stateLabel.bottomAnchor.constraint(equalTo: selectedStateView.bottomAnchor)
        ])
        
        stateLabel.textAlignment = .center
        
        contentView.addSubview(selectedStateView)
        NSLayoutConstraint.activate([
            selectedStateView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            selectedStateView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            selectedStateView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            selectedStateView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20)
        ])
        
        labelTextUpdate = { [weak self] text in
            self?.stateLabel.text = text
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
