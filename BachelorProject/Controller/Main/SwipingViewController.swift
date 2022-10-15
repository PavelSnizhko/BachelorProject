//
//  SwipingViewController.swift
//  BachelorProject
//
//  Created by Павел Снижко on 15.03.2021.
//

import UIKit

class SwipingViewController: UIViewController, Alerting {
    
    let tabBarViewController = UITabBarController()
    
    private lazy var mainPageViewController: UINavigationController = {
        let viewController = MainPageViewController(nibName: MainPageViewController.name,
                                                    bundle: .main)
        let navViewController = UINavigationController(rootViewController: viewController)

        let image = UIImage(named: "sos")

        viewController.tabBarItem = UITabBarItem(title: "Main", image: image, tag: 0)
        
        return navViewController

    }()
    
    private lazy var airAlarmViewController: UINavigationController = {
        let viewController = AirAlarmViewController(collectionViewLayout: .init())
        let navViewController = UINavigationController(rootViewController: viewController)

        let image = UIImage(named: "alarm")

        viewController.tabBarItem = UITabBarItem(title: "Air Alarm", image: image, tag: 1)
        return navViewController
    }()
    
    private lazy var settingsViewController: UINavigationController = {
        let viewController = SettingsViewController(nibName: SettingsViewController.name, bundle: .main)
        let navViewController = UINavigationController(rootViewController: viewController)
        let image = UIImage(named: "settings")
        viewController.tabBarItem = UITabBarItem(title: "Settings", image: image, tag: 2)
        return navViewController
    }()
    
    private lazy var  chatViewController: ChatViewController = {
        let viewController = ChatViewController(nibName: ChatViewController.name,
                                                bundle: .main)
        
//        viewController.tabBarItem = UITabBarItem(title: "Chat", image: .checkmark, tag: 1)
        
        return viewController
    }()
    
    
    private lazy var viewControllers = [tabBarViewController, chatViewController]
    
    var finishFlow: VoidClosure?
    private let authService: LogOut
    
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

    
    init(authService: LogOut) {
        self.authService = authService
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("Usage is not allowed")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tabBarViewController.setViewControllers([mainPageViewController, airAlarmViewController, settingsViewController], animated: false)
        configNavigationBar()
        addCollectionView()
        setDelegeting()
        configureCollectionView()
        
    }
    
    
    func configNavigationBar() {
        
            navigationItem.title = "Home"
        
            let image = UIImage(named: "list-text")
        
            navigationItem.leftBarButtonItem = UIBarButtonItem(image: image,
                                                               style:.plain,
                                                               target: self,
                                                               action: #selector(tappedMenu))

            navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Log out",
                                                                style: .plain,
                                                                target: self,
                                                                action: #selector(logOuttapped))
    }
    
    
    @objc func logOuttapped() {
        authService.logOut { error in
            if let error = error {
                showAlert(from: self, title: "Sign out", message: error.localizedDescription)
            }
            
            finishFlow?()
        }
    }
    
    
    @objc func tappedMenu() {
        menuPressed?()
    }
    
    
    private func configureCollectionView() {
        
        collectionView.register(UICollectionViewCell.self,
                                forCellWithReuseIdentifier: "UICollectionViewCell")
        
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


