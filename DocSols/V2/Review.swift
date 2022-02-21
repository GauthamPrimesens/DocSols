//
//  Review.swift
//  DocSolsM
//
//  Created by Jene Kirishima on 10/12/2018.
//  Copyright © 2018 Jene Kirishima. All rights reserved.
//

import Foundation
import UIKit

class ReviewSubPhoto : CustView
{
    
    @IBOutlet var imagecontainer : UIImageView?
    @IBOutlet var samplecontainer : UIImageView?
    var stepInt : Int = 0
    var imageArr : NSMutableArray = NSMutableArray.init(array: [UIImage(named:"testup1.jpg")!,UIImage(named:"testup2.jpg")!,UIImage(named:"testup3.jpg")!, UIImage(named:"testup1.jpg")!, UIImage(named:"testup2.jpg")!, UIImage(named:"testup3.jpg")!])
    
    var videoData = NSData.init()
    
    @IBOutlet var textTitle : UILabel?
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        if let thecurrentImg = imageArr[stepInt] as? UIImage {  self.imagecontainer?.image = thecurrentImg }
        
        let titleArr = ["Heels",
                        "Half squat hold",
                        "Left arch",
                        "Left arch flexed",
                        "Right arch",
                        "Right arch flexed"
            
        ]
        
        self.samplecontainer?.image = UIImage(named:"\(titleArr[stepInt % titleArr.count]).jpg")
        self.textTitle?.text = "Review your \(titleArr[stepInt % titleArr.count])"
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        
        super.viewDidAppear(animated)
        
    }
    
     @IBAction func clickNext(_ sender: Any) {
        self.stepInt+=1
        if stepInt < imageArr.count
        {
            let theNext : ReviewSubPhoto = self.navigationController?.storyboard!.instantiateViewController(withIdentifier: "ReviewSubPhoto") as! ReviewSubPhoto
            theNext.stepInt = stepInt
            theNext.imageArr = self.imageArr
            theNext.videoData = self.videoData
            Constants.MyNavi.goOverCrossFade(viewcontroller: theNext) { (_) in
            }
        }
        else
        {
            
            self.stepInt-=1
            let ContentSubmit : NSDictionary = NSDictionary.init(dictionary: [
                "medias" : self.imageArr,
                "video" : self.videoData
                ])
            var ailemntsStat = 0
            if (!Constants.MyNavi.updateInfo && CustView.isSignIn())
            {
                if let dataProf = UserDefaults.standard.value(forKey: Constants.SaveKey.profile) as? Data {
                    if let profileDict = CustView.UDDictionaryUnarchiver(AnyInput: dataProf)
                    {
                        if let ailementsP = profileDict["ailments"] as? NSNumber {  ailemntsStat = ailementsP.intValue }
                    }
                }
            }
            else
            {  if let parsedAilments = Constants.MyNavi.TempoProfile["ailments"] as? NSNumber {  ailemntsStat = parsedAilments.intValue } }
            
            
            if ailemntsStat == 0
            {
                let theNext : Type_Screen = self.navigationController?.storyboard!.instantiateViewController(withIdentifier: "Type_Screen") as! Type_Screen
                theNext.ContentSubmit = ContentSubmit
                Constants.MyNavi.goNextCrossFade(viewcontroller: theNext) { (_) in
                    CustView.saveScans(scans:self.imageArr)
                }
            }
            else
            {
                
                let theNext : SubmitScan = self.navigationController?.storyboard!.instantiateViewController(withIdentifier: "SubmitScan") as! SubmitScan
                theNext.ContentSubmit = ContentSubmit
                Constants.MyNavi.goNextCrossFade(viewcontroller: theNext) { (_) in
                    CustView.saveScans(scans:self.imageArr)
                }
                
            }
        }
    }
    
     @IBAction func clickRetry(_ sender: Any) {
        
        let theNext : OrientationScreenPort = self.navigationController?.storyboard!.instantiateViewController(withIdentifier: "OrientationScreenPort") as! OrientationScreenPort
        theNext.currentStep = stepInt
        theNext.imageArr = imageArr
        theNext.videoData = videoData
        theNext.forRedo = true
        Constants.MyNavi.goNextCrossFade(viewcontroller: theNext) { (_) in
            theNext.layoutCloneView()
        }
        
    }

    
}
