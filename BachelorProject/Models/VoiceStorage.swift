//
//  VoiceStorage.swift
//  BachelorProject
//
//  Created by Павел Снижко on 01.04.2021.
//

import Foundation

// MARK: - VoiceStorage

struct VoiceStorage {
    
    private let storage = UserDefaults.standard
    
    var voice: VoiceSetting? {
        get {
            storage.object(VoiceSetting.self,
                           with: StorageKey.voiceKey.rawValue)
        }
        set {
            storage.set(object: newValue,
                        forKey: StorageKey.voiceKey.rawValue)
        }
    }
        
    private  enum StorageKey: String {
        case voiceKey
   }
}
