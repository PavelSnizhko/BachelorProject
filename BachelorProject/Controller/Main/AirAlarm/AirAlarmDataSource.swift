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
    func updateStateStatus(with state: State )
}

class AirAlarmDataSource {
    static let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        return dateFormatter
    }()
    
    private var savedSelectedUserState: State? {
        UserDefaults.standard.getModel(for: "selectedState", with: State.self)
    }
    
    private let defaultStatesGroup = DispatchGroup()
    
    private lazy var airAlarmNetworkManager = AirAlarmNetworkManager(host: "http://127.0.0.1:10101", headers: ["X-API-Key": "foo"])
        
    private var currentLocationState = State(id: 1, name: "Вінницька область", nameEn: "Vinnytsia oblast", alert: false, changed: nil)
    
    private var statesDicrionary: [Int: State] = [:]
    
    private let locationManager = LocationManager()
    
    let networkService = NetworkService()
    
    weak var collectionViewDelegate: CollectionViewReloadable?
    
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
    
    func changeSelectedState(_ state: State) {
        guard let newState = allStates.first(where: { $0.id == state.id }) else {
            return
        }
        
        self.selectedState = newState
        airAlarmNetworkManager.reconfigure(with: "/api/states/live")
        airAlarmNetworkManager.recieveMessage(with: StateContainer.self) { [weak self] result in
            switch result {
            case let .success(model):
                self?.collectionViewDelegate?.updateStateStatus(with: model.state)
                
                if self?.selectedState.id == model.state.id {
                    self?.collectionViewDelegate?.updateSelectedState(with: model.state)
                }
                
                print("We recieve states from SSE \(model.state)")
            case let .failure(error):
                print("Something wrong with SSE \(error)")
            }
        }
    }
        
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
            
            if let state = currentLocationState, self?.savedSelectedUserState == nil {
                self?.changeSelectedState(state)
            }
        }
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


