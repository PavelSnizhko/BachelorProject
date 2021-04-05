//
//  FackeVoiceViewController.swift
//  BachelorProject
//
//  Created by Павел Снижко on 30.03.2021.
//

import UIKit
import AVFoundation

class FackeVoiceViewController: UIViewController, NibLoadable {
    
    // MARK: - Properties

    @IBOutlet weak var collectionView: UICollectionView!
    
    var audioPlayer: AVAudioPlayer?
    var audioManager =  AudioManager()
    
    private var voiceStorage = VoiceStorage()
    private var voiceSetting = VoiceSetting()
    private var languagePickerManager: LanguagePickerManager = LanguagePickerManager()
    private var timePickerManager: TimePickerManager = TimePickerManager()
    private weak var previousActiveCell: AudioCollectionViewCell?
    
    private lazy var timePicker: UIPickerView = {
        
        let pickerFrame: CGRect = CGRect(x: 35, y: 52, width: 200, height: 140)
        let picker = UIPickerView(frame: pickerFrame)
        
        picker.dataSource = self.timePickerManager
        picker.delegate = self.timePickerManager
        
        return picker
    }()
    
    
    private lazy var languagePicker: UIPickerView = {
        let pickerFrame: CGRect = CGRect(x: 35, y: 52, width: 200, height: 140)
        let picker = UIPickerView(frame: pickerFrame)
        
        picker.dataSource = self.languagePickerManager
        picker.delegate = self.languagePickerManager
       
        return picker
    }()
    
    private lazy var timeAlert: CustomAlertController<Int> = {
        let alert = CustomAlertController<Int>(title: "", message: nil, preferredStyle: UIAlertController.Style.alert)

        guard let view = alert.view else { fatalError() }
        
        let height = NSLayoutConstraint(item: view,
                                       attribute: NSLayoutConstraint.Attribute.height,
                                       relatedBy: NSLayoutConstraint.Relation.equal,
                                       toItem: nil,
                                       attribute: NSLayoutConstraint.Attribute.notAnAttribute,
                                       multiplier: 1,
                                       constant: self.view.frame.height * 0.3)
        
        alert.view.addConstraint(height)
        
        alert.view.addSubview(timePicker)
        

        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(cancelAction)

        let okAction = UIAlertAction(title: "Submit", style: .default, handler: { [weak self] _ in
            guard let time = self?.timePickerManager.selectedTime else { return }
            self?.voiceSetting.timeStamp = time
        })
        
        alert.addAction(okAction)
        
        return alert
    }()
    
    
    private lazy var languageAlert: UIAlertController = {
        let alert = UIAlertController(title: "", message: nil, preferredStyle: UIAlertController.Style.alert)

        guard let view = alert.view else { fatalError() }
        
        let height = NSLayoutConstraint(item: view,
                                       attribute: NSLayoutConstraint.Attribute.height,
                                       relatedBy: NSLayoutConstraint.Relation.equal,
                                       toItem: nil,
                                       attribute: NSLayoutConstraint.Attribute.notAnAttribute,
                                       multiplier: 1,
                                       constant: self.view.frame.height * 0.3)
        
        alert.view.addConstraint(height)
                
        alert.view.addSubview(languagePicker)
        

        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(cancelAction)

        let okAction = UIAlertAction(title: "Submit", style: .default, handler: { [weak self] _ in
            guard let language = self?.languagePickerManager.selectedLanguage else { return }
            self?.voiceSetting.localization = language
        })
        
        alert.addAction(okAction)
        
        return alert
    }()

    //TODO: move to datasource

    private var audioURIList = ["CallResponse", "url", "url", "url", "url", "url", "url"]
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        registerCell()
        launchDelegating()
    }
    
    
    // MARK: - Handlers

    
    private func launchDelegating() {
        //TODO: move to separete classes for SRP principe
        collectionView.dataSource = self
        collectionView.delegate = self
        
    }
    
    private func registerCell() {
        collectionView.register(AudioCollectionViewCell.nib, forCellWithReuseIdentifier: AudioCollectionViewCell.name)
    }
    
    private func handleAudionPlaying(for audioName: String?) {
        guard let title = audioName else { return }
        
        audioManager.playAudioAsset(title)
        
    }
    
    // MARK: - IBAction

    @IBAction func tappedChooseAction(_ sender: Any) {
        self.present(languageAlert, animated: true, completion: nil)
    }
    
    @IBAction func tappedChooseTimeline(_ sender: Any) {
        
        self.present(timeAlert, animated: true, completion: nil)
        
    }
    @IBAction func tappedSubmit(_ sender: Any) {
        
        voiceStorage.voice = voiceSetting

        navigationController?.popViewController(animated: true)
    }
}



extension FackeVoiceViewController {
    
    enum PickerType: String {
        case language
        case time
        
        var name: String {
            switch self {
            case .language:
                return "Choose language"
            case .time:
                return "Choose time"
            }
        }
    }
}



extension FackeVoiceViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        audioURIList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AudioCollectionViewCell.name, for: indexPath) as? AudioCollectionViewCell else {
            fatalError()
        }
        
        cell.buttonTapped = { [weak self] in
            self?.handleAudionPlaying(for: self?.audioURIList[indexPath.item])
        }

        return cell
    }
}

//TODO: fix when choose one cell in another cancel choosing background color

extension FackeVoiceViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? AudioCollectionViewCell else {
            return
            
        }
        
        if previousActiveCell != nil {
            previousActiveCell?.setBackgoundActiveColor()
        }
        
        previousActiveCell = cell
        
        voiceSetting.name = audioURIList[indexPath.item]
        
        cell.setBackgoundActiveColor()
    }
}



















