//
//  Unpayed.swift
//  DocSolsM
//
//  Created by Jene Kirishima on 11/07/2018.
//  Copyright © 2018 Jene Kirishima. All rights reserved.
//

import Foundation
import UIKit


class Unpayed_Screen: CustView, UIScrollViewDelegate, UITextFieldDelegate
{
    @IBOutlet var topLabel : UILabel?
    @IBOutlet var sportsImg : UIImageView?
    @IBOutlet var sportsV : UIView?
    @IBOutlet var fillupView : UIView?
    @IBOutlet var theScroll : UIScrollView?
    
    
    var ContentSubmit : NSDictionary = NSDictionary.init()
    override func viewDidLoad() {
        
        super.viewDidLoad()

        
        if let strImg = ContentSubmit["shoe_colour"] as? String, let nsNum = ContentSubmit["shoe_type"] as? NSNumber
        {
            let strAtt = CustView.getAttributeDict(fontName: "HelveticaNeue-Medium", alignment:.left, size: 12, color:.init(netHex: 0x22385B))
            
            let imgPref = nsNum.intValue != 1 ? "sol" :  "dol"
            if let imgFile = UIImage.init(named: "\(imgPref)_\(strImg)")
            {
                self.sportsImg?.image = imgFile
                self.sportsImg?.setNeedsDisplay()
            }
            
            let  strTitle = NSMutableAttributedString(string:"\(strImg.uppercased()) ", attributes:strAtt )
            
            
            let stringConnect = nsNum.intValue != 1 ? "Sports DocSols" :  "Dress DocSols"
            let subStr = NSAttributedString(string: stringConnect.uppercased(), attributes: strAtt)
            strTitle.append(subStr)
            
            let substrAtt = CustView.getAttributeDict(fontName: "HelveticaNeue-Light", alignment:.left, size: 12, color:.init(netHex: 0x22385B))
            
            var subtext = "Unspecified / Unknown / Unknown"
            
            let convertTempoDict = (!Constants.MyNavi.updateInfo && CustView.isSignIn()) ? CustView.fillUpTempo() : Constants.MyNavi.TempoProfile
            
            if let strUs =  convertTempoDict["foot_size_unit"] as? String, let strSs =  convertTempoDict["foot_size"] as? String, let strSh =  convertTempoDict["foot_shape"] as? String, let strGtag =  convertTempoDict["foot_size_gender"] as? NSNumber
            {
                var genderHandler = "Mens"
                if strGtag.intValue == 1 { genderHandler = "Womens" }
                else if strGtag.intValue == 2 { genderHandler = "Kids" }
                
                subtext = "\(genderHandler) / \(strUs) \(strSs) / \(strSh)"
                
            }
            
            
            
            let subStrMinor = NSAttributedString(string: "\n\n\(subtext)", attributes: substrAtt)
            strTitle.append(subStrMinor)
            
            self.topLabel?.attributedText = strTitle
        }
        
        
 
        
        self.fillupView?.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: (self.theScroll?.frame.size)!.height)
        self.theScroll?.addSubview(self.fillupView!)
        self.theScroll?.contentSize = (self.fillupView?.frame.size)!
        self.theScroll?.contentOffset = CGPoint.zero
        
        let sourceY:CGFloat = 135.0 //contact label Y
        let grayColor = UIBezierPath.init(rect: CGRect(x: 0, y:sourceY , width: self.view.frame.size.width, height: (self.fillupView?.frame.size)!.height - sourceY))
        let layerColor = CAShapeLayer()
        layerColor.path = grayColor.cgPath
        layerColor.strokeColor = UIColor.clear.cgColor
        layerColor.fillColor = UIColor.init(netHex: 0xEEEEEE).cgColor
        
        self.fillupView?.backgroundColor = .white
        self.fillupView?.layer.insertSublayer(layerColor, at: 0)
        
        for pView in (self.fillupView?.subviews)!
        {
            if let textField = pView as? UITextField
            {
                
                let paddingView: UIView = UIView.init(frame: CGRect(x: 0, y: 0, width: 10, height: textField.frame.size.height))
                textField.leftView = paddingView
                textField.leftViewMode = .always
                textField.delegate = self
                textField.addTarget(self, action: #selector(TFChange(_:)), for: .editingChanged   )
                
                if CustView.isSignIn()
                {
                    if let dataProf = UserDefaults.standard.value(forKey: Constants.SaveKey.profile) as? Data {
                        if let profileDict = CustView.UDDictionaryUnarchiver(AnyInput: dataProf)
                        {
                            let lockThis = "Email address"
                            if let emailAdd = profileDict["email"] as? String, textField.placeholder?.uppercased() == lockThis.uppercased() {
                                textField.isUserInteractionEnabled = false
                                textField.backgroundColor = UIColor.init(netHex: 0xCCCCCC)
                                textField.text = emailAdd
                            }
                            
                            let autoFill1 = "Your Full Name"
                            if let full_name = profileDict["full_name"] as? String, textField.placeholder?.uppercased() == autoFill1.uppercased() {
                                textField.text = full_name
                            }
                            
                            let autoFill2 = "Phone number"
                            if let phone = profileDict["phone"] as? String, textField.placeholder?.uppercased() == autoFill2.uppercased() {
                                textField.text = phone
                            }
                     
                        }
                    }
                }
            }
        }
        
        self.sportsV?.backgroundColor = .white
        self.sportsV?.dropShadow(color: .lightGray, opacity: 0.75, offSet: CGSize(width: -1, height: 1), radius: 3.0, scale: false)
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        
        super.viewDidAppear(animated)
        if #available(iOS 11.0, *) {
            self.theScroll?.contentInsetAdjustmentBehavior = .never
        } else { self.automaticallyAdjustsScrollViewInsets = false  }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector:#selector(keyboardWillHide(_:) ), name: .UIKeyboardWillHide, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.view.endEditing(true)
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillHide, object: nil)
        
    }
    
    @IBAction func Checkout(_ sender: UIButton) {
        self.view.endEditing(true)
        let mutableContent = NSMutableDictionary()
        var notValid : Bool = false
        for conView in (self.fillupView?.subviews)!
        {
            if let txtfield = conView as? UITextField
            {
                let keyStr = txtfield.placeholder
                let contStr = txtfield.text
                mutableContent.addEntries(from: [ "\(keyStr!)" : "\(contStr ?? "-")"])
                if contStr?.count == 0 {   notValid = true }
            }
        }
        
        
        let ToConvertTempoDict = (!Constants.MyNavi.updateInfo && CustView.isSignIn()) ? CustView.fillUpTempo() : Constants.MyNavi.TempoProfile
        print("----> \( Constants.MyNavi.updateInfo) \(ToConvertTempoDict)")
        let convertTempoDict = CustView.processTempoData(tempoData: ToConvertTempoDict)
        
        let contentMod : NSMutableDictionary = NSMutableDictionary.init(dictionary:convertTempoDict)
       // print("--> BEFORE \(contentMod)")
       // print("---> filled \(mutableContent)")
        if !notValid
        {
            
            if let emailStr = mutableContent["Email address"] as? String
            {
                if !(CustView.validateEmail(enteredEmail: emailStr))
                {
                    Constants.MyNavi.Alertshow(title: "Notice", themessage: "Invalid email.", with: [])
                    return
                }
            }
            
            let keysAndSource = [
                "Email address" : "email",
                "Phone number" : "phone",
                "Your Full Name" : "full_name"
            ]
            
            
            for keyStr in keysAndSource.keys
            {
                if let currentContent = mutableContent[keyStr] as? String, let passKey = keysAndSource[keyStr] { contentMod[passKey] = currentContent }
            }
            
            
            if let shoecol = ContentSubmit["shoe_colour"] as? String,let shoeType = ContentSubmit["shoe_type"] as? NSNumber
            {
                contentMod["shoe_colour"] = shoecol
                contentMod["shoe_type"] = shoeType
            }
            
           
            print("final profile \(contentMod)")
            
            
            Constants.MyNavi.CleanBufferRequest { (success) in
                if success {   self.ProcDivSubmit(content: mutableContent, profileInfo: contentMod)  }
                else
                {
                    Constants.MyNavi.Alertshow(title: "Unable to clear the buffer!", themessage: "", with: [])
                    
                }
            }
            
        }
        else {  Constants.MyNavi.Alertshow(title: "Notice", themessage: "All fields are required.", with: []) }
        
        
        
    }
    
    //#####################################################################################################################################
    //#####################################################################################################################################

    
    public func scrollViewWillBeginDragging(_ scrollView: UIScrollView)
    {
        self.view.endEditing(true)
    }
    
    
    @objc func keyboardWillHide(_ notification:NSNotification) {
        
        UIView.animate(withDuration: 0.2, delay: 0.0, options: .curveEaseInOut, animations: {() -> Void in
            
            let limitY : CGFloat =  (self.theScroll?.contentSize.height)! -  (self.theScroll?.frame.size.height)!
            if ((self.theScroll?.contentOffset.y)! < 0)
            {   self.theScroll?.contentOffset = CGPoint.zero  }
            else if ((self.theScroll?.contentOffset.y)! > limitY)  {  self.theScroll?.contentOffset = CGPoint(x: 0, y: limitY) }
            
        }, completion: {(finished: Bool) -> Void in
            
            
        })
        
        
    }
    
    
    @objc func TFChange(_ textField: UITextField)
    {
        var exSt = textField.text!
        if (exSt.hasPrefix(" ")) {
            let curInd = exSt.startIndex
            exSt = String(exSt[exSt.index(after: curInd)...])
            
            
        }
        
        textField.text = exSt
        
        if let cont = textField.text, (textField.placeholder?.uppercased() == "YOUR FULL NAME")
        {
            textField.text = cont.firstUppercased
        }
        else if let postaltxt = textField.text, (textField.placeholder?.uppercased() == "PHONE NUMBER")
        {
            var digitSet = CharacterSet.decimalDigits
            digitSet.insert(charactersIn:"/+*()-")
            let filteredName = String(postaltxt.unicodeScalars.filter { digitSet.contains($0) }).replacingOccurrences(of: " ", with: "")
            textField.text = filteredName
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        
        textField.text = CustView.hasWhitespace(string: textField.text)
        
        
        let thedifference : CGFloat  = Constants.DeviceProperty.devHeight - CGFloat(Constants.DeviceProperty.KBHeight) - 10
        let thealotment : CGFloat = (self.theScroll?.frame.origin.y)! + CustView.yObject(theview: textField) + (textField.superview!.frame.origin.y)
        
        UIView.animate(withDuration: 0.1, delay: 0.0, options: .curveEaseInOut, animations: {() -> Void in
            
            if (thedifference <= thealotment) {
                self.theScroll?.contentOffset = CGPoint(x:0, y:thealotment - thedifference)
            }
            
        }, completion: {(finished: Bool) -> Void in
            
            
        })
        
        
        
        
    }
    
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.text = CustView.hasWhitespace(string: textField.text)
        
        if let cont = textField.text, (textField.placeholder?.uppercased() == "YOUR FULL NAME")
        {
            textField.text = cont.firstUppercased
        }
        else if let postaltxt = textField.text, (textField.placeholder?.uppercased() == "PHONE NUMBER")
        {
            var digitSet = CharacterSet.decimalDigits
            digitSet.insert(charactersIn:"/+*()-")
            let filteredName = String(postaltxt.unicodeScalars.filter { digitSet.contains($0) }).replacingOccurrences(of: " ", with: "")
            textField.text = filteredName
        }
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    

    
    
    // ############################################################################################################################################################
    // ############################################################################################################################################################
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
            if errC == 200, let contentDict = respo as? NSDictionary, let dataDict = contentDict["data"] as? NSDictionary, let userDict = dataDict["user"] as? NSDictionary, let profilesArr = userDict["profiles"] as? NSArray, let profilesDict = profilesArr.firstObject as? NSDictionary,  (profilesArr.count > 0), let idStr = userDict["id"] as? String, let emailArr = dataDict["email_notifs"] as? NSArray, (emailArr.count > 0), let emailStr = emailArr.firstObject as? String
            {
                var accestokenStr = Constants.MyNavi.AccessToken
                if let unsigned =   dataDict["access_token"]  as? String, !CustView.isSignIn() { accestokenStr = unsigned }
                
                self.SubmitMedia(id:idStr, Profile: profilesDict, Token: accestokenStr, mediaContent: content, emailString:emailStr)
            }
            else
            {
                var errormsg = "Server Error"
                if let contentDict = respo as? NSDictionary, let strError = contentDict["error"] as? String {  errormsg = strError }
                Constants.MyNavi.Alertshow(title: "Checkout Error", themessage: errormsg, with: [])
            }
            
            
            
            
        }
    }
    
    
    
    
    func SubmitMedia(id:String, Profile:NSDictionary, Token:String, mediaContent:NSDictionary, emailString:String)
    {
   
        //store ID
        
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
        
        
        
        var profile_id = "-"
        if let profileID = Profile["id"] as? String {  profile_id = profileID }
        
        let submissionInfo = NSMutableDictionary.init(dictionary: [
            "profile_id" : profile_id,
            "brand_preferences" : "-",
            "notes": "-",
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
                
                
                let theNext : CheckoutSuccess = self.navigationController?.storyboard!.instantiateViewController(withIdentifier: "CheckoutSuccess") as! CheckoutSuccess
                theNext.successString = emailString
                Constants.MyNavi.goNextCrossFade(viewcontroller: theNext) { (_) in
                    Constants.MyNavi.referelCounter = 3
                    theNext.loadWeb()
                }
            }
            else
            {
                if !CustView.isSignIn() { CustView.updateBufferToDelete(id: id) }
                
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
