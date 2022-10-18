//
//  MainPageViewController.swift
//  BachelorProject
//
//  Created by Павел Снижко on 12.03.2021.
//

import UIKit
import CoreLocation
import MapKit


// due to guard is reserverd word from swift will be use Preservation
struct Preservation {
    let id: String
    let name: String
    let lon: Double
    let lat: Double
}

class MainPageViewController: UIViewController, NibLoadable, Alerting {
    
    //MARK: - IBOutlet
    @IBOutlet weak var circleAnimationView: CircleAnimationView!

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var animationView: CircleAnimationView!
    
    @IBOutlet weak var circleButton: CustomButton!
    //MARK: - IBOutlet
    @IBOutlet weak var stopButton: CustomButton!
    
    private var voiceStorage = VoiceStorage()
    private var recordingManager: Recording = RecordingAudioManager(audioRecorder: nil, audioPlayer: nil)
    private var audioManager: AudioManager = AudioManager()
    private let locationManager = CLLocationManager()
    private var currentLocation: CLLocation?
    private var isPressedSOS: Bool = false
    private var locationService: LocationService = LocationService()
    
    private var photoManager: TakingPhotoManager = TakingPhotoManager()
    
    let regionMetters: Double = 1000
    
    weak var timer: Timer?
    
    private lazy var bluredView: BluredView = {
        let bluredView = BluredView.loadFromNib()
        
        return bluredView
        
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.requestAlwaysAuthorization()
        mapView.showsUserLocation = true
        configLocationManager()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    func configLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
    }
    
    func centerViewOnUserLocation() {
        if let location = locationManager.location?.coordinate {
            let region = MKCoordinateRegion.init(center: location,
                                                 latitudinalMeters: regionMetters,
                                                 longitudinalMeters: regionMetters)
            mapView.setRegion(region, animated: true)
        }
    }
    
    func showGuardLocation(location: Location) {
        let userLocationCoordinates = CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = userLocationCoordinates
 
        let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        let region = MKCoordinateRegion(center: userLocationCoordinates, span: span)
        mapView.setRegion(region, animated: true)
        mapView.addAnnotation(annotation)
    }
    
    private func setButtonTittle(_ string: String) {
        circleButton.setTitle(string, for: .normal)
    }
    
    @IBAction func pressedStop(_ sender: Any) {
        handleStopButton()
        stopButton.isHidden = true
        circleButton.isHidden = false
        
        locationManager.stopUpdatingLocation()
        animationView.stopAnimationView()
    }
    
    @IBAction func pressedSOS(_ sender: Any) {
        circleButton.isHidden = true
        circleButton.isEnabled = false
        stopButton.isHidden = false
        animationView.updateAnimation()
        animationView.isUserInteractionEnabled = false
        
        guard let currentLocation else {
            return
        }
        
        let location = Location(latitude: currentLocation.coordinate.latitude, longitude: currentLocation.coordinate.longitude)
        
        locationService.sendCurrentLocation(location: location) { error in
            if let error {
                self.showAlert(from: self, title: "Error", message: "Something is wrong with your connection")
            }
        }
        
        // TODO: write calling method from locationService! 
        locationService.getGuardLocation { [weak self] result in
            
            guard let self = self else { return }
            
            switch result {
            case .success(let guards):
                guard guards.contains(where: \.isActive) else {
                    self.showAlert(from: self,
                              title: "Dangerous",
                              message: "There is no availabel guard! \n Consider to call the police")
                    return
                }
                
                
                guards.forEach { securityGuard in
                    if securityGuard.isActive {
                        self.showGuardLocation(location: securityGuard.location)
                    }
                }
            
            case .failure(_):
                self.showAlert(from: self,
                          title: "Dangerous",
                          message: "There is no availabel guard! \n Consider to call the police")
            }
        }
        

//        // TODO: logic when user choose proper setting for that
//
        recordingManager.startRecording { [weak self] result in
            guard let self = self else { return }

            switch result {
            case .success():
                print("Audio was succesfully recorded")
                //                self.manageBluredView()
            case .failure(_):
                handleStopButton()
                self.showAlert(from: self,
                          title: "Recording troubles",
                          message: "Probably you should allow access to recording in the setting of your phone")
            }
        }

//        recordingManager.timeUpdating = { [weak self] time in
//
//            self?.bluredView.updateTimeOnLabel(time: time)
//        }
////
////

        if UserDefaults.standard.bool(forKey: PersonalPermissions.allowTakePhoto.rawValue) {
            print("TAKING PHOTO STARTED")

            photoManager.takePhoto()
        }
        
        playRecordedAudio()
    }
    
    func playRecordedAudio() {
        let voice = voiceStorage.voice

        guard let time = voice?.timeStamp, let name = voice?.name else {
            return
        }
        audioManager.playAudioAsset(name)
        audioManager.playAudioAssets(after: time, and: name)
    }
    
    func handleStopButton() {
        self.recordingManager.finishRecording()
        self.photoManager.finishPhotoMaking()
//        self.isPressedSOS.toggle()
    }
    
//    func manageBluredView() {
//                
//        isPressedSOS.toggle()
//        
//        if isPressedSOS {
//            //TODO: Implement takePhotoIfNeeded()
//            
//            bluredView.stopTapped = { [weak self] in
//                guard let self = self else { return }
//                self.recordingManager.finishRecording()
//                self.photoManager.finishPhotoMaking()
//                //TODO: Implement there logic to send audio on server or store locally data from user
//                
//                self.bluredView.removeFromSuperview()
//                self.isPressedSOS.toggle()
//            }
//        
//            self.view.addSubview(bluredView)
//            self.bluredView.frame = view.frame
//        }
//        else {
//            self.view.willRemoveSubview(bluredView)
//        }
//        
//    }
    
}


extension MainPageViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        currentLocation = manager.location
        
        //TODO: put method here for sending location to server 
//        let locValue: CLLocationCoordinate2D = manager.location!.coordinate
        print("locations = \(currentLocation?.coordinate.latitude) \(currentLocation?.coordinate.longitude)")
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .authorizedAlways, .authorizedWhenInUse:
            configLocationManager()
            mapView.showsUserLocation = true
            centerViewOnUserLocation()
        case .denied:
            showAlert(from: self,
                      title: "Something wrong",
                      message: "You must allowed location on your phone's setting")
        default:
            locationManager.requestAlwaysAuthorization()
        }
    }
}

