//
//  RecordingAudioManager.swift
//  BachelorProject
//
//  Created by Павел Снижко on 02.04.2021.
//

import AVFoundation
import GoogleAPIClientForREST

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
    private var recordingSession = AVAudioSession.sharedInstance()
    private var audioRecorder: AVAudioRecorder?
    private var audioPlayer: AVAudioPlayer?
    private var googleApiService = GoogleServiceAPI()
    private var timeMin = 0
    private var timeSec = 0
    
    var timeUpdating: ItemClosure<String>?
    
    private let dispatchQueue = DispatchQueue(label: "com.audio.recording.queue", qos: .userInitiated, attributes: .concurrent)
    
    var currentTime: String = "00:00" {
        didSet {
            print(currentTime)
            timeUpdating?(currentTime)
        }
    }
    
    weak var timer: Timer?
    
    init(audioRecorder: AVAudioRecorder?,
         audioPlayer: AVAudioPlayer?) {
        super.init()
        
        configureRecordingSession()
    
    }
    
    var currentDate: String {
        let date = Date()
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd"
        let dateString = df.string(from: date)
        return dateString
    }
    
    var fileName: String {
        "recording_" + currentDate + ".m4a"
    }
    
    private func configureRecordingSession() {
        do {
            try recordingSession.setCategory(.playAndRecord, mode: .default)
            try recordingSession.setActive(true)
            
            recordingSession.requestRecordPermission { [weak self] allowed in
                
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
        let audioFilename = getAudioFileURL(for: fileName)
        
        print("We will record at \(audioFilename)")
        
        let settings = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 12000,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]
        
        do {
            audioRecorder = try AVAudioRecorder(url: audioFilename, settings: settings)
            try recordingSession.setActive(true)
            audioRecorder?.delegate = self
            audioRecorder?.record()
            print("Start Recording")
            
            timeSec = 0
            timeMin = 0
            
            guard timer == nil else { return }

            timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
                self?.timerTick()
            }
        } catch {
            audioRecorder?.stop()
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
         timer = nil
    }
    
    func finishRecording() {
        resetTimerToZero()
        audioRecorder?.stop()
        audioRecorder = nil
    }
    
    // this function is optional for today maybe latter will be used
    private func playAudio() {
        let audioURL = getAudioFileURL(for: fileName)
        
        do {
            try recordingSession.setCategory(AVAudioSession.Category.playAndRecord)
            audioPlayer = try AVAudioPlayer(contentsOf: audioURL)
            audioPlayer?.delegate = self
            let readyToPlay = audioPlayer?.prepareToPlay()
            audioPlayer?.play()

        } catch let error {
            print(error.localizedDescription)
        }
    }

    private func getAudioFileURL(for fileName: String) -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths.first!.appendingPathComponent(fileName)
    }
}


extension RecordingAudioManager: AVAudioRecorderDelegate {
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        dispatchQueue.async { [unowned self] in
            if let documentsDir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last {
                let testFilePath = documentsDir.appendingPathComponent(fileName).path
                
                googleApiService.uploadFile("recordingAudio \(fileName)", filePath: testFilePath, MIMEType: "audio/mp4") { (fileID, error) in
                    print("Upload file ID: \(fileName) \(fileID); Error: \(error?.localizedDescription)")
                }
            }
        }
    }
}


extension RecordingAudioManager: AVAudioPlayerDelegate {
    
}


class GoogleServiceAPI {
    static var service: GTLRService?

    public func search(_ fileName: String, onCompleted: @escaping (String?, Error?) -> ()) {
        let query = GTLRDriveQuery_FilesList.query()
        query.pageSize = 1
        query.q = "name contains '\(fileName)'"
            
        Self.service?.executeQuery(query) { (ticket, results, error) in
            onCompleted((results as? GTLRDrive_FileList)?.files?.first?.identifier, error)
        }
    }
    
    public func createFolder(_ name: String, onCompleted: @escaping (String?, Error?) -> ()) {
        let file = GTLRDrive_File()
        file.name = name
        file.mimeType = "application/vnd.google-apps.folder"
            
        let query = GTLRDriveQuery_FilesCreate.query(withObject: file, uploadParameters: nil)
        query.fields = "id"
            
        Self.service?.executeQuery(query) { (ticket, folder, error) in
            onCompleted((folder as? GTLRDrive_File)?.identifier, error)
        }
    }
    
    public func uploadFile(_ folderName: String, filePath: String, MIMEType: String, onCompleted: ((String?, Error?) -> ())?) {
            
        search(folderName) { (folderID, error) in
                
            if let ID = folderID {
                self.upload(ID, path: filePath, MIMEType: MIMEType, onCompleted: onCompleted)
            } else {
                self.createFolder(folderName, onCompleted: { (folderID, error) in
                    guard let ID = folderID else {
                        onCompleted?(nil, error)
                        return
                    }
                    self.upload(ID, path: filePath, MIMEType: MIMEType, onCompleted: onCompleted)
                })
            }
        }
    }
        
    private func upload(_ parentID: String, path: String, MIMEType: String, onCompleted: ((String?, Error?) -> ())?) {
            
        guard let data = FileManager.default.contents(atPath: path) else {
            onCompleted?(nil, GoogleDriverError.noDataAtPath)
            return
        }
            
        let file = GTLRDrive_File()
        file.name = path.components(separatedBy: "/").last
        file.parents = [parentID]
            
        let uploadParams = GTLRUploadParameters.init(data: data, mimeType: MIMEType)
        uploadParams.shouldUploadWithSingleRequest = true
            
        let query = GTLRDriveQuery_FilesCreate.query(withObject: file, uploadParameters: uploadParams)
        query.fields = "id"
            
        Self.service?.executeQuery(query, completionHandler: { (ticket, file, error) in
            onCompleted?((file as? GTLRDrive_File)?.identifier, error)
        })
    }
    enum GoogleDriverError: Error {
        case noDataAtPath
    }
}
