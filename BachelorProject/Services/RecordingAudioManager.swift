//
//  RecordingAudioManager.swift
//  BachelorProject
//
//  Created by Павел Снижко on 02.04.2021.
//

import AVFoundation

enum RecordingError: String, Error {
    case recording = "Not allowed to make recording"
}

typealias RecordingCompletion = ItemClosure<Result<Void, RecordingError>>

protocol Recording: AVAudioRecorderDelegate, AVAudioPlayerDelegate {
    func startRecording(completion: ItemClosure<Result<Void, RecordingError>>)
    func finishRecording()
    var timeUpdating: ItemClosure<String>? { get set}
}


class RecordingAudioManager: NSObject, Recording {
    
    private var recordingSession: AVAudioSession?
    private var audioRecorder: AVAudioRecorder?
    private var audioPlayer: AVAudioPlayer?
    
    private var timeMin = 0
    private var timeSec = 0
    
    var timeUpdating: ItemClosure<String>?
    
    var currentTime: String = "00:00" {
        didSet {
            print(currentTime)
            timeUpdating?(currentTime)
        }
    }
    
    weak var timer: Timer?
    
    
    init(recordingSession: AVAudioSession = AVAudioSession.sharedInstance(),
         audioRecorder: AVAudioRecorder?,
         audioPlayer: AVAudioPlayer?) {
        super.init()
        configureRecordingSession()
    
    }
    
    private func configureRecordingSession() {
        
        do {
            try recordingSession?.setCategory(.playAndRecord, mode: .default)
            try recordingSession?.setActive(true)
            
            recordingSession?.requestRecordPermission() { [weak self] allowed in
                
                DispatchQueue.main.async {
                    if allowed {
                        
                        print("Recording is allowed")
                        
                    } else {
                        //TODO: show alert if not and force the user move to setting
                        print("Recording is not allowed")
                    }
                }
            }
            
        } catch {
            print("failed to record!")
            // failed to record!
        }
    }
    
    func startRecording(completion: RecordingCompletion) {
        let audioFilename = getDocumentsDirectory().appendingPathComponent("recording.m4a")
        
        print(audioFilename)
        
        let settings = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 12000,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]
        
        do {
            
            audioRecorder = try AVAudioRecorder(url: audioFilename, settings: settings)
            audioRecorder?.delegate = self
            audioRecorder?.record()
            print("Start Recording")
            
            timeSec = 0
            timeMin = 0
            
            timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
                self?.timerTick()
            }
            completion(.success(()))
        } catch {
            
            print("Oooops, something wrong!")
            completion(.failure((.recording)))
            
        }
    }
    
    @objc fileprivate func timerTick(){
        timeSec += 1
        print(timeSec, timeMin)
        if timeSec == 60{
            timeSec = 0
            timeMin += 1
        }
        
        let timeNow = String(format: "%02d:%02d", timeMin, timeSec)
        
        DispatchQueue.main.async {
            self.currentTime = timeNow
        }
    }
    
    
    @objc fileprivate func resetTimerToZero(){
         timeSec = 0
         timeMin = 0
         stopTimer()
    }
    
    @objc fileprivate func stopTimer(){

         timer?.invalidate()
    }
    
    func finishRecording() {
        
        print(audioRecorder)
        print("Finish Recording")
        
        audioRecorder?.stop()
        audioRecorder = nil
            
    }
    
    // this function is optional for today maybe latter will be used
    private func playAudio() {
        
        let audioURL = getAudioFileURL()
        
        print(audioURL)
        
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playAndRecord)
                    audioPlayer = try AVAudioPlayer(contentsOf: audioURL)
                    audioPlayer?.delegate = self
                    audioPlayer?.prepareToPlay()
                    audioPlayer?.play()
                    print("Audio ready to play")
                } catch let error {
                    print(error.localizedDescription)
                }
    }
    
    private func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    
    
    private func getAudioFileURL() -> URL {
        getDocumentsDirectory().appendingPathComponent("recording.m4a")
    }
}


extension RecordingAudioManager: AVAudioRecorderDelegate {
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
//        if !flag {
//            finishRecording(success: false)
//        }
        print("Recording is finished")
        
    }

}


extension RecordingAudioManager: AVAudioPlayerDelegate {
    
}
