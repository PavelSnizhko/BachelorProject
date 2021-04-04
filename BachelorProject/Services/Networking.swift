//
//  Networking.swift
//  BachelorProject
//
//  Created by Павел Снижко on 04.04.2021.
//

import Foundation
import NetworkLibrary


class NetworkService {
    
    private var network = NetworkFacade(httpHeaderManager: HTTPHeaderManager(headers: ["Content-type": "application/json; charset=UTF-8"]))
    private var jsonEncoder = JSONEncoder()
    private var sessionStorage = SessionStorage()
    
    
}





//MARK: - LogInService, RegistrationService

extension NetworkService: LogInService, RegistrationService {
    func logIn(authModel: AuthModel, completion: @escaping (Error?) -> Void) {
        
                let jsonData = try? jsonEncoder.encode(authModel)

                let requestDataWithBody = RequestMetaData(endpoint: "http://localhost:8000/auth/login",
                                                          method: .post,
                                                          body: jsonData,
                                                          headers: nil)

                let resourceWithBody = Resource<ResponseModel>(requestMetaData: requestDataWithBody,
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

        let requestDataWithBody = RequestMetaData(endpoint: "http://localhost:8000/auth/register",
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
