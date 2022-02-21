//
//  TutorialV2.swift
//  DocSolsM
//
//  Created by Jene Kirishima on 28/06/2018.
//  Copyright © 2018 Jene Kirishima. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation

class SoundTutorial_Screen: CustView, UIScrollViewDelegate
{
    
    
    @IBOutlet var theScroll : UIScrollView?
    

    @IBOutlet var pageCont : UIPageControl?
    
    var pulseHandle : Timer = Timer()
    var player: AVAudioPlayer?
    
    var lockTimer :Bool = false
    let totalPage : Int = 6
    
    override func viewDidLoad() {
        self.view.isUserInteractionEnabled = false
        super.viewDidLoad()


        for ctx in 0..<totalPage
        {
            let theimgView = UIImageView.init(frame: CGRect(origin: CGPoint(x: CGFloat(ctx) * (self.view.frame.size.width), y:0), size: (self.theScroll?.frame.size)!))
            
            theimgView.image = UIImage.init(named: "tutV2_00\(ctx + 1)")
            theimgView.contentMode = .scaleAspectFit
            theimgView.clipsToBounds = true
            self.theScroll?.addSubview(theimgView)
        }
        
        self.theScroll?.contentSize = CGSize(width:(self.view.frame.size.width) * CGFloat(totalPage), height: (theScroll?.frame.size.height)!)
        self.theScroll?.contentOffset = CGPoint.zero
        self.pageCont?.currentPage = 0
        
   
        
        
        guard let url = Bundle.main.url(forResource: "EOA_TutVoice", withExtension: "mp3") else { return }
        
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
            try AVAudioSession.sharedInstance().setActive(true)
            
            self.player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)
            
            self.player?.volume = 1.0
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        
        super.viewDidAppear(animated)
        if #available(iOS 11.0, *) {
            self.theScroll?.contentInsetAdjustmentBehavior = .never
        } else { self.automaticallyAdjustsScrollViewInsets = false  }
        
        
        guard let player = self.player else { return }
        if player.currentTime > 0.3 { player.play() }
        
    }
    
    
    override func viewDidDisappear(_ animated: Bool)
    {
        super.viewDidDisappear(animated)
        guard let player = self.player else { return }
        if player.currentTime > 0.3 && player.isPlaying { player.pause() }
    
    }
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView)
    {
//        let currentpage = Int(scrollView.contentOffset.x/scrollView.frame.size.width)
//        self.pageCont?.currentPage = currentpage

    }
    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView)
    {
        
     //   print("didEnd")
       
        let currentpage = Int(scrollView.contentOffset.x/scrollView.frame.size.width)
        self.pageCont?.currentPage = currentpage

        self.playFromSwipe()
        
    }
    @IBAction func returnHome(_ sender: Any) {
        guard let player = self.player else { return }
        player.stop()

        self.pulseHandle.invalidate()
        //Constants.MyNavi.GoToMain(completion: nil)
        Constants.MyNavi.popBack()
    }
    
    @IBAction func DoneTut(_ sender: Any) {
        guard let player = self.player else { return }
        player.stop()
        self.pulseHandle.invalidate()
        
        
        if !Constants.Test_Mode
        {
            let theNext : OrientationScreenPort = self.navigationController?.storyboard!.instantiateViewController(withIdentifier: "OrientationScreenPort") as! OrientationScreenPort
            Constants.MyNavi.goOverCrossFade(viewcontroller: theNext) { (_) in
                theNext.layoutCloneView()
            }
        }
        else
        {
            let theNext : Gallery_Screen = self.navigationController?.storyboard!.instantiateViewController(withIdentifier: "Gallery_Screen") as! Gallery_Screen
            Constants.MyNavi.goOverCrossFade(viewcontroller: theNext) { (_) in
                theNext.layoutDone()
            }

        }
     
        
        
    }
    
    
    func beginFunctionTutorial()
    {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            DispatchQueue.main.async {
                self.view.isUserInteractionEnabled = true
                self.pulseHandle = Timer.scheduledTimer(timeInterval: 1.0/60.0, target:self, selector:#selector(self.sMonitor), userInfo: nil, repeats: true)
                guard let player = self.player else { return }
                player.currentTime = 0.0
                player.play()
            }
        }
    }
    
    
    @objc func sMonitor()
    {
        guard let player = self.player else { return }
        

        
        if player.currentTime >= 121 { self.pulseHandle.invalidate() }
        
        if !lockTimer
        {
            let NextLine = self.getStepbyDuration(currentTime:player.currentTime)
            if (pageCont?.currentPage != NextLine && NextLine != -1)
            {  self.incrementAnimate(NextLine:NextLine) }
        }
        
        
     
    }
    
    func getStepbyDuration(currentTime:TimeInterval)-> Int
    {
        if  currentTime <= 25  { return 0 }
        else if currentTime >= 26 && currentTime <= 50  {  return 1 }
        else if currentTime >= 51 && currentTime <= 69 { return 2 }
        else if currentTime >= 70 && currentTime <= 77 {  return 3  }
        else if currentTime >= 78 && currentTime <= 85 {  return 4 }
        else if currentTime >= 86 {  return 5 }
        return -1
        
    }
    
    
    func playFromSwipe()
    {
        guard let player = self.player else { return }
        
      
            switch pageCont?.currentPage {
            case 0:
                player.currentTime = 0.0
                break
            case 1:
                player.currentTime = 26
                break
            case 2:
                player.currentTime = 51
                break
            case 3:
                player.currentTime = 70
                break
            case 4:
                player.currentTime = 78
                break
            case 5:
                player.currentTime = 86
                break
            default:
                player.stop()
                break
            }
        
        
        if !self.pulseHandle.isValid
        {
            self.pulseHandle = Timer.scheduledTimer(timeInterval: 1.0/60.0, target:self, selector:#selector(self.sMonitor), userInfo: nil, repeats: true)
            player.play()
        }
   
    }
    
    func incrementAnimate(NextLine:Int)
    {
       
            self.lockTimer = true
            self.view.isUserInteractionEnabled = false
        
            UIView.animate(withDuration: 0.5, delay: 0.0, options: .curveEaseInOut, animations: {() -> Void in
                
                self.theScroll?.contentOffset = CGPoint(x: CGFloat(NextLine)*(self.theScroll?.frame.size.width)!, y: 0)
            }, completion: {(finished: Bool) -> Void in
                self.pageCont?.currentPage = NextLine
                self.lockTimer = false
                self.view.isUserInteractionEnabled = true
                // player.play()

                
            })
        
    }

}
