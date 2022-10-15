//
//  AirAlarmNetwrokManager.swift
//  BachelorProject
//
//  Created by Павел Снижко on 14.10.2022.
//

import Foundation
import NetworkLibrary

class AirAlarmNetworkManager {
    private var eventSource: EventSourceProtocol?
    private var host: String
    private var headers:  [String: String]
    
    init(host: String, headers: [String: String]) {
        self.host = host
        self.headers = headers
    }
    
    func connect(with url: URL, headers: [String: String]) {
        self.eventSource = EventSource(url: url, headers: headers)
        eventSource?.connect(lastEventId: nil)
    }
    
    func reconfigure(with relativePath: String) {
        guard let url = URL(string: host + relativePath) else {
            return
        }
        
        eventSource = EventSource(url: url, headers: self.headers)
        eventSource?.connect(lastEventId: nil )
        sartListenToEventSource()
    }
    
    func sartListenToEventSource() {
        eventSource?.onOpen { [weak self] in
            print("Start listeting to \(self?.eventSource?.url)")
        }

        eventSource?.onComplete { [weak self] statusCode, reconnect, error in
            print("The app complete listening to SSE host")

            let retryTime = self?.eventSource?.retryTime ?? 3000
            DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(retryTime)) { [weak self] in
                self?.eventSource?.connect(lastEventId: nil)
            }
        }
    }
    
    func recieveMessage<T: Decodable>(with type: T.Type, message: @escaping (Result<T, Error>) -> Void) {
        print("recieveMessage is called and listener is added")
        eventSource?.addEventListener("update", handler: { id, event, dataString in
            let jsonDecoder = JSONDecoder()

            do {
                guard let string = dataString,
                      let data = string.data(using: .utf8) else {
                    return
                }
                
                let model = try jsonDecoder.decode(type, from: data)
                message(.success(model))
            } catch {
                message(.failure(error))
            }
        })
    }
}
