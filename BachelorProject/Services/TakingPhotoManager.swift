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


final class TakingPhotoManager {
    
    let session = AVCaptureSession()
    var camera: AVCaptureDevice?
    
    
    lazy var cameraCaptureOutput =  {
        AVCapturePhotoOutput()
    }()
    
    
    init() {
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
                  self.showAlert("No access to camera",
                                 message: "You need to grant permissions to camera to take a picture.")
                }
            }
        })
    }
    
    func takePhoto() {
        let settings = AVCapturePhotoSettings()
        settings.flashMode = .auto
        cameraCaptureOutput?.capturePhoto(with: settings, delegate: self)
    }
    
}


extension TakingPhotoManager: VCapturePhotoCaptureDelegate {
    
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
                if let unwrappedError = error {
                    print(unwrappedError.localizedDescription)
                } else {
        
                    guard let dataImage = photo.fileDataRepresentation() else { print("fuck"); return  }
        
                        if let finalImage = UIImage(data: dataImage) {
        
                            displayCapturedPhoto(capturedPhoto: finalImage)
                        }
                }
    }
    
}
