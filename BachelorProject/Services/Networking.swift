//
//  Networking.swift
//  BachelorProject
//
//  Created by Павел Снижко on 04.04.2021.
//

import Foundation
import NetworkLibrary

struct GuardResponse: Codable {
    let id: String
    let firstName: String
    let secondName: String
    let phoneNumber: String
    let messageId: String
    let location: Location
}

struct GuardList: Codable {
    let users: [GuardResponse]
}

struct Location: Codable {
    let latitude: Double
    let longitude: Double
}

enum NetworkError: Error {
    case tokenExperation
}

class NetworkService {
    
    private var network = NetworkFacade(httpHeaderManager: HTTPHeaderManager(headers: ["Content-type": "application/json; charset=UTF-8"]))
    private var jsonEncoder = JSONEncoder()
    private var sessionStorage = SessionStorage()
    
    func checkTokenExperation() -> Bool {
        guard sessionStorage.sessionId != nil else  {
            return false
        }
        return true
    }
    
    func setCurrentLocation(location: Location, completion: @escaping ItemClosure<Error?>) {
        
        if !checkTokenExperation() {
            completion(NetworkError.tokenExperation)
        }
        
        let jsonData = try? jsonEncoder.encode(location)
        
        let requestDataWithBody = RequestMetaData(endpoint: "http://192.168.1.105:8000/user/location",
                                                  method: .post,
                                                  body: jsonData,
                                                  headers: ["Authorization": "Bearer " + sessionStorage.sessionId!])
        
        self.network.execute(requestData: requestDataWithBody) { result in
            switch result {
            
            case .success(_):
                completion(nil)
            case .failure(let error):
                completion(error)

            }
        }
        
    }

    
    
    func getAllFreeGuards(completion: @escaping ItemClosure<Result<[GuardResponse], Error>>) {
        
        if !checkTokenExperation() {
            completion(.failure(NetworkError.tokenExperation))
        }
        
        guard sessionStorage.sessionId != nil else { return completion(.failure(NetworkError.tokenExperation)) }
        
        let requestDataWithBody = RequestMetaData(endpoint: "http://192.168.1.105:8000/users/?type=guard&status=free",
                                                  method: .get,
                                                  body: nil,
                                                  headers: ["Authorization": "Bearer " + sessionStorage.sessionId!])
        
        
        let resourceWithBody = Resource(requestMetaData: requestDataWithBody,
                                                       decodingType: [GuardResponse].self)
        
        network.execute(resource: resourceWithBody) { result in
            switch result {
            
            case .success(let guardResponse):
                completion(.success(guardResponse))
            case .failure(let error):
                completion(.failure(error))
            }
        }
        
    }
    
}





//MARK: - LogInService, RegistrationService

extension NetworkService: LogInService, RegistrationService {
    func logIn(with credentials: Credentials, completion: @escaping (Error?) -> Void) {
        
                let jsonData = try? jsonEncoder.encode(credentials)

                let requestDataWithBody = RequestMetaData(endpoint: "http://192.168.1.105:8000/auth/login",
                                                          method: .post,
                                                          body: jsonData,
                                                          headers: nil)

                let resourceWithBody = Resource(requestMetaData: requestDataWithBody,
                                                               decodingType: ResponseModel.self)

                network.execute(resource: resourceWithBody) { [weak self] result in
                    
                    switch result {
                    case .success(let response):
                        //Stored to sessionStorage
                        self?.sessionStorage.sessionId = response.token
                        
                        completion(nil)
                        
                    case .failure(let error):
                        print(error)
                        completion(error)
                    }
                }
    }
    
    func registrate(registerModel: RegisterModel, completion: @escaping (Error?) -> Void) {
        let jsonData = try? jsonEncoder.encode(registerModel)

        let requestDataWithBody = RequestMetaData(endpoint: "http://192.168.1.105:8000/auth/register",
                                                  method: .post,
                                                  body: jsonData,
                                                  headers: nil)

        let resourceWithBody = Resource<ResponseModel>(requestMetaData: requestDataWithBody, decodingType: ResponseModel.self)

        network.execute(resource: resourceWithBody) { [weak self] result in
            switch result {
            case .success(let response):
                self?.sessionStorage.sessionId = response.token
            case .failure(let error):
                completion(error)
            }
        }
    }
    
    
}



struct ResponseModel: Decodable {
    let token: String
    
    enum CodingKeys: String, CodingKey {
        case token = "access_token"
    }
}
