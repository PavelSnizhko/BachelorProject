//
//  LoginViewController.swift
//  BachelorProject
//
//  Created by Павел Снижко on 03.03.2021.
//

import UIKit
import FirebaseDatabase

class LoginViewController: UIViewController, NibLoadable, Alerting {  
    
    var onLogin: VoidClosure?
    var onRegister: VoidClosure?
   
    @IBOutlet private weak var collectionView: UICollectionView!
    
    private var headersType: [HeaderType] = [.logo, .auth, .button, .linkingLabels]
    private var credentials = Credentials()
    private var validationService: ValidationService = DefaultValidationService()
    private var authService: Authorization
        
    init(authService: Authorization, nibName: String?, bundle: Bundle?) {
        self.authService = authService
        super.init(nibName: nibName, bundle: bundle)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        launchDelegating()
        registerCells()
        setCollectionViewScrolling(flag: false)
        hideOportunityMoveBack()
      
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
    
    
    private func hideOportunityMoveBack() {
        //TODO: change it in the router
        self.navigationItem.leftBarButtonItem = nil
        self.navigationItem.hidesBackButton = true
        self.navigationController?.navigationItem.backBarButtonItem?.isEnabled = false
        self.navigationController!.interactivePopGestureRecognizer!.isEnabled = false
        
    }
    
    private func launchDelegating() {
        //TODO: move to separete classes for SRP principe
        collectionView.dataSource = self
        collectionView.delegate = self
        
    }
    
    private func setCollectionViewScrolling(flag: Bool ){
        collectionView?.isScrollEnabled = flag
    }
    
    private func registerCells() {
        collectionView.register(LogoCollectionViewCell.nib, forCellWithReuseIdentifier: LogoCollectionViewCell.name)
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
        collectionView.register(AuthDataCollectionViewCell.nib, forCellWithReuseIdentifier: AuthDataCollectionViewCell.name)
        collectionView.register(ButtonCollectionViewCell.nib, forCellWithReuseIdentifier: ButtonCollectionViewCell.name)
        collectionView.register(LinkingLabelsCollectionViewCell.nib, forCellWithReuseIdentifier: LinkingLabelsCollectionViewCell.name)
//        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
    }
}

// MARK: DataSource
extension LoginViewController: UICollectionViewDataSource {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return self.headersType.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        self.headersType[section].cellModel.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell: UICollectionViewCell!
        
        switch headersType[indexPath.section].cellModel[indexPath.item] {
         
        case .logo:
            
            guard let logoCell = collectionView.dequeueReusableCell(withReuseIdentifier: LogoCollectionViewCell.name, for: indexPath) as? LogoCollectionViewCell else { fatalError() }
            cell = logoCell
            
        case .auth:
            
            guard let authCell = collectionView.dequeueReusableCell(withReuseIdentifier: AuthDataCollectionViewCell.name, for: indexPath) as? AuthDataCollectionViewCell else { fatalError() }
            cell = authCell
            
            authCell.emailText = { [weak self] text in
                self?.credentials.email = text
            }
            
            authCell.passwordText = { [weak self] text in
                self?.credentials.password = text
            }
            
        case .button:
            guard let buttonCell = collectionView.dequeueReusableCell(withReuseIdentifier: ButtonCollectionViewCell.name, for: indexPath) as? ButtonCollectionViewCell
            else {
                fatalError()
            }
            
            buttonCell.buttonTitle = "Log in"
            buttonCell.buttonTapped = { [weak self] in
                
                guard let self = self else { return }
                
                do {
                    try self.validationService.validate(for: self.credentials)
                    
                    self.authService.logIn(with: self.credentials) { error in
                        if let error {
                            self.showAlert(from: self,
                                           title: "Oops some troubles with data",
                                           message: error.localizedDescription)
                            return
                        }
                        else {
                            self.onLogin?()
                        }
                    }
                    
                } catch let error {
                    
                    guard let validationError = error as? ValidationError else {
                        return
                    }
                    
                    switch validationError {
                    case let .badPassword(errorDescription):
                        self.showAlert(from: self, title: "Oops some mistakes", message: errorDescription)
                    case let .wrongEmailFormat(errorDescription):
                        self.showAlert(from: self, title: "Oops some mistakes", message: errorDescription)
                    case let .badName(errorDescription):
                        self.showAlert(from: self, title: "Oops some mistakes", message: errorDescription)
                    }
                }
            }
            
            cell = buttonCell
        case .linkingLabels:
            guard let linkingLabelsCell = collectionView.dequeueReusableCell(withReuseIdentifier: LinkingLabelsCollectionViewCell.name, for: indexPath) as? LinkingLabelsCollectionViewCell else { fatalError() }
            
            linkingLabelsCell.setBelowLabel(title: "Don't have an account")
            
            linkingLabelsCell.bellowLabelTapped = { [weak self] in
                self?.onRegister?()
            }

            cell = linkingLabelsCell
        }
        return cell
    }
    
    
}


// MARK: Delegate

extension LoginViewController: UICollectionViewDelegate {
    
}


// MARK: HeaderType && ModelsType
private extension LoginViewController {
    
    enum HeaderType: HeaderProtocol {
        typealias CellType = ModelsType
        case logo
        case auth
        case button
        case linkingLabels
        
        var cellModel: [LoginViewController.ModelsType] {
            switch self {
            case .logo: return [.logo]
            case .auth: return [.auth]
            case .button: return [.button]
            case .linkingLabels: return [.linkingLabels]
            }
        }
    }

    enum ModelsType {
        case logo
        case auth
        case button
        case linkingLabels
    }
    
}

//MARK: Layout
extension LoginViewController: UICollectionViewDelegateFlowLayout {
        
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let screenWidth = collectionView.bounds.width
        let screenHeight = collectionView.bounds.height

        switch self.headersType[section] {
        case .logo, .auth, .button:
            return CGSize(width: 0, height: screenHeight * 0.02)
        case .linkingLabels:
            return CGSize(width: screenWidth * 0.9, height: 0)
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.bounds.width * 0.9
        switch self.headersType[indexPath.section].cellModel[indexPath.item]{
        case .logo:
            let height = collectionView.bounds.height * 0.3
            return CGSize(width: width, height: height)
        case .auth:
            let height = collectionView.bounds.height * 0.15
            return CGSize(width: width, height: height)
        case .button:
            let height = collectionView.bounds.height * 0.06
            return CGSize(width: width, height: height)
        case .linkingLabels:
            let height = collectionView.bounds.height * 0.28
            return CGSize(width: width, height: height)
        }
    }
}
