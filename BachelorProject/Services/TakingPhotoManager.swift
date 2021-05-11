//
//  TakingPhotoManager.swift
//  BachelorProject
//
//  Created by Павел Снижко on 10.05.2021.
//

import Foundation
import AVFoundation

protocol PhotoTacking {
    func makePhoto()
}


final class TakingPhotoManager: NSObject {
    
    let session = AVCaptureSession()
    var camera: AVCaptureDevice?
    var timer: Timer?
    
    lazy var cameraCaptureOutput =  {
        AVCapturePhotoOutput()
    }()
    
    
    override init() {
        super.init()
        initCaptureSession()
    }
    
    
    private func initCaptureSession() {
        
        session.sessionPreset = .low
        camera = AVCaptureDevice.default(for: .video)
        
        guard let camera = camera else { return }
        
        AVCaptureDevice.requestAccess(for: .video,
                                      completionHandler: { [weak self] grantedFlag in
                                        
            DispatchQueue.global(qos: .utility).async { [weak self] in
                if grantedFlag {
                    do {
                        
                        guard let self = self else { return }
                        
                        let cameraCaptureInput = try AVCaptureDeviceInput(device: camera)
                         
                        self.session.addInput(cameraCaptureInput)
                        self.session.addOutput(self.cameraCaptureOutput)
                        self.session.startRunning()
                        
                        print("Works!!!")
                        
                    } catch {
                        print(error.localizedDescription)
                    }
                } else {
                    print("You need to grant permissions to camera to take a picture.")
//                  self.showAlert("No access to camera",
//                                 message: "You need to grant permissions to camera to take a picture.")
                }
            }
        })
    }
    
    func takePhoto() {
        timer = Timer.scheduledTimer(withTimeInterval: 4.0, repeats: true) { [weak self] _ in
            DispatchQueue.global(qos: .utility).async { [weak self] in
                let settings = AVCapturePhotoSettings()
                settings.flashMode = .auto
                guard let self = self else { return }
                self.cameraCaptureOutput.capturePhoto(with: settings, delegate: self)
            }
        }
    }
    
    func finishPhotoMaking() {
        timer?.invalidate()
        timer = nil
    }
    
}


extension TakingPhotoManager : AVCapturePhotoCaptureDelegate {
    
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
                if let unwrappedError = error {
                    print(unwrappedError.localizedDescription)
                } else {
        
                    guard let imageData = photo.fileDataRepresentation() else { return  }
                
                            storePhoto(imageData)
                }
    }
    
    func storePhoto(_ imageData: Data) {
        
        storeToCoreData(using: imageData)
        sendIfNeededToServer(using: imageData)
        
    }
}


extension TakingPhotoManager {
    
    func storeToCoreData(using imageData: Data) {
        print("storeToCoreData")
        print(imageData)
    }
    
    
    func sendIfNeededToServer(using imageData: Data) {
        print("Sended to the server")
        print(imageData)
    }
}
