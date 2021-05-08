//
//  SwipingViewController.swift
//  BachelorProject
//
//  Created by Павел Снижко on 15.03.2021.
//

import UIKit

class SwipingViewController: UIViewController {
    private var viewControllers = [MainPageViewController(nibName: MainPageViewController.name,
                                                          bundle: .main),
                                   ChatViewController(nibName: ChatViewController.name,
                                                      bundle: .main)]
    
    //super violation of SOLID when will be created Coordinator it will be solved....
    //just create for that closure and stram up logout action on the coordinator level
    private var sessionStorage = SessionStorage()    
    var finishFlow: VoidClosure?
    
    
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        return collectionView
    }()

    weak var menuDelegate: MenuControllerDelegate?

    var menuPressed: VoidClosure?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configNavigationBar()
        addCollectionView()
        setDelegeting()
        configureCollectionView()
        
    }
    
    
    func configNavigationBar() {
        
//        if let navigationController = navigationController {

            navigationItem.title = "Home"
        
            let image = UIImage(named: "list-text")
        
            navigationItem.leftBarButtonItem = UIBarButtonItem(image: image,
                                                               style:.plain,
                                                               target: self,
                                                               action: #selector(tappedMenu))

            navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Log out", style: .plain, target: self, action: #selector(logOuttapped))
//        }
    }
    
    
    @objc func logOuttapped() {
        finishFlow?()
        print("Log out")
        
    }
    
    
    @objc func tappedMenu() {
        print("tappedMenu")
        menuPressed?()
    }
    
    
    private func configureCollectionView() {
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "UICollectionViewCell")
        collectionView.isPagingEnabled = true
    }
    
    private func setDelegeting() {
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    private func addCollectionView() {
        view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                                     collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                                     collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
                                     collectionView.topAnchor.constraint(equalTo: view.topAnchor)])
    }
    
}




// MARK: - UICollectionViewDelegateFlowLayout

extension SwipingViewController:  UICollectionViewDelegateFlowLayout {
   func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    CGSize(width: view.frame.width ,
           height: view.frame.height - (view.safeAreaInsets.top + view.safeAreaInsets.bottom))
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        0
    }
}



// MARK: - UICollectionViewDataSource

extension SwipingViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewControllers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        collectionView.dequeueReusableCell(withReuseIdentifier: "UICollectionViewCell", for: indexPath)
    }
    
    
    

}

// MARK: - UICollectionViewDelegate

extension SwipingViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
            
            let cellViewController = viewControllers[indexPath.row]
            addChild(cellViewController)
            cellViewController.view.frame = cell.bounds
            cell.addSubview(cellViewController.view)
            cellViewController.didMove(toParent: self)
            cell.setNeedsLayout()
            cell.layoutIfNeeded()
            
        }
    
    
}


