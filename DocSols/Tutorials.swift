//
//  Tutorials.swift
//  DocSols
//
//  Created by Jene Kirishima on 03/05/2018.
//  Copyright © 2018 Jene Kirishima. All rights reserved.
//

import Foundation
import UIKit

class Tutorial_Screen: CustView
{
    
    @IBOutlet var startBtn : UIButton?
    @IBOutlet var profileBtn : UIButton?
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.startBtn?.layer.cornerRadius =  (startBtn?.frame.size.height)!*0.5
        self.startBtn?.layer.borderColor = UIColor.init(netHex: 0xff6a2b).cgColor
        self.startBtn?.layer.borderWidth = 2.0
        
        let defaults = UserDefaults.standard
        
     //   if Constants.Test_Mode { defaults.set(false, forKey: Constants.SaveKey.termsKey) }

        
        if defaults.value(forKey: Constants.SaveKey.countryKey) == nil
        {
            let request = CustView.RegisterCheck(tokenRequired:false , dataTransfered:nil, theService:"countryList/", Method: "GET")
            Constants.MyNavi.webRequest(hasLoading: false, theRequest: request) { (respo, hasVal, errC) in
                
                if errC == 200
                {
                    if let contentDict = respo as? NSDictionary, let dataDict = contentDict["data"] as? NSArray, (dataDict.count > 0)
                    {
                        print("---- xxxx \(dataDict)")
                        
                        defaults.set(dataDict, forKey: Constants.SaveKey.countryKey)
                    }
                }
              
                
            }
        }
        
        defaults.synchronize()
        
    }
    

    
    
    override func viewDidAppear(_ animated: Bool) {
          //self.profileBtn?.isHidden = true
        
        self.refreshDisplay()
        
        super.viewDidAppear(animated)
        
    }
    
    func refreshDisplay()
    {
        let titleAtt = CustView.getAttributeDict(fontName: "HelveticaNeue-Light", alignment:.right, size: 15, color:.init(netHex: 0xFFFFFF))
        let titleAttStr = NSMutableAttributedString(string:"Already a member? ", attributes:titleAtt )
        let subAtt = CustView.getAttributeDict(fontName: "HelveticaNeue-Bold", alignment:.right, size: 16, color:.init(netHex: 0xFFFFFF))
        let subStr = NSMutableAttributedString(string:"Sign in", attributes:subAtt )
        titleAttStr.append(subStr)
        
       // self.profileBtn?.setTitle("Sign In", for: .normal)
        
        self.profileBtn?.setAttributedTitle(titleAttStr, for: .normal)
        self.profileBtn?.setImage(nil, for: .normal)
        
        if let dataFromStorage = UserDefaults.standard.value(forKey: Constants.SaveKey.profile) as? Data, CustView.isSignIn()
        {
            if let profileDict = CustView.UDDictionaryUnarchiver(AnyInput: dataFromStorage)
            {
                if let LoginName = profileDict["full_name"] as? String
                {
                 
                    let userAtt = NSMutableAttributedString(string:" \(LoginName)", attributes:titleAtt )
                    self.profileBtn?.setAttributedTitle(userAtt, for: .normal)
                    self.profileBtn?.imageView?.contentMode = .scaleAspectFit
                    self.profileBtn?.setImage(UIImage.init(named:"logIcon"), for: .normal)
                }
               
            }
        }

    }
    
    @IBAction func goToProfile(_ sender: UIButton) {
        if sender.image(for: .normal) != nil
        {
            let theNext : Profile_Screen = self.navigationController?.storyboard!.instantiateViewController(withIdentifier: "Profile_Screen") as! Profile_Screen
            Constants.MyNavi.goNextCrossFade(viewcontroller: theNext) { (_) in
                theNext.fetchHistory()
            }
        }
        else  {   Constants.MyNavi.showLogin() }
       
    }
    
    @IBAction func StartPush(_ sender: UIButton) {
        
        let userdef = UserDefaults.standard

        let hasAgreedBool = userdef.bool(forKey: Constants.SaveKey.termsKey)


        Constants.MyNavi.referelCounter = 3
        Constants.MyNavi.updateInfo = CustView.isSignIn()
        let theNext : UnregSteps_Screen = self.navigationController?.storyboard!.instantiateViewController(withIdentifier: "UnregSteps_Screen") as! UnregSteps_Screen
        Constants.MyNavi.goNextCrossFade(viewcontroller: theNext) { (_) in
            if hasAgreedBool != true
            {
                let theNext : TermsScreen = self.navigationController?.storyboard!.instantiateViewController(withIdentifier: "TermsScreen") as! TermsScreen
                self.present(theNext, animated: true, completion:{
                    theNext.loadWeb()
                })
            }
        }


        
     

        
        
    }
    

}





