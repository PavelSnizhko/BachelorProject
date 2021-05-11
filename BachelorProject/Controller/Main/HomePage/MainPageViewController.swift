//
//  MainPageViewController.swift
//  BachelorProject
//
//  Created by Павел Снижко on 12.03.2021.
//

import UIKit
import CoreLocation
import MapKit


//TODO: change MOCK for struct from server

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

    //MARK: - IBOutlet

    private var voiceStorage = VoiceStorage()
    private var recordingManager: Recording = RecordingAudioManager(audioRecorder: nil, audioPlayer: nil)
    private var audioManager: AudioManager = AudioManager()
    private let locationManager = CLLocationManager()
    private var currentLocation: CLLocation?
    private var isPressedSOS: Bool = false
    private var locationService: LocationService = LocationService()
    
    private lazy var photoManager: TakingPhotoManager = {
        TakingPhotoManager()
    }()
    
    let regionMetters: Double = 1000
    
    weak var timer: Timer?
    
    private lazy var bluredView: BluredView = {
        let bluredView = BluredView.loadFromNib()
        
        return bluredView
        
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        checkLocationEnabling()
        mapView.showsUserLocation = true
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    func configLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        // probably I need this for handling when user hide his phone
       
        
        
        locationManager.startUpdatingLocation()
    }
    
    func centerViewOnUserLocation() {
        //if location is not nill
        if let location = locationManager.location?.coordinate {
            let region = MKCoordinateRegion.init(center: location,
                                                 latitudinalMeters: regionMetters,
                                                 longitudinalMeters: regionMetters)
            mapView.setRegion(region, animated: true)
        }
    }
    
    func checkLocationEnabling() {
        locationManager.requestAlwaysAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            configLocationManager()
            checkLocationAuthorization()
            centerViewOnUserLocation()
        }
        else {
            showAlert(from: self,
                      title: "Something wrong",
                      message: "You must allowed location on your phone's setting")
        }
    }
    
    func checkLocationAuthorization() {

        switch CLLocationManager.authorizationStatus() {
        case .authorizedAlways:
            
            mapView.showsUserLocation = true
            centerViewOnUserLocation()
            
        case .notDetermined:
            
            locationManager.requestWhenInUseAuthorization()
            
        case .restricted:
            
            break
            
        case .denied:
            // show alert instruction
            break
            
        case .authorizedWhenInUse:
            
            mapView.showsUserLocation = true
            centerViewOnUserLocation()
            // do it
            
        @unknown default:
            fatalError("Unexcpectable error")
        }
    }
    
    func showGuardLocation(location: Location) {
        let userLocationCoordinates = CLLocationCoordinate2D(latitude: location.latitude,
                                                             longitude: location.longitude)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = userLocationCoordinates
        
        
        let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        let region = MKCoordinateRegion(center: userLocationCoordinates, span: span)
        mapView.setRegion(region, animated: true)
        mapView.addAnnotation(annotation)
    }
    
    
    @IBAction func pressedSOS(_ sender: Any) {
        
        // TODO: send my location???
        
        // TODO: write calling method from locationService! 
        locationService.getGuardLocation { [weak self] result in
            
            guard let self = self else { return }
            
            switch result {
            case .success(let location):
                if let location = location {
                    self.showGuardLocation(location: location)
                } else {
                    self.showAlert(from: self,
                              title: "Dangerous",
                              message: "There is no free guard !!!! Move to their side")
                }
            case .failure(_):
                print("The token is expired")
                    self.showAlert(from: self,
                               title: "non authorized",
                               message: "Your time in app is over. Please make registration")
            }
        }
        
        
        
        // TODO: logic when user choose proper setting for that
        
        recordingManager.startRecording { [weak self] result in
            guard let self = self else { return }

            switch result {
            case .success():
                self.manageBluredView()
            case .failure(_):
                self.showAlert(from: self,
                          title: "Recording troubles",
                          message: "Probably you should allow access to recording in the setting of your phone")
            }
        }
        

        recordingManager.timeUpdating = { [weak self] time in
        
            self?.bluredView.updateTimeOnLabel(time: time)
        }
        
        
        //playing audio config
        let voice = voiceStorage.voice
        
        guard let time = voice?.timeStamp, let name = voice?.name else {
            return
        }
        
//        photoManager.takePhoto()
        
        // for playing audio after sos button pressing
        // audioManager.playAudioAsset(name)
        audioManager.playAudioAssets(after: time, and: name)
  
    }
    
    func manageBluredView() {
                
        isPressedSOS.toggle()
        
        if isPressedSOS {
            
            //TODO: Implement takePhotoIfNeeded()
            
            bluredView.stopTapped = { [weak self] in
                guard let self = self else { return }
                
                self.recordingManager.finishRecording()
                
                //TODO: Implement there logic to send audio on server or store locally data from user
                
                
                self.bluredView.removeFromSuperview()
                self.isPressedSOS.toggle()

            }
            

            self.view.addSubview(bluredView)
            
            self.bluredView.frame = view.frame

        }
        else {
            self.view.willRemoveSubview(bluredView)
        }
        
    }
    
    func takePhotoIfNeeded() {
        
    }
    
}


extension MainPageViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
            
        currentLocation = manager.location
        
        //TODO: put method here for sending location to server 
//        let locValue: CLLocationCoordinate2D = manager.location!.coordinate
        print("locations = \(currentLocation?.coordinate.latitude) \(currentLocation?.coordinate.longitude)")
    }
}

