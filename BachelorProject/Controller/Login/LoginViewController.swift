//
//  LoginViewController.swift
//  BachelorProject
//
//  Created by Павел Снижко on 03.03.2021.
//

import UIKit


class LoginViewController: UIViewController, NibLoadable, Alerting {  
      
    var onLogin: VoidClosure?
    var onRegister: VoidClosure?
   
    @IBOutlet private weak var collectionView: UICollectionView!
    
    private var headersType: [HeaderType] = [.logo, .auth, .button, .linkingLabels]
    private var authModel = AuthModel()
    private var validationService: ValidationService = DefaultValidationService()
    private var authService = AuthorizationService(authorizationService: NetworkService())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        launchDelegating()
        registerCells()
        setCollectionViewScrolling(flag: false)
        hideOportunityMoveBack()
        
    }
    
    
    private func hideOportunityMoveBack() {
        // TODO:  when I change navigation then delete this func
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
                self?.authModel.phoneNumber = text
            }
            
            authCell.passwordText = { [weak self] text in
                self?.authModel.password = text
            }
            
        case .button:
            
            guard let buttonCell = collectionView.dequeueReusableCell(withReuseIdentifier: ButtonCollectionViewCell.name, for: indexPath) as? ButtonCollectionViewCell else { fatalError() }
            buttonCell.buttonTitle = "Log in"
            // TODO: handle buttonTapped
            buttonCell.buttonTapped = { [weak self] in
                
                guard let self = self else { return }
                
                do {
                    try self.validationService.validate(for: self.authModel)
                    
                    self.authService.logIn(authModel: self.authModel) { [weak self] error in

                        if error != nil {
                            
                            guard let self = self else { return }
                            
                            self.showAlert(from: self,
                                           title: "Oops some troubles with data",
                                           message: error?.localizedDescription ?? "Smth wrong")
                            return
                        }
                        else {
                        
                            self?.onLogin?()


                        }
                    }
                    
                } catch let error {
                    print(error.localizedDescription)
                    self.showAlert(from: self, title: "Oops some mistakes", message: error.localizedDescription)
                    
                }                
                                
            }
            cell = buttonCell
        case .linkingLabels:
            guard let linkingLabelsCell = collectionView.dequeueReusableCell(withReuseIdentifier: LinkingLabelsCollectionViewCell.name, for: indexPath) as? LinkingLabelsCollectionViewCell else { fatalError() }
            
            linkingLabelsCell.setAboveLabelTitle(title: "Forgot password")
            linkingLabelsCell.setBelowLabel(title: "Don't have an account")
            
            // TODO: move this part to coordinator pattern
            linkingLabelsCell.bellowLabelTapped = { [weak self] in
                
                let registerViewController = RegisterViewController(nibName: RegisterViewController.name,
                                                                    bundle: .main)
                
                self?.navigationController?.pushViewController(registerViewController, animated: true)
            }

            linkingLabelsCell.setButtonLabel(title: "Register")
            linkingLabelsCell.buttonTapped = { [weak self] in
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

    //TODO when I got a model type the add associated value for each item if need it
    enum ModelsType {
        case logo
        case auth
        case button
        case linkingLabels// student or not for the first time probably it's not needed
    }
    
}

//MARK: Layout
extension LoginViewController: UICollectionViewDelegateFlowLayout {
    
    //TODO: Clear that
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let screenWidth = collectionView.bounds.width
        let screenHeight = collectionView.bounds.height

        switch self.headersType[section] {
        case .logo, .auth, .button:
            return CGSize(width: 0, height: screenHeight * 0.02)
        case .linkingLabels:
            return CGSize(width: screenWidth * 0.9, height: screenHeight * 0.02)
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
