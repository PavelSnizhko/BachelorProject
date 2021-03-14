//
//  MenuViewController.swift
//  BachelorProject
//
//  Created by Павел Снижко on 12.03.2021.
//

import UIKit

class MenuViewController: UIViewController, NibLoadable {
    @IBOutlet weak var tableView: UITableView!
        
    override func viewDidLoad() {
        super.viewDidLoad()
        launchDelegating()
        registerCells()
        // Do any additional setup after loading the view.
    }
    
    
    private func registerCells() {
        tableView.register(MenuItemTableViewCell.nib, forCellReuseIdentifier: MenuItemTableViewCell.name)
        
    }
    
    private func launchDelegating() {
        //TODO: move to separete classes for SRP principe
        tableView.dataSource = self
        tableView.delegate = self
        
    }
    
    
}

extension MenuViewController {
    
    enum MenuItem: String, CaseIterable {
        case home = "Home"
        case setting = "Setting"
        case chat = "Chat"
        
        var image: UIImage? {
            switch self {
            case .home:
                return UIImage(named: "home")
            case .setting:
                return UIImage(named: "setting")
            case .chat:
                return UIImage(named: "chat")
            }
        }
    }
    
}



extension MenuViewController: UITableViewDelegate {
    
}

extension MenuViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        MenuItem.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        tableView.dequeueReusableCell(withIdentifier: MenuItemTableViewCell.name, for: indexPath)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let cell = cell as? MenuItemTableViewCell else { return }
        
        let option = MenuItem.allCases[indexPath.row]
        cell.setLable(option.rawValue)
        cell.setImage(option.image)
        
    }
    
}