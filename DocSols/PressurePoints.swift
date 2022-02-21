//
//  PressurePoints.swift
//  DocSolsM
//
//  Created by Jene Kirishima on 12/06/2018.
//  Copyright © 2018 Jene Kirishima. All rights reserved.
//

import Foundation
import UIKit


class Pressure_Screen: CustView
{
    var stepNow : Int = 0
    let totalStep = 4
    @IBOutlet var footL :  UIView?
    @IBOutlet var footR :  UIView?
     @IBOutlet var footLS :  UIView?
     @IBOutlet var footRS :  UIView?
    
    @IBOutlet var cBackBtn :  UIButton?
    @IBOutlet var subTitleLbl :  UILabel?
    
    var contentPoints : NSArray = NSArray.init()
    
    
    @IBOutlet var skipBtn :  UIButton?
    
    @IBOutlet var nextBtn :  UIButton?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let arrowL = CustView.createArrow(rect: CGRect(x:0 ,y:7, width:8 ,height:16) , direction: .left, color: .white , lineWidth: 3.0)
        self.cBackBtn?.layer.addSublayer(arrowL)
    
        let ArrofSteps = ["Left foot - bottom", "Right foot - bottom", "Left foot - side", "Right foot - side"]
        let ArrofFiles = [self.footL!, self.footR!, self.footLS!, self.footRS!]
       // self.displayIMG?.image = UIImage.init(named: )
        self.subTitleLbl?.text = ArrofSteps[stepNow%totalStep]
        let viewtoAdd = ArrofFiles[stepNow%totalStep]
        viewtoAdd.frame = CGRect(x: ((self.view?.frame.size.width)! - 240)*0.5, y: ((self.view?.frame.size.height)! - 300)*0.5, width: 240, height: 300)
        self.view.addSubview(viewtoAdd)
        
        for views in viewtoAdd.subviews
        {
            if let theButton = views as? UIButton
            {
                theButton.tag = 0
                theButton.backgroundColor = .clear
                theButton.layer.borderColor = UIColor.init(netHex: 0xF33411).cgColor
                theButton.setTitleColor(UIColor.init(netHex: 0xF33411), for: .normal)
                theButton.layer.borderWidth = 2.0
                theButton.clipsToBounds = true
            }
        }
        self.skipBtn?.isHidden = true
        
        if !(stepNow + 1 < totalStep)
        {
             self.skipBtn?.isHidden = false
            self.nextBtn?.setTitle("Watch the scanning guide", for: .normal)
        }
        
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        
        
        super.viewDidAppear(animated)
        
    }
    
    @IBAction func skipPush(_ sender: UIButton) {
        let ArrofFiles = [self.footL!, self.footR!, self.footLS!, self.footRS!]
        let viewtoAdd = ArrofFiles[stepNow%totalStep]
        var locationPoint = 0
        for views in viewtoAdd.subviews
        {
            if let theButton = views as? UIButton, views.tag == 1
            {
                if let strBtn = theButton.title(for: .normal)
                {
                    let exponent = Int(strBtn)! - 1
                    let xoutpot = pow(2, exponent)
                    let result = NSDecimalNumber(decimal: xoutpot).intValue
                    locationPoint = locationPoint + result
                }
            }
        }
        
        
        let templateDict = NSDictionary.init(dictionary: [
            "foot_area" : "\(stepNow+1)" ,
            "location" : NSNumber.init(value:locationPoint)
            ])
        
        let currentArr = NSMutableArray.init(array: self.contentPoints)
        
        currentArr.add(templateDict)
        
        
        let modDict = NSMutableDictionary.init(dictionary: Constants.MyNavi.TempoProfile)
        modDict["pain_areas"] = currentArr
        Constants.MyNavi.TempoProfile = modDict
        
        
        if !Constants.Test_Mode
        {
            let theNext : OrientationScreenPort = self.navigationController?.storyboard!.instantiateViewController(withIdentifier: "OrientationScreenPort") as! OrientationScreenPort
            Constants.MyNavi.goNextCrossFade(viewcontroller: theNext) { (_) in
                theNext.layoutCloneView()
            }
        }
        else
        {
            let theNext : Gallery_Screen = self.navigationController?.storyboard!.instantiateViewController(withIdentifier: "Gallery_Screen") as! Gallery_Screen
            Constants.MyNavi.goNextCrossFade(viewcontroller: theNext) { (_) in
                theNext.layoutDone()
            }
            
        }
        
     
    }
    
    @IBAction func NextPush(_ sender: UIButton) {
        let ArrofFiles = [self.footL!, self.footR!, self.footLS!, self.footRS!]
        let viewtoAdd = ArrofFiles[stepNow%totalStep]
        var locationPoint = 0
        for views in viewtoAdd.subviews
        {
            if let theButton = views as? UIButton, views.tag == 1
            {
                if let strBtn = theButton.title(for: .normal)
                {
                    let exponent = Int(strBtn)! - 1
                    let xoutpot = pow(2, exponent)
                    let result = NSDecimalNumber(decimal: xoutpot).intValue
                    locationPoint = locationPoint + result
                }
            }
        }
        

        let templateDict = NSDictionary.init(dictionary: [
            "foot_area" : "\(stepNow+1)" ,
            "location" : NSNumber.init(value:locationPoint)
        ])
        
        let currentArr = NSMutableArray.init(array: self.contentPoints)
        
        currentArr.add(templateDict)
        
        if (stepNow + 1 < totalStep)
        {
            let theNext : Pressure_Screen = self.navigationController?.storyboard!.instantiateViewController(withIdentifier: "Pressure_Screen") as! Pressure_Screen
            theNext.stepNow = stepNow + 1
            theNext.contentPoints = currentArr
            Constants.MyNavi.goNextCrossFade(viewcontroller: theNext) { (_) in }
        }
        else
        {
            let modDict = NSMutableDictionary.init(dictionary: Constants.MyNavi.TempoProfile)
            modDict["pain_areas"] = currentArr
            Constants.MyNavi.TempoProfile = modDict
            

            
            let theNext : SoundTutorial_Screen = self.navigationController?.storyboard!.instantiateViewController(withIdentifier: "SoundTutorial_Screen") as! SoundTutorial_Screen
            Constants.MyNavi.goNextCrossFade(viewcontroller: theNext) { (_) in
                theNext.beginFunctionTutorial()
            }
            
        }
     
    }
    
    @IBAction func pressurePush(_ sender: UIButton) {
        if sender.tag == 0
        {
            sender.backgroundColor = UIColor.init(netHex: 0xF33411)
            sender.setTitleColor(.white, for: .normal)
            sender.tag = 1
        }
        else
        {
            sender.backgroundColor = .clear
            sender.setTitleColor(UIColor.init(netHex: 0xF33411), for: .normal)
            sender.tag = 0
        }
        
    }
    
}
    
    

