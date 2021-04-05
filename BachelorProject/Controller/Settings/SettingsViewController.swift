//
//  SettingsViewController.swift
//  BachelorProject
//
//  Created by Павел Снижко on 16.03.2021.
//

import UIKit

class SettingsViewController: UIViewController, NibLoadable {
    
    var defaultSettings: [SettingType] = [.account, .voice, .audio, .password, .logout]
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = false
        configTableView()
    }
    
    private func configTableView() {
        tableView.register(SettingsTableViewCell.nib, forCellReuseIdentifier: SettingsTableViewCell.name)
        setDelegating()
    }
    
    
    fileprivate func setDelegating() {
        tableView.delegate = self
        tableView.dataSource = self
    }
    
}


extension SettingsViewController {

    
    enum SettingType: String {
        case account = "Gooogle account"
        case voice = "Facke voice"
        case audio = "Recording audio"
        case password = "Change password"
        case logout = "Log out"
    }
    
}

extension SettingsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let cell = cell as? SettingsTableViewCell else { return }
        let item = defaultSettings[indexPath.row]
        cell.setLabel(item.rawValue)
        switch item {
        case .account:
            cell.configStatusLabelIfNeeded("DISCONNECTED")
            cell.changeAccessoryTypeVisibility(accessoryType: .none)
        case .logout:
            cell.changeAccessoryTypeVisibility(accessoryType: .none)
        default:
            return
        }
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let setting = defaultSettings[indexPath.row]
        switch setting {
        case .account:
            print("Tapped account")
        case .voice:
            let fackeVoiceController = FackeVoiceViewController(nibName: FackeVoiceViewController.name, bundle: .main)
            navigationController?.pushViewController(fackeVoiceController, animated: true)
        case .audio:
            let fackeVoiceController = RecordingVoiceViewController(nibName: RecordingVoiceViewController.name, bundle: .main)
            fackeVoiceController.sendToServer =  { [weak self]  state in
                self?.handleSendToServerOption(state: state)
                self?.handleStoreLocally(state: state)
            }
            navigationController?.pushViewController(fackeVoiceController, animated: true)
        case .password:
            print("Provide as soon as possible")
        case .logout:
            navigationController?.popToRootViewController(animated: true)
        }
    }
}

extension SettingsViewController {
    func handleSendToServerOption(state: Bool) {
        // TODO: Implement as soon as appears back that can store audio!!!
        print("Config to store on the server side")

    }
    
    func handleStoreLocally(state: Bool) {
        print("Config to store locally option")
    }
}



extension SettingsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        defaultSettings.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        tableView.dequeueReusableCell(withIdentifier: SettingsTableViewCell.name, for: indexPath)
    }
    
}
