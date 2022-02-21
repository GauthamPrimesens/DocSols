//
//  SubmissionHandler.swift
//  DocSolsM
//
//  Created by Jene Kirishima on 24/01/2019.
//  Copyright © 2019 Jene Kirishima. All rights reserved.
//

import Foundation
import UIKit


extension Checkout_Screen
{
     
    func ProcDivSubmit(content:NSDictionary, profileInfo:NSDictionary)
    {
 
        let modProfile = NSMutableDictionary.init(dictionary: profileInfo)
        if let dataProf = UserDefaults.standard.value(forKey: Constants.SaveKey.profile) as? Data, CustView.isSignIn(), let profileParsed = CustView.UDDictionaryUnarchiver(AnyInput: dataProf), let profileID = profileParsed["id"] as? String {  modProfile["id"] = profileID }
        
        let contentSubmit = NSDictionary.init(dictionary: [

            "guest" : NSNumber.init(value: 0),
            "profiles" : [modProfile]
            ])
        
        // CALL ALL DELETE STORED
        Constants.MyNavi.showStatus(string: "Submitting info...")
        let request = CustView.RegisterCheck(tokenRequired: CustView.isSignIn() , dataTransfered: contentSubmit, theService:"user/", Method: "POST")
        Constants.MyNavi.webRequest(hasLoading: true, theRequest: request) { (respo, hasVal, errC) in
            print("---- profiles info \(respo)")
            if errC == 200, let contentDict = respo as? NSDictionary, let dataDict = contentDict["data"] as? NSDictionary, let userDict = dataDict["user"] as? NSDictionary, let profilesArr = userDict["profiles"] as? NSArray, let profilesDict = profilesArr.firstObject as? NSDictionary,  (profilesArr.count > 0), let idStr = userDict["id"] as? String
            {
                var accestokenStr = Constants.MyNavi.AccessToken
                if let unsigned =   dataDict["access_token"]  as? String, !CustView.isSignIn() { accestokenStr = unsigned }
                
                self.SubmitMedia(id:idStr, Profile: profilesDict, Token: accestokenStr, mediaContent: content)
            }
            else
            {
                
                var errormsg = "Server Error"
                if let contentDict = respo as? NSDictionary, let strError = contentDict["error"] as? String {  errormsg = strError }
                Constants.MyNavi.Alertshow(title: "Checkout Error", themessage: errormsg, with: [])
            }
            
            
            
            
        }
    }
    
    
    func SubmitMedia(id:String, Profile:NSDictionary, Token:String, mediaContent:NSDictionary)
    {

        
        let mutableMedia = NSMutableArray.init()
        
        if let arrImg = self.ContentSubmit["medias"] as? NSArray
        {
            for ximg in 0..<arrImg.count
            {
                if let uiimgFile = arrImg[ximg] as? UIImage
                {
                    if let imgadata = UIImageJPEGRepresentation(uiimgFile, 0.85)
                    {
                        let strBase64 = imgadata.base64EncodedString(options: .lineLength64Characters)
                        
                        let thedict = NSDictionary.init(dictionary: [
                            "capture_type": NSNumber.init(value:ximg+1),
                            "media_data" : strBase64,
                            "media_type" : NSNumber.init(value:1)
                            ])
                        mutableMedia.add(thedict)
                        
                    }
                }
            }
        }
        
        if let dataVid = self.ContentSubmit["video"] as? NSData
        {
            if dataVid.length > 0
            {
                
                let strBase64 = dataVid.base64EncodedString(options: .lineLength64Characters)
                let thedict = NSDictionary.init(dictionary: [
                    "capture_type": NSNumber.init(value:7),
                    "media_data" : strBase64,
                    "media_type" : NSNumber.init(value:8) //MOV
                    ])
                mutableMedia.add(thedict)
            }
        }
        
        let cardDit = NSMutableDictionary.init(dictionary: [
            "card_name": "-",
            "card_number": "0000000000000000",
            "expiry_mm": "1",
            "expiry_yyyy": "1900",
            "card_validation": "000"
            ])
        
        if let cnStr = mediaContent["Card number"] as? String { cardDit["card_number"] = cnStr  }
        if let nsStr = mediaContent["Name on card"] as? String { cardDit["card_name"] = nsStr  }
        if let yyyyStr = mediaContent["YYYY"] as? String { cardDit["expiry_yyyy"] = yyyyStr  }
        if let ccvStr = mediaContent["CCV"] as? String { cardDit["card_validation"] = ccvStr  }
        
        if let mmstr = mediaContent["Expiry date MM"] as? String {
            let arryMos = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December" ]
            
            for mosStct in 0..<arryMos.count
            {
                if arryMos[mosStct].uppercased() == mmstr.uppercased()
                {
                    let currentMonthInt = mosStct + 1
                    cardDit["expiry_mm"] = currentMonthInt > 9 ? "\(currentMonthInt)" : "\(currentMonthInt)"
                    
                }
            }
            
            
            
        }
        
        
        
        var profile_id = "-"
        if let profileID = Profile["id"] as? String {  profile_id = profileID }
        
        let submissionInfo = NSMutableDictionary.init(dictionary: [
            "profile_id" : profile_id,
            "brand_preferences" : "-",
            "notes": "-",
            "referral_code" : self.stringRefCode,
            "items": mutableMedia,
            "card_details": cardDit
            ])

        
        let forLog = NSMutableDictionary.init(dictionary:submissionInfo)
        forLog.removeObject(forKey: "items")
        print("submitted: \(forLog)")
        
        
        Constants.MyNavi.AccessToken = Token
        Constants.MyNavi.showStatus(string: "Sending media...")
        let request = CustView.RegisterCheck(tokenRequired: true , dataTransfered: submissionInfo, theService:"submissions/", Method: "POST")
        Constants.MyNavi.webRequest(hasLoading: true, theRequest: request) { (respo, hasVal, errC) in
            Constants.MyNavi.AccessToken = "-"
     
                print("---- profiles info \(respo)")
                if (errC >= 200 && errC < 300)
                {
                    let userDef = UserDefaults.standard
                    
                    
                    let toStore = CustView.UDArchiver(AnyInput: Profile)
                    userDef.set(toStore, forKey: Constants.SaveKey.profile)
                    
                    Constants.MyNavi.AccessToken = Token
                    userDef.set(Token, forKey: Constants.SaveKey.token)
        
                    userDef.synchronize()
                    
                    
                    let theNext : SubmitSuccess = self.navigationController?.storyboard!.instantiateViewController(withIdentifier: "SubmitSuccess") as! SubmitSuccess
                    Constants.MyNavi.goNextCrossFade(viewcontroller: theNext) { (_) in
                        Constants.MyNavi.referelCounter = 3
                    }
                }
                else
                {
                    if !CustView.isSignIn() {
                        CustView.updateBufferToDelete(id: id)
                    }
                 
                    var errormsg = "Server Error"
                    if let contentDict = respo as? NSDictionary
                    {
                        if let strError = contentDict["error"] as? String
                        { errormsg = strError }
                    }
                    Constants.MyNavi.Alertshow(title: "Checkout Error", themessage: errormsg, with: [])
                }
                
                
                
                
        
            
        }
    }
}
