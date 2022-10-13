//
//  UserDefatuls+Codable.swift
//  BachelorProject
//
//  Created by Павел Снижко on 13.10.2022.
//

import Foundation

extension UserDefaults {
    func save<T: Codable> (model: T, for key: String) {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(model) {
            let defaults = UserDefaults.standard
            defaults.set(encoded, forKey: key)
        }
    }
    
    func getModel<T: Codable>(for key: String, with type: T.Type) -> T? {
        let decoder = JSONDecoder()

        guard let object = self.object(forKey: key) as? Data,
              let model = try? decoder.decode(type, from: object) else {
            return nil
        }
    
        return model
    }
}
