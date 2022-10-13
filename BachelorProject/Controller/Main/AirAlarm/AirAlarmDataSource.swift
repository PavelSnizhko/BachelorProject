//
//  AirAlarmDataSource.swift
//  BachelorProject
//
//  Created by Павел Снижко on 08.10.2022.
//

import UIKit
import NetworkLibrary

protocol CollectionViewReloadable: AnyObject {
    func reload(with states: [State])
    func updateSelectedState(with state: State)
}

class AirAlarmDataSource {
    static let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        return dateFormatter
    }()
    
    private let defaultStatesGroup = DispatchGroup()
    
    var eventSource: EventSource?
    
    private var currentLocationState: State = State(id: 1, name: "Вінницька область", nameEn: "Vinnytsia oblast", alert: false, changed: nil)
    
    var selectedState: State {
        get {
            if let model = UserDefaults.standard.getModel(for: "selectedState", with: State.self) {
                return model
            } else {
                return currentLocationState
            }
        }
        
        set {
            currentLocationState = newValue
            collectionViewDelegate?.updateSelectedState(with: newValue)
        }
    }
    
    weak var collectionViewDelegate: CollectionViewReloadable?
    
    private var statesDicrionary: [Int: State] = [:]
    
    
    private let locationManager = LocationManager()
    
    init() {
        readDefaultStateValues()
    }
    
    @Atomic var defaultStates: [State] = []
    
    var allStates: [State] {
        get {
            Array(statesDicrionary.values.sorted(by: { $0.alert && !$1.alert }))
        }
        set {
            statesDicrionary = newValue.toDictionary(with: \.id)
            collectionViewDelegate?.reload(with: allStates)
        }
    }
    
    let networkService = NetworkService()
    
    func fetchAllStates() {
        networkService.getAllStates { [weak self] result in
            switch result {
            case let .success(states):
                self?.allStates = states
            case let .failure(error):
                print(error)
            }
        }
        
        locationManager.requestLocation()
    }
    
    
    func subscibeOnCurrentLocation() {
        locationManager.requestLocation()
        
        locationManager.currentLocation = {[weak self] location in
            self?.defaultStatesGroup.wait()
            
            let stateName = location.state.lowercased()
            let currentLocationState = self?.defaultStates.filter { state -> Bool in
                state.nameEn.lowercased() == stateName
            }.first
            
            if let state = currentLocationState {
                self?.selectedState = state
            }
        }
    }
    
    func subscribeToEvents(for stateId: Int) {
        //        // TODO: reorginize code
        //        let serverURL = URL(string: "\(networkService.airAlarmHost)/live/\(stateId)")!
        //        eventSource = EventSource(url: serverURL, headers: ["X-API-Key": "foo"])
        //
        //        eventSource?.onOpen { [weak self] in
        //            print("The app starts listening to SSE host")
        //        }
        //
        //        eventSource?.onComplete { [weak self] statusCode, reconnect, error in
        //            print("The app complete listening to SSE host")
        //
        //
        //            let retryTime = self?.eventSource?.retryTime ?? 3000
        //            DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(retryTime)) { [weak self] in
        //                self?.eventSource?.connect()
        //            }
        //        }
        //
        //        eventSource?.onMessage { [weak self] id, event, data in
        //            guard let data = data, let jsonDict = self?.convertStringToJSON(string: data) else {
        //                return
        //            }
        //
        //
        //        }
        //
        //        eventSource?.addEventListener("update") { [weak self] id, event, data in
        //            print("we have an update!!!!!!!!!!!!!!!!!!!")
        //            //              self?.updateLabels(id, event: event, data: data)
        //        }
    }
    
    private func convertStringToJSON(string: String) -> [String: Any]? {
        if let data = string.data(using: String.Encoding.utf8) {
            
            do {
                let dictonary = try JSONSerialization.jsonObject(with: data, options: []) as? [String:Any]
                
                return dictonary
            } catch let error {
                print(error)
            }
        }
        
        return nil
    }
    
    
    func readDefaultStateValues() {
        //TODO: move to another general manager to fetch remote configs and settings defaults config
        let cuncurrentQueue = DispatchQueue(label: "com.queue.defaultState", qos: .default, attributes: .concurrent)
        
        self.defaultStatesGroup.enter()
        cuncurrentQueue.async {
            if let fileURL = Bundle.main.url(forResource:Constants.remoteConfigDefault, withExtension: "json") {
                do {
                    let jsonDecoder = JSONDecoder()
                    let fileData = try Data(contentsOf: fileURL)
                    let defaults = try JSONSerialization.jsonObject(with: fileData) as? [String: AnyObject]
                    guard let statesString = defaults?["states"] as? String, let data = statesString.data(using: .utf8) else {
                        return
                    }
                    
                    let stateList = try jsonDecoder.decode(StateList.self, from: data)
                    
                    DispatchQueue.main.async {
                        self.defaultStates = stateList.states
                        print("We get \(self.defaultStates )");
                        self.defaultStatesGroup.leave()
                    }
                    
                } catch {
                    print("While getting default state get error: \(error)")
                }
            }
        }
    }
    
}


extension AirAlarmDataSource {
    enum Constants {
        static let remoteConfigDefault = "remote_config_defaults"
    }
}


