//
//  RegisterViewController.swift
//  BachelorProject
//
//  Created by Павел Снижко on 03.03.2021.
//

import UIKit

final class RegisterViewController: UIViewController, NibLoadable {
    @IBOutlet weak var collectionView: UICollectionView!
    private var modelsType: [ModelsType] = [.userInfo, .sex, .status]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Registration" 
        registerCells()
        launchDelegating()
        // Do any additional setup after loading the view.
    }
    
    private func registerCells() {
        collectionView.register(UserInfoCollectionViewCell.nib, forCellWithReuseIdentifier: UserInfoCollectionViewCell.name)
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
    }
    
    private func launchDelegating() {
        //TODO: move to separete classes for SRP principe
        collectionView.dataSource = self
        collectionView.delegate = self
    }

}


extension RegisterViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return modelsType.count
    }
        
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: UICollectionViewCell!
        
        switch modelsType[indexPath.row] {
        case .userInfo:
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: UserInfoCollectionViewCell.name, for: indexPath) as! UserInfoCollectionViewCell
        case .sex:
            ///TODO: create cell for other types
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
        case .status:
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
        }
        
        return cell
    }
}

extension RegisterViewController: UICollectionViewDelegate {
    
}



private extension RegisterViewController {
    //TODO when I got a model type the add associated value for each item if need it
    enum ModelsType {
        case userInfo
        case sex
        case status // student or not for the first time probably it's not needed
    }
    
}

//MARK: Layout
extension RegisterViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        let width = collectionView.bounds.width
        let height = collectionView.bounds.height * 0.15

        return CGSize(width: width, height: height)
    }
}
