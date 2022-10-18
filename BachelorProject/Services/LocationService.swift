//
//  LocationService.swift
//  BachelorProject
//
//  Created by Павел Снижко on 04.04.2021.
//

import Foundation
import FirebaseDatabase

//MARK: - Models
struct Location: Codable {
    let latitude: Double
    let longitude: Double
}

// MARK: - Welcome
struct Guard: Codable {
    let isActive: Bool
    let location: Location
    let name, phoneNumber: String
}

struct LocationService {
    
    private let dataBase = Database.database().reference()
    private let network = NetworkService()
    private let sessionStorage = SessionStorage()
    
    func getGuard(completion: @escaping ItemClosure<Result<GuardResponse?, Error>>) {
        network.getAllFreeGuards { result in
            switch result {
            case .success(let guards):
                
                guard let guardResponse = guards.first else {
                    return completion(.success(nil))
                }
                
                DispatchQueue.main.async {
                    completion(.success(guardResponse))
                }
                
            case .failure(let error):
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
    }
    
    func getGuardLocation(completion: @escaping ItemClosure<Result<[Guard], Error>>) {
        dataBase.child("guardLocations").observe(.value) { snapshot  in
            let jsonDeocder = JSONDecoder()
            guard let value = snapshot.value as? [[String: Any]] else {
                return
            }
            
            do {
                let jsonData = try JSONSerialization.data(withJSONObject: value, options: [])
                let guardList = try jsonDeocder.decode([Guard].self, from: jsonData)
                completion(.success(guardList))
            } catch let error {
                completion(.failure(error))
            }
            
        }
            
    }
    
    func sendCurrentLocation(location: Location, completion: @escaping ItemClosure<Error?>) {
        guard let sessionId = sessionStorage.sessionId else {
            return
        }
        getUserInfo(with: sessionId)
        //TODO: write to another table all user info with coords
    }
    
    private func getUserInfo(with sessionId: String) {
        print(dataBase.child("users").value(forKey: "\(sessionId)"))
        
    }
}
