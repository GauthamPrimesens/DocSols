//
//  Submit.swift
//  DocSolsM
//
//  Created by Jene Kirishima on 05/07/2018.
//  Copyright © 2018 Jene Kirishima. All rights reserved.
//

import Foundation
import UIKit


class SubmitScan: CustView, UITextFieldDelegate
{

    var ContentSubmit : NSDictionary = NSDictionary.init()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        //aa7c3e53-2ca6-4401-8556-f44b0f845741
      //  print("---submit info \(ContentSubmit)")
        
        if let fillUpView = self.view.viewWithTag(425)
        {
            for pView in fillUpView.subviews
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
        }
     
        

    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        
        super.viewDidAppear(animated)
        if #available(iOS 11.0, *) {
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
        
        
        if let fillUpView = self.view.viewWithTag(425)
        {
            for conView in fillUpView.subviews
            {
                if let txtfield = conView as? UITextField
                {
                    let keyStr = txtfield.placeholder
                    let contStr = txtfield.text
                    mutableContent.addEntries(from: [ "\(keyStr!)" : "\(contStr ?? "-")"])
                    if contStr?.count == 0 {   notValid = true }
                }
            }
        }
        

        let ToConvertTempoDict = (!Constants.MyNavi.updateInfo && CustView.isSignIn()) ? CustView.fillUpTempo() :  Constants.MyNavi.TempoProfile
        print("xxxxx ---> \(ToConvertTempoDict)")
        let convertTempoDict = CustView.processTempoData(tempoData: ToConvertTempoDict)
        
        let contentMod : NSMutableDictionary = NSMutableDictionary.init(dictionary:convertTempoDict)
     //   print("--> BEFORE \(contentMod)")
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
            

            print("final profile \(contentMod)")

            
            
            Constants.MyNavi.CleanBufferRequest { (success) in
                if success {  self.ProcDivSubmit(profileInfo: contentMod)  }
                else
                {
                    Constants.MyNavi.Alertshow(title: "Unable to clear the buffer!", themessage: "", with: [])

                }
            }
            
        }
        else
        {
            Constants.MyNavi.Alertshow(title: "Notice", themessage: "All fields are required.", with: [])
        }
        
        
        
    }
    
    //#####################################################################################################################################
    //#####################################################################################################################################
    
    @objc func keyboardWillHide(_ notification:NSNotification) {
        
  
        
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

    }
    
//    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
//        
//        if (textField.placeholder?.uppercased() == "PHONE NUMBER")
//        {
//            
//          return string.rangeOfCharacter(from: CharacterSet.letters) == nil
//        }
//        return true
//        
//    }
    
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
    
  
    
    //############################################################################################################################################
    //############################################################################################################################################

    func ProcDivSubmit (profileInfo:NSDictionary)
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
                
                self.Submitmedia(id:idStr, Profile: profilesDict, Token: accestokenStr, emailString:emailStr)
            }
            else
            {
                var errormsg = "Server Error"
                if let contentDict = respo as? NSDictionary, let strError = contentDict["error"] as? String {  errormsg = strError }
                Constants.MyNavi.Alertshow(title: "Submission Error", themessage: errormsg, with: [])
            }
            
            
            
            
        }
    }
    
    
    
    func Submitmedia(id:String, Profile:NSDictionary, Token:String, emailString:String)
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
        
        
        var profile_id = "-"
        if let profileID = Profile["id"] as? String {  profile_id = profileID }
        
        
        
        let submissionInfo = NSMutableDictionary.init(dictionary: [
            "profile_id" : profile_id,
            "brand_preferences": "-",
            "notes": "-",
            "items": mutableMedia
            
            ])
        
//        if  CustView.isSignIn() {  submissionInfo["id"] = id }

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
                
                
                let theNext : SubmitSuccessV2 = self.navigationController?.storyboard!.instantiateViewController(withIdentifier: "SubmitSuccessV2") as! SubmitSuccessV2
                Constants.MyNavi.goNextCrossFade(viewcontroller: theNext) { (_) in
                    
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
                Constants.MyNavi.Alertshow(title: "Submission Error", themessage: errormsg, with: [])
                
  
            }
            
 
        }

        
        
    }
}
