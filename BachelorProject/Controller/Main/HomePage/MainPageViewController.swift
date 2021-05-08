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
    
    
    @IBOutlet weak var circleAnimationView: CircleAnimationView!
    // TODO: move to Di
    private var voiceStorage = VoiceStorage()
    private var recordingManager: Recording = RecordingAudioManager(audioRecorder: nil, audioPlayer: nil)
    private var audioManager: AudioManager = AudioManager()
    private let locationManager = CLLocationManager()
    private var currentLocation: CLLocation?
    private var isPressedSOS: Bool = false
    private var locationService: LocationService = LocationService()
    let regionMetters: Double = 1000
    
    weak var timer: Timer?
    
    private lazy var bluredView: BluredView = {
        let bluredView = BluredView.loadFromNib()
        
        return bluredView
        
    }()
  
    
    let preservation = Preservation(id: "0",
                                    name: "Pasha",
                                    lon: 30.523333,
                                    lat: 50.450001)
    @IBOutlet weak var mapView: MKMapView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "MainPageViewController"
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
        
//        locationManager.requestAlwaysAuthorization()ddf
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
        if CLLocationManager.locationServicesEnabled() {
            print("Все ок")
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
        
        let voice = voiceStorage.voice
        
        guard let time = voice?.timeStamp, let name = voice?.name else {
            return
        }
        
//        audioManager.playAudioAsset(name)
        
        audioManager.playAudioAssets(after: time, and: name)
        
        recordingManager.timeUpdating = { [weak self] time in
            self?.bluredView.updateTimeOnLabel(time: time)
        }
        
        
    }
    
    func manageBluredView() {
        
        // TODO: do I realy need this ???
        
        isPressedSOS.toggle()
        
        if isPressedSOS {
            
            bluredView.stopTapped = { [weak self] in
                guard let self = self else { return }
                print("self tapped")
                
                self.recordingManager.finishRecording()
                //TODO: Implement there logic to send on server or store locally data from user
                
                self.bluredView.removeFromSuperview()
            }
            
            self.view.addSubview(bluredView)
        }
        else {
            self.view.willRemoveSubview(bluredView)
        }
        
    }
    
}


extension MainPageViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
            
        currentLocation = manager.location
        
//        let locValue: CLLocationCoordinate2D = manager.location!.coordinate
        print("locations = \(currentLocation?.coordinate.latitude) \(currentLocation?.coordinate.longitude)")
    }
}

