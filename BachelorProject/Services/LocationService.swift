//
//  LocationService.swift
//  BachelorProject
//
//  Created by Павел Снижко on 04.04.2021.
//

import Foundation

struct LocationService {
    
    private let network = NetworkService()
    
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
    
    func getGuardLocation(completion: @escaping ItemClosure<Result<Location?, Error>>) {
        self.getGuard { result in
            switch result {
            case .success(let guardResponse):
                completion(.success(guardResponse?.location))
            case .failure(let error):
                completion(.failure(error))
            }
        }
            
    }
    
    func sendCurrentLocation(location: Location, completion: @escaping ItemClosure<Error?>) {
        network.setCurrentLocation(location: location) { error in
            completion(error)
        }
    }
}
