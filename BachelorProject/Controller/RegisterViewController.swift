//
//  RegisterViewController.swift
//  BachelorProject
//
//  Created by Павел Снижко on 03.03.2021.
//

import UIKit

final class RegisterViewController: UIViewController, NibLoadable {
    @IBOutlet weak var collectionView: UICollectionView!
    private var headersType: [HeaderType] = [.userInfo, .sex, .date]
    private let picker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.datePickerMode = .date
        picker.minimumDate = Calendar.current.date(byAdding: .year, value: -100, to: Date())
        picker.maximumDate = Date()
        return picker
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Registration"
        registerCells()
        launchDelegating()
        configDatePicker()
        collectionView.keyboardDismissMode = .interactive
        // Do any additional setup after loading the view.
    }
    
    private func registerCells() {
        collectionView.register(UserInfoCollectionViewCell.nib, forCellWithReuseIdentifier: UserInfoCollectionViewCell.name)
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
        collectionView.register(SegmenterCollectionViewCell.nib, forCellWithReuseIdentifier: SegmenterCollectionViewCell.name)
        collectionView.register(DatePickerCollectionViewCell.nib, forCellWithReuseIdentifier: DatePickerCollectionViewCell.name)
        collectionView.register(HeaderCollectionReusableView.nib, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HeaderCollectionReusableView.name)
        collectionView.register(UICollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "EmptyHeader")
    }
    
    private func launchDelegating() {
        //TODO: move to separete classes for SRP principe
        collectionView.dataSource = self
        collectionView.delegate = self
        
    }

    
    private func configDatePicker() {
        picker.addTarget(self, action: #selector(pickNewDate(sender:)), for: .valueChanged)
    }
    
    @objc private func pickNewDate(sender: UIDatePicker) {
        let date = sender.date
        
    }
}

// MARK: Cell's Header init
extension RegisterViewController {

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let headerView: UICollectionReusableView!
        switch headersType[indexPath.section] {
        case .userInfo:
            headerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "EmptyHeader", for: indexPath)
        case .sex:
            guard let headerCollectionReusableView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HeaderCollectionReusableView.name, for: indexPath) as? HeaderCollectionReusableView else {
                return UICollectionReusableView()
            }
            headerCollectionReusableView.title = "Pick your sex"
            headerView = headerCollectionReusableView
            
        case .date:
            guard let headerCollectionReusableView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HeaderCollectionReusableView.name, for: indexPath) as? HeaderCollectionReusableView else {
                return UICollectionReusableView()
            }
            headerCollectionReusableView.title = "Pick your birth day"
            headerView = headerCollectionReusableView
        }
        return headerView
    }
}





// MARK: Collection View DataSource
extension RegisterViewController: UICollectionViewDataSource {
     func numberOfSections(in collectionView: UICollectionView) -> Int {
        return headersType.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return headersType[section].cellModel.count
    }
        
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: UICollectionViewCell!
        
        switch headersType[indexPath.section].cellModel[indexPath.item]{
        case .userInfo:
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: UserInfoCollectionViewCell.name, for: indexPath) as! UserInfoCollectionViewCell
        case .sex:
            if let segmenterCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: SegmenterCollectionViewCell.name, for: indexPath) as? SegmenterCollectionViewCell {
                segmenterCollectionViewCell.indexChanged = { index in
                    print(index)
                }
                cell = segmenterCollectionViewCell
            } else {
                fatalError()
            }
            ///TODO: create cell for other types
        case .date:
            guard let datePickerCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: DatePickerCollectionViewCell.name, for: indexPath) as? DatePickerCollectionViewCell else { fatalError() }
            datePickerCollectionViewCell.textField.inputView = picker
            cell = datePickerCollectionViewCell
        }
        
        return cell
    }
}

extension RegisterViewController: UICollectionViewDelegate {
    
}



private extension RegisterViewController {
    
    enum HeaderType: HeaderProtocol {
        typealias CellType = ModelsType
        case userInfo
        case sex
        case date
        
        var cellModel: [RegisterViewController.ModelsType] {
            switch self {
            case .userInfo: return [.userInfo]
            case .sex: return [.sex]
            case .date: return [.date]
            }
        }
    }

    //TODO when I got a model type the add associated value for each item if need it
    enum ModelsType {
        case userInfo
        case sex
        case date // student or not for the first time probably it's not needed
    }
    
}

//MARK: Layout
extension RegisterViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        switch headersType[indexPath.section].cellModel[indexPath.item]{
        case .userInfo:
            let width = collectionView.bounds.width
            let height = collectionView.bounds.height * 0.15
            return CGSize(width: width, height: height)
        case .sex:
            let width = collectionView.bounds.width
            let height = collectionView.bounds.height * 0.06
            return CGSize(width: width, height: height)
        case .date:
            let width = collectionView.bounds.width
            let height = collectionView.bounds.height * 0.04
            return CGSize(width: width, height: height)
        }
    }
}


