//
//  CurrentStateManager.swift
//  BachelorProject
//
//  Created by Павел Снижко on 13.10.2022.
//

import Foundation
import CoreLocation

typealias CurrentLocation = (ReversedGeoLocation) -> Void

class CurrentStateManager {
    let locationManager = LocationManager()
    
    
}

class LocationManager: NSObject {
    private let concurrentQueue = DispatchQueue(label: "com.queue.location", qos: .userInitiated, attributes: .concurrent)
    
    var currentLocation: CurrentLocation?
    
    let manager = CLLocationManager()
    
    var location: CLLocationCoordinate2D? {
        didSet {
            guard let latitude = location?.latitude, let longitude = location?.longitude else {
                return
            }
            
            concurrentQueue.async { [weak self] in
                self?.requestGeocodeLocation(with: CLLocation(latitude: latitude, longitude: longitude), currentLocation: self?.currentLocation)
            }
        }
    }
    
    private var geoLocation: ReversedGeoLocation?
    
    override init() {
        super.init()
        manager.delegate = self
    }
    
    func requestLocation() {
        manager.requestLocation()
    }
    

    
    func requestGeocodeLocation(with location: CLLocation, currentLocation: CurrentLocation?) {
        CLGeocoder().reverseGeocodeLocation(location) { placemarks, error in
            
            guard let placemark = placemarks?.first else {
                let errorString = error?.localizedDescription ?? "Unexpected Error"
                print("Unable to reverse geocode the given location. Error: \(errorString)")
                return
            }
            
            let reversedGeoLocation = ReversedGeoLocation(with: placemark)
            
            DispatchQueue.main.async {
                currentLocation?(reversedGeoLocation)
                print("We have a \(reversedGeoLocation.formattedAddress)")
            }
            
            print("concurrent print \(reversedGeoLocation.formattedAddress)")
        }
    }
    
    
}

extension LocationManager: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        self.location = locations.first?.coordinate
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("We have an Error \(error)")
    }
}


struct ReversedGeoLocation {
    let name: String            // eg. Apple Inc.
    let streetName: String      // eg. Infinite Loop
    let streetNumber: String    // eg. 1
    let city: String            // eg. Cupertino
    let state: String           // eg. CA
    let zipCode: String         // eg. 95014
    let country: String         // eg. United States
    let isoCountryCode: String  // eg. US
    
    var formattedAddress: String {
        return """
        \(name),
        \(streetNumber) \(streetName),
        \(city), \(state) \(zipCode)
        \(country)
        """
    }
    
    // Handle optionals as needed
    init(with placemark: CLPlacemark) {
        self.name           = placemark.name ?? ""
        self.streetName     = placemark.thoroughfare ?? ""
        self.streetNumber   = placemark.subThoroughfare ?? ""
        self.city           = placemark.locality ?? ""
        self.state          = placemark.administrativeArea ?? ""
        self.zipCode        = placemark.postalCode ?? ""
        self.country        = placemark.country ?? ""
        self.isoCountryCode = placemark.isoCountryCode ?? ""
    }
}
