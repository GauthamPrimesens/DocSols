//
//  RecordingExt.swift
//  DocSolsM
//
//  Created by Jene Kirishima on 29/06/2018.
//  Copyright © 2018 Jene Kirishima. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation
import CoreMotion



extension Record_Screen
{
    func fileOutput(_ output: AVCaptureFileOutput, didFinishRecordingTo outputFileURL: URL, from connections: [AVCaptureConnection], error: Error?) {
        
        print("finish \(outputFileURL)")
        //print("FINISHED \(error)")
        // save video to camera roll
        print(error?.localizedDescription ?? "u????")
       // if error == nil {
        guard let player = self.player else { return }
        if let stringError = error?.localizedDescription
        {
            let endStr = "Recording Stopped"
            if stringError.uppercased() == endStr.uppercased()
            {
                print("savehere")
             //   UISaveVideoAtPathToSavedPhotosAlbum(outputFileURL.path, self, #selector(video(_:didFinishSavingWithError:contextInfo:)), nil)
                
                if let contentVid = NSData.init(contentsOf: outputFileURL) { self.videoData = contentVid }
               
                player.currentTime = 118
                player.play()
               
            }
            
            
        }

        self.nextVideo()
       
    }
    
   @objc func video(_ videoPath: String, didFinishSavingWithError error: NSError, contextInfo info: AnyObject) {
        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        if let  filemainurl = URL(string: ("\(documentsURL.appendingPathComponent("VID_DocSols"))" + ".mov"))
        {
            do {
                print("remove")
                try FileManager.default.removeItem(atPath: filemainurl.path)
            }
            catch { print("unabletoDeleteFile") }
        }
    }

    
    func recordStart()
    {
        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        
        if let  filemainurl = URL(string: ("\(documentsURL.appendingPathComponent("VID_DocSols"))" + ".mov"))
        {
            
            do {
                print("remove")
                try FileManager.default.removeItem(atPath: filemainurl.path)
            }
            catch { print("unabletoDeleteFile") }
            
            if let videoConnection =   self.videoOutput.connection(with: AVMediaType.video) {
                videoConnection.videoOrientation = .landscapeLeft
                self.videoOutput.startRecording(to: filemainurl, recordingDelegate: self)
            }
        }
        else
        {
            guard let player = self.player else { return }
            player.currentTime = 118
            player.play()
            self.nextVideo()
        }
       
    }
    
    //#####################################################################################################################################################
    //#####################################################################################################################################################
    func CapturePhoto(completion:@escaping (UIImage)->Void)
    {
        
        
        if let videoConnection = self.stillImageOutput.connection(with: AVMediaType.video) {
            videoConnection.videoOrientation = .landscapeLeft
            self.view.isUserInteractionEnabled = false
            self.stillImageOutput.captureStillImageAsynchronously(from: videoConnection) {
                (imageDataSampleBuffer, error) -> Void in
                
                if (imageDataSampleBuffer != nil)  {
                    if let imgRt = AVCaptureStillImageOutput.jpegStillImageNSDataRepresentation(imageDataSampleBuffer!)
                    {
                        DispatchQueue.main.async {
                            self.view.isUserInteractionEnabled = true
                            if let imgUI = UIImage.init(data: imgRt) {
                                completion(imgUI)
                                //                                completion(self.cropToPreviewLayer(originalImage: imgUI))
                            }
                            
                            
                        }
                    }
                    
                }
                else
                {
                    print("empty buffer/unable to focus")
                    self.view.isUserInteractionEnabled = true
                }
            }
            
        }
        else
        {
            print("capture fail")
        }
    }
    
    func setupCameras (whichcamera:AVCaptureDevice.Position)
    {
        let devices = AVCaptureDevice.devices()
        
        // Loop through all the capture devices on this phone
        var hasCameraChckd = false
        for device in devices {
            // Make sure this particular device supports video
            if ((device as AnyObject).hasMediaType(AVMediaType.video)) {
                // Finally check the position and confirm we've got the back camera
                if((device as AnyObject).position == whichcamera) {
                    self.captureDevice = device //as? AVCaptureDevice
                    if  self.captureDevice != nil {
                        print("Capture device found")
                        
                        hasCameraChckd = true
                        
                        
                    }
                }
            }
        }
        
        if hasCameraChckd
        {
            DispatchQueue.main.async { self.beginSessionEx()  }
        }
        else
        {
            if whichcamera == .front  {  self.setupCameras(whichcamera: .back)  }
            else
            {  Constants.MyNavi.Alertshow(title: "Camera unavailable", themessage:"" , with: [])  }
            
            
        }
    }
    
    
    func focusTo(value : Float) {
        if let device : AVCaptureDevice =  self.captureDevice {
            
            do {
                try device.lockForConfiguration()
            } catch {
                // handle error
                return
            }
            if device.isFocusModeSupported(.locked)
            {
                device.setFocusModeLocked(lensPosition: value, completionHandler: { (time) -> Void in })
            }
            
            device.unlockForConfiguration()
        }
    }
    

    
    
    func configureDevice() {
        if let device =  self.captureDevice {
            do {
                try device.lockForConfiguration()
            } catch {
                // handle error
                return
            }
            if device.isFocusModeSupported(.continuousAutoFocus) {  device.focusMode = .continuousAutoFocus }
            device.unlockForConfiguration()
        }
        
    }
    
    func beginSessionEx() {
        
        self.configureDevice()
        
        
        do {
            let input = try AVCaptureDeviceInput(device:  self.captureDevice!)
            if self.captureSession.inputs.count != 0 { self.captureSession.removeInput(self.captureSession.inputs.first!) }
            self.captureSession.addInput(input)
        } catch{
            print("Error Occured when trying get camera")
        }

        
        self.previewLayer = AVCaptureVideoPreviewLayer(session:  self.captureSession)
        self.previewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
        self.previewLayer?.frame = CGRect(origin: CGPoint.zero, size: (CameraView?.frame.size)!)
        self.previewLayer?.connection?.videoOrientation = .landscapeLeft
        self.CameraView?.layer.addSublayer( self.previewLayer!)
        
        self.captureSession.startRunning()
        self.CameraView?.bringSubview(toFront: self.NoticeLbl!)
        
        
        
    }
}
