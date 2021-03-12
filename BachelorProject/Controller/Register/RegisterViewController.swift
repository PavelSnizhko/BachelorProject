//
//  RegisterViewController.swift
//  BachelorProject
//
//  Created by Павел Снижко on 03.03.2021.
//

import UIKit

final class RegisterViewController: UIViewController, NibLoadable, AlertProvider {
    @IBOutlet weak var collectionView: UICollectionView!

    private var headersType: [HeaderType] = [.userInfo, .sex, .date, .auth, .button ]
    private var segmentTypes: [Sex] = [.male, .female]
    private var registerModel = RegisterModel()
    //INFO: this gonna be replaced due to apple's recomendation
    private let picker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.datePickerMode = .date
        picker.minimumDate = Calendar.current.date(byAdding: .year, value: -100, to: Date())
        picker.maximumDate = Date()
        if #available(iOS 14, *) {
            picker.preferredDatePickerStyle = .wheels
            picker.sizeToFit()
        }
        return picker
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Registration"
        registerCells()
        launchDelegating()
        configDatePicker()
        collectionView.alwaysBounceVertical = true
        collectionView.keyboardDismissMode = .onDrag
        // Do any additional setup after loading the view.
    }
    
    
    
    private func registerCells() {
        collectionView.register(UserInfoCollectionViewCell.nib, forCellWithReuseIdentifier: UserInfoCollectionViewCell.name)
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
        collectionView.register(SegmenterCollectionViewCell.nib, forCellWithReuseIdentifier: SegmenterCollectionViewCell.name)
        collectionView.register(AuthDataCollectionViewCell.nib, forCellWithReuseIdentifier: AuthDataCollectionViewCell.name)
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
        // for triggering taping on view
        print("phototViewTapped")
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.sourceType = .photoLibrary
        present(imagePickerController, animated: true, completion: nil)
    }
}

extension RegisterViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        picker.dismiss(animated: true, completion: nil)
        
        guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {
            return
        }
        
        registerModel.image = image
        
        collectionView.reloadData()
    }
}



// MARK: Cell's Header init
extension RegisterViewController {
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let headerView: UICollectionReusableView!
        switch headersType[indexPath.section] {
        case .userInfo, .button, .date, .auth:
            headerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader,
                                                                         withReuseIdentifier: "EmptyHeader",
                                                                         for: indexPath)
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
            // todo move to another func logi creating this cell
            guard let userInfoCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: UserInfoCollectionViewCell.name, for: indexPath) as? UserInfoCollectionViewCell else { fatalError() }
            
            userInfoCollectionViewCell.nameIsChanged  = { [weak self]  text in
                self?.registerModel.firstName = text
            }
               
            userInfoCollectionViewCell.surnameIsChanged  = { [weak self]  text in
                self?.registerModel.secondName = text
            }
           

            userInfoCollectionViewCell.photoViewTapped = phototViewTapped
            userInfoCollectionViewCell.setAvatarImage(image: registerModel.image)
            
            cell = userInfoCollectionViewCell

        case .sex:
            guard let segmenterCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: SegmenterCollectionViewCell.name, for: indexPath) as? SegmenterCollectionViewCell else { fatalError() }
            
            segmenterCollectionViewCell.setTitles(with: segmentTypes.map{ $0.rawValue.capitalized })
            
            segmenterCollectionViewCell.indexChanged = { [weak self] index in
                self?.registerModel.sex = index == 0 ? .male : .female
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
//                guard self.registerModel.isFilled else { self.showAlert(from: self, with: "Dangerous", and: "Please, fill all forms"); return }
//                self.showAlert(from: self, with: "\(self.registerModel.firstName)", and: "\(self.registerModel.secondName) \(self.registerModel.sex.rawValue) \n \(self.registerModel.birthday)")
                let loginVC = LoginViewController(nibName: LoginViewController.name, bundle: .main)
                self.navigationController?.pushViewController(loginVC, animated: true)
                

            }
            cell = buttonCollectionViewCell
            
        case .auth:
            guard let customCell = collectionView.dequeueReusableCell(withReuseIdentifier: AuthDataCollectionViewCell.name, for: indexPath) as? AuthDataCollectionViewCell  else { fatalError() }
            
            customCell.emailText = { [weak self] text in
                self?.registerModel.email = text
            }
            
            customCell.passwordText = { [weak self] text in
                self?.registerModel.password = text
            }
            
            cell = customCell
        }
        return cell
    }
}

extension RegisterViewController: UICollectionViewDelegate {
    
}



// MARK: HeaderType && ModelsType
private extension RegisterViewController {
    
    enum HeaderType: HeaderProtocol {
        typealias CellType = ModelsType
        case userInfo
        case sex
        case date
        case auth
        case button
        
        var cellModel: [RegisterViewController.ModelsType] {
            switch self {
            case .userInfo: return [.userInfo]
            case .sex: return [.sex]
            case .date: return [.date]
            case .button: return [.button]
            case .auth: return [.auth]
            }
        }
    }

    //TODO when I got a model type the add associated value for each item if need it
    enum ModelsType {
        case userInfo
        case sex
        case date
        case button// student or not for the first time probably it's not needed
        case auth
    }
    
}

//MARK: Layout
extension RegisterViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let screenWidth = collectionView.bounds.width
        let screenHeight = collectionView.bounds.height

        switch headersType[section] {
        case .userInfo, .button, .date, .auth:
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
        case .auth:
            let height = collectionView.bounds.height * 0.1
            return CGSize(width: width, height: height)
        }
    }
}


