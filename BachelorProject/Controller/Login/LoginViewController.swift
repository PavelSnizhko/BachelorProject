//
//  LoginViewController.swift
//  BachelorProject
//
//  Created by Павел Снижко on 03.03.2021.
//

import UIKit

class LoginViewController: UIViewController, NibLoadable {
    @IBOutlet private weak var collectionView: UICollectionView!
    
    private var headersType: [HeaderType] = [.logo, .auth, .button, .linkingLabels]

    
    override func viewDidLoad() {
        super.viewDidLoad()
        launchDelegating()
        registerCells()
        setCollectionViewScrolling(flag: false)
        
    }
    
    
    //TODO now it's not needed
    func hideOportunityMoveBack() {
        // when I change navigation then delete this func 
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
            
        case .button:
            guard let buttonCell = collectionView.dequeueReusableCell(withReuseIdentifier: ButtonCollectionViewCell.name, for: indexPath) as? ButtonCollectionViewCell else { fatalError() }
            buttonCell.buttonTitle = "Log in"
            // TODO: handle buttonTapped
//            buttonCell.buttonTapped = { }
            cell = buttonCell
        case .linkingLabels:
            guard let linkingLabelsCell = collectionView.dequeueReusableCell(withReuseIdentifier: LinkingLabelsCollectionViewCell.name, for: indexPath) as? LinkingLabelsCollectionViewCell else { fatalError() }
            
            linkingLabelsCell.setAboveLabelTitle(title: "Forgot password")
            linkingLabelsCell.setBelowLabel(title: "Don't have an account")

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
