//
//  Cameras.swift
//  DocSolsM
//
//  Created by Jene Kirishima on 07/06/2018.
//  Copyright © 2018 Jene Kirishima. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation
import CoreMotion

class Record_Screen: CustView, AVCaptureFileOutputRecordingDelegate
{

    let screenWidth = UIScreen.main.bounds.size.width
    @IBOutlet var NoticeLbl : UILabel?
    @IBOutlet var CameraView : UIView?
    @IBOutlet var FakeFlash : UIView?
    @IBOutlet var RecInd : UIView?
    @IBOutlet var CDLbl : UILabel?
    
    let MaxTimer : Int = 5
    var currentTimer : Int = 5
    var timerTrigger : Timer = Timer()
    
    let MaxStep : Int = 8
    var currentStep : Int = 0
    
    @IBOutlet var RotateCover : UIView?
    
    let captureSession = AVCaptureSession()
    var previewLayer : AVCaptureVideoPreviewLayer?
    
    var captureDevice : AVCaptureDevice?
    let stillImageOutput = AVCaptureStillImageOutput()
    let videoOutput = AVCaptureMovieFileOutput()
    
    
    var imageArr : NSMutableArray = NSMutableArray.init()
    
    
    var pulseHandle : Timer = Timer()
    var player: AVAudioPlayer?
    
    var lockTimer :Bool = false
    let motionManager = CMMotionManager()
    
    var videoData = NSData.init()
    
    var r_interrupt : Int = 0
    
    @IBOutlet var restartBtn : UIButton?


    @IBAction func restart(_ sender: UIButton) {
        
        motionManager.stopDeviceMotionUpdates()
        guard let player = self.player else { return }
        player.stop()
        self.captureSession.stopRunning()
        self.pulseHandle.invalidate()
        timerTrigger.invalidate()
        self.lockTimer = true
        
        Constants.MyNavi.popBack()
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .landscapeLeft
    }
    
    override var shouldAutorotate: Bool {
        return true
    }
    
    
    override func viewDidLoad() {
        Constants.MyNavi.referelCounter = 3
        super.viewDidLoad()
        
        let value = UIInterfaceOrientation.landscapeLeft.rawValue
        UIDevice.current.setValue(value, forKey: "orientation")

        
        let tapG = UITapGestureRecognizer.init(target: self, action: #selector(tapAction(_:)))
        tapG.numberOfTapsRequired = 1
        tapG.numberOfTouchesRequired = 1
        self.NoticeLbl?.addGestureRecognizer(tapG)
        self.NoticeLbl?.isUserInteractionEnabled = false
        self.RecInd?.layer.borderColor = UIColor.white.cgColor
        self.RecInd?.layer.borderWidth = 6.0

        pulseHandle = Timer.scheduledTimer(timeInterval: 1.0/60.0, target:self, selector:#selector(sMonitor), userInfo: nil, repeats: true)
        self.captureSession.sessionPreset = AVCaptureSession.Preset.high
        self.stillImageOutput.outputSettings = [AVVideoCodecKey:AVVideoCodecJPEG]
        if self.captureSession.canAddOutput(self.stillImageOutput) {
            self.captureSession.addOutput(self.stillImageOutput)
        }
        
        let maxDuration: CMTime = CMTimeMake(150, 10)
        
        self.videoOutput.maxRecordedDuration = maxDuration
        self.videoOutput.minFreeDiskSpaceLimit = 1024 * 1024
        
        if self.captureSession.canAddOutput(self.videoOutput) {
            self.captureSession.addOutput(self.videoOutput)
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
        if imageArr.count < 6  {  self.r_interrupt = 1  }
        
      
        guard let player = self.player else { return }
        
        if player.isPlaying
        {
            player.pause()
            self.pulseHandle.invalidate()
            timerTrigger.invalidate()
            motionManager.stopDeviceMotionUpdates()
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
                          //  if !(self.NoticeLbl?.isUserInteractionEnabled)! {  self.NoticeLbl?.isUserInteractionEnabled = true }
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
            if currentStep != MaxStep
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
                if player.currentTime == 0
                {
                    player.stop()
                    self.timerTrigger.invalidate()
                    self.showRotateGuide()
                }
            }
        }
        

        
        
        // intro 0-17
      //photo 1  // 0:18 timer 0:33-0:37
        //vid1 0:39 vid // timer 0:49-0:53 ... 1:00
        //vid2 1:01 // timer 1:09 1:13 --- 1:20
        //vid3 1:21 // time 1:32 -- 1:36 ---- 1:44
        //photo 2 // 1:45 time 1:57 --- 2:01 -- 2:02
        //photo 3 // 2:03 time 2:18 --- 2:23 -- 2:25
        //photo 4 // 2:26 time 2:40 --- 2:45 -- 2:47
        //photo 5 // 2:48 time 3:00 --- 3:04 -- 3:19
        
        /*V2
         0  0:00 - 0:39                          0 > 29
       1  0:40 (0:48 >) 0:54                    30 48 - 52 54
       3  0:55 (1:10 >) 1:25                    55 70 - 74 85
       2  1:26 (1:39 >) ///vid 1 15s 2:00       86 99 - 103  +15s 120
       3  2:01 (2:24 >) 2:31                    121 144 - 148 152
       4  2:31 (2:43 >) 2:51                    151 164 - 168 171
       5  2:52 (3:03 >) 3:10                    172 183 - 187 190
       6  3:11 (3:22.5 >) 0.0                   191 202.5 - 206.5 0.0
         */
        

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
        
        guard let player = self.player else { return }
        if !player.isPlaying
        {
            player.play()
        }
        
        self.r_interrupt = 1

    }
    
    func drawBorder()
    {
       // let contentDivider : CGFloat = (self.CameraView?.frame.size.width)!/9.0
        
        

        
        self.CameraView?.bringSubview(toFront: self.CDLbl!)
        self.CameraView?.bringSubview(toFront: self.FakeFlash!)
        
 
        self.currentStep = 1
        self.customPlayBegin()
       // self.beginTimerInit()
        
    }
    
    func customPlayBegin()
    {
        print("start \(currentStep)")
        var startTime : TimeInterval = 0
        switch currentStep
        {
        case 1:
            startTime = 30.0
            break
        case 2:
            startTime = 55.0
            break
        case 3:
            startTime = 86.0
            break
        case 4:
            startTime = 121.0
            break
        case 5: //photo
            startTime = 152.0
            break
        case 6:
            startTime = 172.0
            break
        case 7:
            startTime = 191.0
            break
        default:
            break
        }
        
        self.drawGuide()
        self.CameraView?.bringSubview(toFront: self.restartBtn!)
        guard let player = self.player else { return }
        player.currentTime = startTime
        player.play()
        
        
        
        //vid1 0:39 vid // timer 0:49-0:53 ... 1:00
        //vid2 1:01 // timer 1:09 1:13 --- 1:20
        //vid3 1:21 // time 1:32 -- 1:36 ---- 1:43
        //photo 2 // 1:45 time 1:57 --- 2:01 -- 2:02
        //photo 3 // 2:03 time 2:18 --- 2:23 -- 2:25
        //photo 4 // 2:26 time 2:40 --- 2:45 -- 2:47
        //photo 5 // 2:48 time 3:00 --- 3:04 -- 3:19
        
        
        /*V2
         0  0:00 - 0:39                          0 > 29
         1  0:40 (0:48 >) 0:54                    30 48 - 52 54
         3  0:55 (1:10 >) 1:25                    55 70 - 74 85
         2  1:26 (1:39 >) ///vid 1 15s 2:00       86 99 - 103  +15s 120
         3  2:01 (2:24 >) 2:31                    121 144 - 148 151
         4  2:31 (2:43 >) 2:51                    152 164 - 168 171
         5  2:52 (3:03 >) 3:10                    172 183 - 187 190
         6  3:11 (3:22.5 >) 0.0                   191 202.5 - 206.5 0.0*/
        
    }
    
    func beginTimerInit()
    {
        self.lockTimer = true
        self.CDLbl?.isHidden = false

        self.currentTimer = MaxTimer
        self.CDLbl?.text = "\(currentTimer)"
     
      
        timerTrigger.invalidate()
        timerTrigger = Timer.scheduledTimer(timeInterval: 1.0, target:self, selector:#selector(pulseTrigger), userInfo: nil, repeats: false)
        
    }
    
    @objc func nextVideo()
    {
        timerTrigger.invalidate()
        self.RecInd?.isHidden = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            DispatchQueue.main.async {
                self.currentStep+=1
                self.lockTimer = false
                guard let player = self.player else { return }
                player.pause()
                if self.currentStep < self.MaxStep {  self.customPlayBegin() }
                else
                {
                    self.timerTrigger.invalidate()
                    self.showRotateGuide()
                }
            }
        }
   
        
    }
    
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
                //new guide
                self.imageArr.add(theImage)

                var delayBe = self.currentStep == 2 ? 5.0 : 2.0
                if self.currentStep == 1 { delayBe = 1.5 }
                
                print("delay \(delayBe)")
                DispatchQueue.main.asyncAfter(deadline: .now() + delayBe) {
                    DispatchQueue.main.async {
                        self.currentStep+=1
                        self.lockTimer = false
                        guard let player = self.player else { return }
                        
                        // self.customPlayBegin()
                        if self.currentStep < self.MaxStep {
                            player.pause()
                            self.customPlayBegin()
                            
                        }
                    }
                }

                
            }
            
            
        })
    }
    
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

            if currentStep == 3
            {
                self.CDLbl?.isHidden = true
                self.RecInd?.isHidden = false
              //  timerTrigger.invalidate()
             //   timerTrigger = Timer.scheduledTimer(timeInterval: 15.0, target:self, selector:#selector(nextVideo), userInfo: nil, repeats: false)
                guard let player = self.player else { return }
                player.pause()
                self.recordStart()

            }
            else
            {
          
                
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
        self.RecInd?.isHidden = true


        if currentStep == 3  {  self.CameraView?.bringSubview(toFront: self.RecInd!)  }
        else
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
            print("portrait")
            self.excluTch = true
            
            NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)

            //self.backGlobal(sender: self)
            let theNext : Gallery_Screen = self.navigationController?.storyboard!.instantiateViewController(withIdentifier: "Gallery_Screen") as! Gallery_Screen
            theNext.imageArr = imageArr
            theNext.videoData = self.videoData
            Constants.MyNavi.goOverCrossFade(viewcontroller: theNext) { (_) in
                theNext.layoutDone()
            }
        }

        
    }
    
 
}
