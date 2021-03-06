//
//  RecordingVoiceViewController.swift
//  BachelorProject
//
//  Created by Павел Снижко on 30.03.2021.
//

import UIKit

public enum PersonalPermissions: String {
    case sendToServer = "sendToServer"
    case storeLocal = "storeLocal"
    case allowTakePhoto = "allowTakePhoto"
}


class RecordingVoiceViewController: UIViewController, NibLoadable {
    
    @IBOutlet weak var tableView: UITableView!
    private let numberOfRows = 3
    var storeLocally: ItemClosure<Bool>?
    var sendToServer: ItemClosure<Bool>?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setDelegating()
        // Do any additional setup after loading the view.
    }
    
    func setDelegating() {
        tableView.dataSource = self
        tableView.delegate = self
    }
    
}


extension RecordingVoiceViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        numberOfRows
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        .init()
    }
    
}


extension RecordingVoiceViewController {
    @objc func switchChanged(_ sender: UISwitch)  {
        switch sender.tag {
        case 0:
            UserDefaults.standard.setValue(sender.isOn, forKey: PersonalPermissions.sendToServer.rawValue)
        case 1:
            UserDefaults.standard.setValue(sender.isOn, forKey: PersonalPermissions.storeLocal.rawValue)
        case 2:
            UserDefaults.standard.setValue(sender.isOn, forKey: PersonalPermissions.allowTakePhoto.rawValue)
        default:
            print("Unknow option")
        }
        
    }
}


extension RecordingVoiceViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            cell.textLabel?.text = "Sent to the secure"
        case 1:
            cell.textLabel?.text = "Store locally"
        case 2:
            cell.textLabel?.text = "Allow to take photo"
        default:
            print("Unknown")
        }
        
        let switchView = UISwitch(frame: .zero)
        switchView.backgroundColor = .white
        switchView.layer.cornerRadius = 16
        switchView.setOn(false, animated: true)
        switchView.tag = indexPath.row // for detect which row switch Changed
        switchView.addTarget(self, action: #selector(self.switchChanged(_:)), for: .valueChanged)
        
        cell.accessoryView = switchView
        cell.backgroundColor = UIColor(named: "greenSheen")
    }
}


