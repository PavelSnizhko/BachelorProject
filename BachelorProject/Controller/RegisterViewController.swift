//
//  RegisterViewController.swift
//  BachelorProject
//
//  Created by Павел Снижко on 03.03.2021.
//

import UIKit

final class RegisterViewController: UIViewController, NibLoadable, Alerting {
    @IBOutlet weak var collectionView: UICollectionView!

    private var headersType: [HeaderType] = [.userInfo, .sex, .date, .button]
    private var registerModel = RegisterModel()
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
        collectionView.register(DatePickerCollectionViewCell.nib,
                                forCellWithReuseIdentifier: DatePickerCollectionViewCell.name)
        collectionView.register(ButtonCollectionViewCell.nib, forCellWithReuseIdentifier: ButtonCollectionViewCell.name)
        // TODO: think is it ok to register another header view
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
        registerModel.birthday = date
        
    }
    
    private func phototViewTapped() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
    }
}

extension RegisterViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[UIImagePickerController.InfoKey.originalImage] else {
            return
        }
        
    }
}



// MARK: Cell's Header init
extension RegisterViewController {
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let headerView: UICollectionReusableView!
        switch headersType[indexPath.section] {
        case .userInfo, .button, .date:
            headerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "EmptyHeader", for: indexPath)
        case .sex:
            guard let headerCollectionReusableView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HeaderCollectionReusableView.name, for: indexPath) as? HeaderCollectionReusableView else {
                return UICollectionReusableView()
            }
            headerCollectionReusableView.title = "Please, choose your sex"
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
            guard let userInfoCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: UserInfoCollectionViewCell.name, for: indexPath) as? UserInfoCollectionViewCell else { fatalError() }
            userInfoCollectionViewCell.photoViewTapped = phototViewTapped
            cell = userInfoCollectionViewCell
        case .sex:
            guard let segmenterCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: SegmenterCollectionViewCell.name, for: indexPath) as? SegmenterCollectionViewCell else { fatalError() }
            segmenterCollectionViewCell.indexChanged = { index in
                print(index)
            }
            cell = segmenterCollectionViewCell
        case .date:
            guard let datePickerCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: DatePickerCollectionViewCell.name, for: indexPath) as? DatePickerCollectionViewCell else { fatalError() }
            datePickerCollectionViewCell.textField.inputView = picker
            cell = datePickerCollectionViewCell
        case .button:
            guard let buttonCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: ButtonCollectionViewCell.name, for: indexPath) as? ButtonCollectionViewCell else { fatalError() }
            buttonCollectionViewCell.buttonTitle = "Create account"
            buttonCollectionViewCell.buttonTapped = { [ weak self] in
                guard let self = self else { return }
                guard self.registerModel.isFilled else { self.showAlert(from: self, with: "Dangerous", and: "Please, fill all forms"); return }
                // TODO: handle when will be full filled model
            }
            cell = buttonCollectionViewCell
            
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
        case button
        
        var cellModel: [RegisterViewController.ModelsType] {
            switch self {
            case .userInfo: return [.userInfo]
            case .sex: return [.sex]
            case .date: return [.date]
            case .button: return [.button]
            }
        }
    }

    //TODO when I got a model type the add associated value for each item if need it
    enum ModelsType {
        case userInfo
        case sex
        case date
        case button// student or not for the first time probably it's not needed
    }
    
}

//MARK: Layout
extension RegisterViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let screenWidth = collectionView.bounds.width
        let screenHeight = collectionView.bounds.height

        switch headersType[section] {
        case .userInfo, .button, .date:
            return CGSize(width: 0, height: screenHeight * 0.02)
        case .sex:
            return CGSize(width: screenWidth * 0.9, height: screenHeight * 0.08)
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.bounds.width * 0.9
        switch headersType[indexPath.section].cellModel[indexPath.item]{
        case .userInfo:
            let height = collectionView.bounds.height * 0.15
            return CGSize(width: width, height: height)
        case .sex:
            let height = collectionView.bounds.height * 0.06
            return CGSize(width: width, height: height)
        case .date:
            let height = collectionView.bounds.height * 0.04
            return CGSize(width: width, height: height)
        case .button:
            let height = collectionView.bounds.height * 0.06
            return CGSize(width: width, height: height)
        }
    }
}


