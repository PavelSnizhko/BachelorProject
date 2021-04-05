//
//  AudioManager.swift
//  BachelorProject
//
//  Created by Павел Снижко on 31.03.2021.
//
import UIKit
import AVFoundation


class AudioManager: NSObject {
    
    var audioPlayer: AVAudioPlayer?
    var playingIsSuccesfullyFinished: ItemClosure<Bool>?
    
    func playAudioAsset(_ assetName : String) {
        guard let audioData = NSDataAsset(name: assetName)?.data else {
            fatalError("Unable to find asset \(assetName)")
        }
        
        do {
            audioPlayer = try AVAudioPlayer(data: audioData)
            audioPlayer?.play()
        } catch {
            fatalError(error.localizedDescription)
        }
    }
    
    func playAudioAssets(after timeLine: Int, and audioName: String) {
       
        guard let audioData = NSDataAsset(name: audioName)?.data else {
            fatalError("Unable to find asset \(audioName)")
        }
        
        DispatchQueue.global().asyncAfter(deadline: .now() + Double(timeLine)) { [weak self] in
            self?.audioPlayer = try? AVAudioPlayer(data: audioData)
            self?.audioPlayer?.play()
        }
        
    }
    
}

extension AudioManager: AVAudioPlayerDelegate {
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        playingIsSuccesfullyFinished?(flag)
    }
    
}
