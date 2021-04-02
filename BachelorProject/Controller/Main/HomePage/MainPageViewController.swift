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


class CustomCLLocationManager: CLLocationManager {
    
    private var _location: CLLocation?
    
    var anyLocationDelivered = false

    @objc dynamic override var location: CLLocation? {
        get {
            guard anyLocationDelivered else { return nil }
            let usedLocation = _location ?? super.location
            return usedLocation
        }
        set {
            _location = newValue
        }
    }
    
}





class MainPageViewController: UIViewController, NibLoadable {
    
    
    @IBOutlet weak var circleAnimationView: CircleAnimationView!
    
    private var voiceStorage = VoiceStorage()
    private let locationManager = CLLocationManager()
    private var currentLocation: CLLocation?
    private var isPressedSOS: Bool = false
    let regionMetters: Double = 1000
    
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
        
//        locationManager.requestAlwaysAuthorization()
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
            print("Not a;;pwed ")
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
    
    
    @IBAction func pressedSOS(_ sender: Any) {
                
        //Center the map on the place location
        let userLocationCoordinates = CLLocationCoordinate2D(latitude: preservation.lat, longitude: preservation.lon)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = userLocationCoordinates
        
        
        let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        let region = MKCoordinateRegion(center: userLocationCoordinates, span: span)
        mapView.setRegion(region, animated: true)
        mapView.addAnnotation(annotation)
        
        manageBluredView()
        
        //Add blured View
        
//        bluredView.isHidden = false
//        mapView.setCenter(guardLocation, animated: true)
        print("Please implenent me")
    }
    
    func manageBluredView() {
        
        // TODO: do I realy need this ???
        
        isPressedSOS.toggle()
        
        if isPressedSOS {
            
            bluredView.stopTapped = { [weak self] in
                guard let self = self else { return }
                print("self tapped")
                
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

