//
//  stepCamera.swift
//  DocSolsM
//
//  Created by Jene Kirishima on 12/12/2018.
//  Copyright © 2018 Jene Kirishima. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation
import CoreMotion

class RedoRecord_Screen: CustView
{
    
    let screenWidth = UIScreen.main.bounds.size.width
    
    var imageArr : NSMutableArray = NSMutableArray.init(array: [UIImage(named:"testup1.jpg")!,UIImage(named:"testup2.jpg")!,UIImage(named:"testup3.jpg")!, UIImage(named:"testup1.jpg")!, UIImage(named:"testup2.jpg")!, UIImage(named:"testup3.jpg")!])
    var videoData = NSData.init()
    var newImage : UIImage?
    
    @IBOutlet var NoticeLbl : UILabel?
    @IBOutlet var CameraView : UIView?
    @IBOutlet var FakeFlash : UIView?
    @IBOutlet var CDLbl : UILabel?
    
    @IBOutlet var restartBtn : UIButton?
    @IBOutlet var RotateCover : UIView?
    
    let MaxTimer : Int = 5
    var currentTimer : Int = 5
    var timerTrigger : Timer = Timer()
    
    let MaxStep : Int = 8
    var currentStep : Int = 0
    var stepInt : Int = 1
    
    
    
    let captureSession = AVCaptureSession()
    var previewLayer : AVCaptureVideoPreviewLayer?
    
    var captureDevice : AVCaptureDevice?
    let stillImageOutput = AVCaptureStillImageOutput()

    var pulseHandle : Timer = Timer()
    var player: AVAudioPlayer?
    
    var lockTimer :Bool = false
    let motionManager = CMMotionManager()
    
    
    var r_interrupt : Int = 0
    
    @IBAction func restart(_ sender: UIButton) {
        
        motionManager.stopDeviceMotionUpdates()
        guard let player = self.player else { return }
        player.stop()
        self.captureSession.stopRunning()
        self.pulseHandle.invalidate()
        timerTrigger.invalidate()
        self.lockTimer = true
        
        let theNext : RedoRecord_Screen = self.navigationController?.storyboard!.instantiateViewController(withIdentifier: "RedoRecord_Screen") as! RedoRecord_Screen
        theNext.imageArr = imageArr
        theNext.videoData = videoData
        
        theNext.stepInt = stepInt
        
        Constants.MyNavi.goOverCrossFade(viewcontroller: theNext) { (_) in
            theNext.PreLayout()
        }
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .landscapeLeft
    }
    
    override var shouldAutorotate: Bool {
        return true
    }
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        let value = UIInterfaceOrientation.landscapeLeft.rawValue
        UIDevice.current.setValue(value, forKey: "orientation")
        
        
        let tapG = UITapGestureRecognizer.init(target: self, action: #selector(tapAction(_:)))
        tapG.numberOfTapsRequired = 1
        tapG.numberOfTouchesRequired = 1
        self.NoticeLbl?.addGestureRecognizer(tapG)
        self.NoticeLbl?.isUserInteractionEnabled = false

        
        pulseHandle = Timer.scheduledTimer(timeInterval: 1.0/60.0, target:self, selector:#selector(sMonitor), userInfo: nil, repeats: true)
        self.captureSession.sessionPreset = AVCaptureSession.Preset.high
        self.stillImageOutput.outputSettings = [AVVideoCodecKey:AVVideoCodecJPEG]
        if self.captureSession.canAddOutput(self.stillImageOutput) {
            self.captureSession.addOutput(self.stillImageOutput)
        }
        

        
        guard let url = Bundle.main.url(forResource: "EOA_MainVoice", withExtension: "mp3") else { return }
        
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
            try AVAudioSession.sharedInstance().setActive(true)
            
            self.player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)
            
            self.player?.volume = 1.0
        } catch let error {
            print(error.localizedDescription)
        }
        
        
        self.r_interrupt = 0
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        
        if r_interrupt == 2
        {
            self.r_interrupt = 1
            guard let player = self.player else { return }
            player.play()
            pulseHandle = Timer.scheduledTimer(timeInterval: 1.0/60.0, target:self, selector:#selector(sMonitor), userInfo: nil, repeats: true)
            
        }
        else if r_interrupt == 1
        {
            let restart : ActionButton = CustView.OAbuttoncreate(txtlbl: "Restart", completion: {() in
                self.motionManager.stopDeviceMotionUpdates()
                guard let player = self.player else { return }
                player.stop()
                self.captureSession.stopRunning()
                self.pulseHandle.invalidate()
                self.timerTrigger.invalidate()
                self.lockTimer = true
                
                Constants.MyNavi.popBack()
            })
            
            Constants.MyNavi.Alertshow(title: "Notice", themessage: "Scanning has been interupted.", with: [restart])
        }
        
    }
    
    override func viewDidDisappear(_ animated: Bool)
    {
        super.viewDidDisappear(animated)
        self.r_interrupt = 2
        if newImage == nil  {  self.r_interrupt = 1  }
        
        
        guard let player = self.player else { return }
        
        if player.isPlaying
        {
            player.pause()
            self.pulseHandle.invalidate()
            timerTrigger.invalidate()
            motionManager.stopDeviceMotionUpdates()
        }
        
    }
    
    @objc func tapAction(_ tap:UITapGestureRecognizer)
    {
        motionManager.stopDeviceMotionUpdates()
        
        self.view.isUserInteractionEnabled = false
        UIView.animate(withDuration: 0.25, delay: 0.0, options: .curveEaseInOut, animations: {() -> Void in
            
            self.NoticeLbl?.alpha = 0.0
        }, completion: {(finished: Bool) -> Void in
            self.NoticeLbl?.isHidden = true
            self.view.isUserInteractionEnabled = true
            self.drawBorder()
        })
    }
    
    
    
    //######################################################################################################################################
    //######################################################################################################################################
    func beginTimerInit()
    {
        self.lockTimer = true
        self.CDLbl?.isHidden = false
        
        self.currentTimer = MaxTimer
        self.CDLbl?.text = "\(currentTimer)"
        
        
        timerTrigger.invalidate()
        timerTrigger = Timer.scheduledTimer(timeInterval: 1.0, target:self, selector:#selector(pulseTrigger), userInfo: nil, repeats: false)
        
    }
    
    
    func drawBorder()
    {
        
        self.CameraView?.bringSubview(toFront: self.CDLbl!)
        self.CameraView?.bringSubview(toFront: self.FakeFlash!)
        
        
        self.currentStep = stepInt
        self.customPlayBegin()
    }
    
    
    func drawGuide()
    {
        
        for layers in (self.CameraView?.layer.sublayers)!
        {
            if layers.name == "guidelines"
            {  layers.removeFromSuperlayer() }
        }
        
        
        
        self.CameraView?.bringSubview(toFront: self.CDLbl!)
        self.CDLbl?.isHidden = true

   
        
        if currentStep != 3
        {
            let contH : CGFloat = (CameraView?.frame.size.height)!
            let contW : CGFloat = (CameraView?.frame.size.width)!
            let sideAlot :CGFloat = 30.0
            let lineW : CGFloat = contW - (sideAlot*2)
            let lineH : CGFloat = contH - (Constants.cameraSubs.FloorHt - (currentStep > 3 ? 20 : 0))
            
            
            let lineGuide = UIBezierPath.init()
            
            lineGuide.move(to: CGPoint(x: sideAlot, y: lineH))
            lineGuide.addLine(to: CGPoint(x: sideAlot + lineW, y: lineH))
            
            let calayer : CAShapeLayer = CAShapeLayer.init()
            calayer.path = lineGuide.cgPath
            calayer.fillColor = UIColor.clear.cgColor
            calayer.lineWidth = 8.0
            calayer.strokeColor = UIColor.init(netHex: 0xC50213).cgColor
            calayer.name = "guidelines"
            self.CameraView?.layer.addSublayer(calayer)
        }
        
        
    }
    
    func PreLayout()
    {
        
        self.CameraView?.frame = CGRect(origin: CGPoint.zero, size: self.view.frame.size)
        self.view.addSubview(self.CameraView!)
        
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
            self.setupCameras(whichcamera: .front)
        }
        
        
        let contH : CGFloat = (CameraView?.frame.size.height)!
        let contW : CGFloat = (CameraView?.frame.size.width)!
        let sideAlot :CGFloat = 30.0
        let lineW : CGFloat = contW - (sideAlot*2)
        let lineH : CGFloat = contH - Constants.cameraSubs.FloorHt
        
        
        let lineGuide = UIBezierPath.init()
        
        lineGuide.move(to: CGPoint(x: sideAlot, y: lineH))
        lineGuide.addLine(to: CGPoint(x: sideAlot + lineW, y: lineH))
        
        let calayer : CAShapeLayer = CAShapeLayer.init()
        calayer.path = lineGuide.cgPath
        calayer.fillColor = UIColor.clear.cgColor
        calayer.lineWidth = 8.0
        calayer.strokeColor = UIColor.init(netHex: 0xC50213).cgColor //UIColor.white.cgColor
        
        
        let gliderHt : CGFloat =  contH-60
        let gyroGuide = UIBezierPath.init(rect: CGRect(x: 0, y: 0, width: 40, height:gliderHt))
        let caShape : CAShapeLayer = CAShapeLayer.init()
        caShape.frame = CGRect(x: 30, y: 30, width: 40, height: gliderHt)
        caShape.path = gyroGuide.cgPath
        caShape.fillColor = UIColor.red.cgColor
        caShape.name = "bgGuide"
        
        let centermark = UIBezierPath.init(rect: CGRect(x: 5, y: (gliderHt - 50)*0.5 - 5.0, width: 30, height: 50))
        let caShape2 : CAShapeLayer = CAShapeLayer.init()
        caShape2.path = centermark.cgPath
        caShape2.fillColor = UIColor.lightGray.cgColor
        
        
        let gyroMarker = UIBezierPath.init(rect: CGRect(x: 0, y: 0, width: 40, height:50))
        let caShapeMark : CAShapeLayer = CAShapeLayer.init()
        caShapeMark.frame = CGRect(x: 0, y: 0, width: 40, height: 50)
        caShapeMark.path = gyroMarker.cgPath
        caShapeMark.fillColor = UIColor.white.cgColor
        caShapeMark.name = "bgMark"
        
        caShape.addSublayer(caShape2)
        self.NoticeLbl?.layer.addSublayer(caShape)
        caShape.addSublayer(caShapeMark)
        self.NoticeLbl?.layer.addSublayer(calayer)
        
        motionManager.deviceMotionUpdateInterval = 1.0/60.0
        motionManager.startDeviceMotionUpdates(to: OperationQueue.current!) { deviceManager, error in
            if let theresMotion = deviceManager
            {
                self.MotionHandler(motion: theresMotion)
            }
            
        }
        
        print(motionManager.isDeviceMotionActive) // print false

        
        self.r_interrupt = 1
        
    }
    
    
    //######################################################################################################################################
    //  PULSE
    //######################################################################################################################################
    //Animate Counter Label
    @objc func pulseTrigger()
    {
        self.currentTimer-=1
        
        if currentTimer > 0
        {
            self.CDLbl?.isHidden = false
            self.CDLbl?.text = "\(currentTimer)"
            timerTrigger = Timer.scheduledTimer(timeInterval: 1.0, target:self, selector:#selector(pulseTrigger), userInfo: nil, repeats: false)
        }
        else {
            
            
            self.CDLbl?.isHidden = true
            self.view.isUserInteractionEnabled = false
            let delayBe = currentStep != 2 ? 0.0 : 3.0
            DispatchQueue.main.asyncAfter(deadline: .now() + delayBe) {
                DispatchQueue.main.async {
                    self.takePhoto()
                }
            }
            
        }
        
        
    }
    
    
    func MotionHandler(motion:CMDeviceMotion)
    {
        let safegreen : Double = 10.0
        let center : Double = 80.0
        let minGreen : Double = center - safegreen
        let maxGreen : Double = center + safegreen
        let contentY = abs((180.0/Double.pi)*motion.attitude.roll)
        //  print(contentY)
        self.NoticeLbl?.isUserInteractionEnabled = false
        for layers in (self.NoticeLbl?.layer.sublayers)!
        {
            if layers.name == "bgGuide"
            {
                if let bgLayer = layers as? CAShapeLayer
                {
                    let htLayer : CGFloat = bgLayer.frame.size.height - 50
                    var currentY = htLayer*(CGFloat(contentY)/180.0)
                    if (180.0/Double.pi)*motion.attitude.roll > 0
                    {
                        if contentY >= minGreen && contentY <= maxGreen
                        {
                           // if !(self.NoticeLbl?.isUserInteractionEnabled)! {  self.NoticeLbl?.isUserInteractionEnabled = true }
                            self.NoticeLbl?.isUserInteractionEnabled = true
                            bgLayer.fillColor = UIColor.green.cgColor
                        }
                        else {  bgLayer.fillColor = UIColor.red.cgColor }
                        
                        
                        
                    }
                    else
                    {
                        bgLayer.fillColor = UIColor.red.cgColor
                        currentY = 0
                        
                    }
                    
                    
                    
                    for subLayer in bgLayer.sublayers!
                    {
                        if subLayer.name == "bgMark"
                        {
                            if let markerLayer = subLayer as? CAShapeLayer { markerLayer.frame = CGRect(x: 0, y: currentY, width: 40, height: 50) }
                        }
                    }
                }
            }
            
        }
        
        
    }
    
    @objc func sMonitor()
    {
        guard let player = self.player else { return }
        
        //player.currentTime
        //    print("---> \(player.currentTime)")
        
        //   self.CDLbl?.isHidden = true
        let minTrig = [48, 70, 99, 144, 164, 183, 202.5]
        let maxTrig = [52, 74, 103, 148, 168, 187, 206.5]
        
        if !lockTimer
        {
            if newImage == nil
            {
                if currentStep != 0
                {
                    let PMin = minTrig[currentStep - 1]
                    let pMax = maxTrig[currentStep - 1]
                    
                    if player.currentTime >= PMin && player.currentTime <= pMax && player.isPlaying
                    {
                        self.beginTimerInit()
                    }
                    
                }
                else
                {
                    if player.currentTime > 29.0 && player.isPlaying
                    {  player.pause() }
                }
            }
            else
            {

                    player.stop()
                    self.timerTrigger.invalidate()
                    self.showRotateGuide()
            }
        }
        
        
        
        
  
        
    }
    
    
    func customPlayBegin()
    {
        print("start \(currentStep)")
        var startTime : TimeInterval = 0

        
        switch currentStep
        {
        case 1:
            startTime = 34.0
            break
        case 2:
            startTime = 57.5
            break
        case 3:
            startTime = 86.0
            break
        case 4:
            startTime = 129
            break
        case 5: //photo
            startTime = 155.5
            break
        case 6:
            startTime = 173.5
            break
        case 7:
            startTime = 194.5
            break
        default:
            break
        }
        
        self.drawGuide()
        self.CameraView?.bringSubview(toFront: self.restartBtn!)
        guard let player = self.player else { return }
        player.currentTime = startTime
        player.play()
        
        

        
    }
    //#####################################################################################################################################################
    //#####################################################################################################################################################
    func takePhoto()
    {
        
        self.FakeFlash?.isHidden = false
        self.FakeFlash?.alpha = 1.0
        
        
        UIView.animate(withDuration: 0.5, delay: 0.0, options: .curveEaseInOut, animations: {() -> Void in
            
            self.FakeFlash?.alpha = 0.0
        }, completion: {(finished: Bool) -> Void in
            self.view.isUserInteractionEnabled = true
            self.FakeFlash?.isHidden = true
            
            
            self.CapturePhoto { (theImage) in
                // new guide
                //  self.imageArr.add(theImage)
                self.newImage = theImage
                
                var delayBe = self.currentStep == 2 ? 5.0 : 2.0
                if self.currentStep == 1 { delayBe = 1.5 }
                else if self.currentStep == 7 { delayBe = 2.5 }
                
                print("delay \(delayBe) \(self.currentStep)")
                DispatchQueue.main.asyncAfter(deadline: .now() + delayBe) {
                    DispatchQueue.main.async {

                        self.lockTimer = false
                        guard let player = self.player else { return }
                        

                            player.pause()

                    }
                }
                
                
            }
            
            
        })
    }
    
    
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
    
    
    //#####################################################################################################################################################
    // EXIT
    //#####################################################################################################################################################
    func showRotateGuide()
    {
        guard let player = self.player else { return }
        player.stop()
        self.lockTimer = true
        motionManager.stopDeviceMotionUpdates()
        self.pulseHandle.invalidate()
        self.RotateCover?.frame = CGRect(origin: CGPoint.zero, size: self.view.frame.size)
        self.view.addSubview(self.RotateCover!)
        self.RotateCover?.alpha = 0.0
        
        self.view.isUserInteractionEnabled = false
        UIView.animate(withDuration: 0.25, delay: 0.0, options: .curveEaseInOut, animations: {() -> Void in
            
            self.RotateCover?.alpha = 1.0
        }, completion: {(finished: Bool) -> Void in
            self.captureSession.stopRunning()
            self.CameraView?.removeFromSuperview()
            
            self.view.isUserInteractionEnabled = true
            NotificationCenter.default.addObserver(self, selector: #selector(self.RotateShift), name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
            
        })
    }
    
    
    
    
    
    @objc func RotateShift()
    {
        if !excluTch && UIDeviceOrientationIsPortrait(UIDevice.current.orientation)
        {
            //shift to portrait trigger
            print("Exit")
            self.excluTch = true
            
            NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
            
            
            //self.backGlobal(sender: self)
            var replaceIndex : Int = stepInt - 2
            if stepInt < 3 {  replaceIndex = stepInt - 1 }
      
            self.imageArr.replaceObject(at: replaceIndex, with: self.newImage!)
            
            
            let theNext : ReviewSubPhoto = self.navigationController?.storyboard!.instantiateViewController(withIdentifier: "ReviewSubPhoto") as! ReviewSubPhoto
            theNext.stepInt = replaceIndex
            theNext.imageArr = self.imageArr
            theNext.videoData = self.videoData
            Constants.MyNavi.goOverCrossFade(viewcontroller: theNext) { (_) in
            }
            

        }
        
        
    }
}
