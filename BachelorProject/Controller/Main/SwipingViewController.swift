//
//  SwipingViewController.swift
//  BachelorProject
//
//  Created by Павел Снижко on 15.03.2021.
//

import UIKit

class SwipingViewController: UIViewController {

    private var viewControllers = [MainPageViewController(nibName: MainPageViewController.name, bundle: .main), MainPageViewController(nibName: MainPageViewController.name, bundle: .main)]
    private var collectionView: UICollectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout())

    weak var menuDelegate: MenuControllerDelegate?


    
    override func viewDidLoad() {
        super.viewDidLoad()
        addCollectionView()
        collectionView.dataSource = self
        collectionView.delegate = self
        self.automaticallyAdjustsScrollViewInsets = false
        configureCollectionView()
        configNavigationBar()

        // Do any additional setup after loading the view.
    }
    
    
    func configNavigationBar() {
        if let navigationController = navigationController {

            //TODO: find out how to put image on a bar item and not erease title
            navigationItem.title = "Home"
            navigationItem.leftBarButtonItem =  UIBarButtonItem(title: "menu", style: .plain, target: self, action: #selector(tappedMenu))
            navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Log out", style: .plain, target: self, action: #selector(logOuttapped))
        }
    }
    
    
    @objc func logOuttapped() {
        print("Log out")
    }
    
    
    @objc func tappedMenu() {
        print("tappedMenu")
        menuDelegate?.handleMenuTapped()
    }
    
    
    func configureCollectionView() {
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "UICollectionViewCell")
        collectionView.isPagingEnabled = true
    }
    
    func setDelegeting() {
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    func addCollectionView() {
        view.addSubview(collectionView)
        NSLayoutConstraint.activate([collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                                     collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                                     collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
                                     collectionView.topAnchor.constraint(equalTo: view.topAnchor)])
    }
    
}




// MARK: - UICollectionViewDelegateFlowLayout

extension SwipingViewController:  UICollectionViewDelegateFlowLayout {
   func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: view.frame.height)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
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


