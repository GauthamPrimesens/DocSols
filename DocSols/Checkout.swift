//
//  Checkout.swift
//  DocSolsM
//
//  Created by Jene Kirishima on 08/06/2018.
//  Copyright © 2018 Jene Kirishima. All rights reserved.
//

import Foundation
import UIKit


class Checkout_Screen: CustView, UIScrollViewDelegate, UITextFieldDelegate, CountryPickerScreenDelegate
{

    @IBOutlet var countryTxtfield : UITextField?
    
    @IBOutlet var topLabel : UILabel?
    @IBOutlet var sportsImg : UIImageView?
    @IBOutlet var sportsV : UIView?
    @IBOutlet var fillupView : UIView?
    @IBOutlet var theScroll : UIScrollView?
    
    @IBOutlet var buttonApply : UIButton?
    @IBOutlet var refTxtfield : UITextField?

    @IBOutlet var refCT : UILabel?
    
    @IBOutlet var dcprice : UIView?
    @IBOutlet var dcpricelbl : UILabel?
    
    @IBOutlet var origprice : UIView?
    @IBOutlet var origpricelbl : UILabel?
    
    var stringRefCode : String = ""
    var priceTagString : String = "149.99"

    var ContentSubmit : NSDictionary = NSDictionary.init()
    
    //###################### Delegate ####################
    func updateTextfield(_ string: String?) {
        print("0000 here \(string ?? "none")")
        self.countryTxtfield?.text = string
    }
    
    
    @IBAction func showCountryPicker(_ sender: UIButton)
    {
        let theNext : CountryPickerScreen = self.navigationController?.storyboard!.instantiateViewController(withIdentifier: "CountryPickerScreen") as! CountryPickerScreen
        theNext.delegate = self
        self.present(theNext, animated: true, completion:{
            
        })
    }
    
    func pricetagAttribProc(String:String, color:UIColor)->NSMutableAttributedString
    {
        var dollarAttrib = CustView.getAttributeDict(fontName: "HelveticaNeue-Bold", alignment:.center, size: 20, color:color)
        dollarAttrib[NSAttributedStringKey.baselineOffset] = 20
        var pricetagAttrib = CustView.getAttributeDict(fontName: "HelveticaNeue-Bold", alignment:.center, size: 30, color:color)
        pricetagAttrib[NSAttributedStringKey.baselineOffset] = 15
        
        var currencyAttrib = CustView.getAttributeDict(fontName: "HelveticaNeue-Bold", alignment:.center, size: 15, color:color)
        currencyAttrib[NSAttributedStringKey.baselineOffset] = 23
        
        let mainString = NSMutableAttributedString(string: "$ ", attributes: dollarAttrib)
        let priceString = NSAttributedString(string: String, attributes: pricetagAttrib)
        let currString = NSAttributedString(string: " AU", attributes: currencyAttrib)
        mainString.append(priceString)
        mainString.append(currString)
        
        
        return mainString
    }

    //####################################################

    override func viewDidLoad() {
        
        super.viewDidLoad()
        //aa7c3e53-2ca6-4401-8556-f44b0f845741
     //   print("---submit info \(ContentSubmit)")
        self.dcprice?.isHidden = true
        self.origprice?.isHidden = false
        
        self.refCT?.text = "\(Constants.MyNavi.referelCounter)"
        self.buttonApply?.layer.cornerRadius = 5.0
        self.buttonApply?.layer.borderColor = UIColor.init(netHex: 0x22385B).cgColor
        self.buttonApply?.layer.borderWidth = 1.0
        
        
        
        if Constants.MyNavi.referelCounter <= 0
        {  self.reduceRef() }
        
        
        
        
        
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
            print("xxxx \(convertTempoDict)")
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

            
            let formatter = NumberFormatter()
            formatter.numberStyle = .none
            formatter.minimumFractionDigits = 2
            formatter.maximumFractionDigits = 2
            let pricestring = formatter.string(from: NSNumber.init(value: Double(self.priceTagString)!)) ?? "n/a"

            self.origpricelbl?.attributedText =  self.pricetagAttribProc(String: pricestring, color: UIColor(netHex:0x1C5378) )
        }
        

        
        self.fillupView?.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 850)
        self.theScroll?.addSubview(self.fillupView!)
        self.theScroll?.contentSize = (self.fillupView?.frame.size)!
        self.theScroll?.contentOffset = CGPoint.zero
        
        let sourceY:CGFloat = 135.0 //contact label Y
        let grayColor = UIBezierPath.init(rect: CGRect(x: 0, y:sourceY , width: self.view.frame.size.width, height: 850 - sourceY))
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
                
                if textField.placeholder?.uppercased() == "EXPIRY DATE MM" || textField.placeholder?.uppercased() == "YYYY"
                {
                    textField.layer.name = textField.placeholder?.uppercased()
                    let uiview = UIView.init(frame: CGRect(origin: CGPoint.zero, size: textField.frame.size))
                    uiview.layer.name = textField.placeholder?.uppercased()
                    uiview.backgroundColor = .clear
                    let gesture : UITapGestureRecognizer = UITapGestureRecognizer.init(target: self, action:#selector(tapDate(_:)))
                    gesture.numberOfTapsRequired = 1
                    textField.isUserInteractionEnabled = true
                    uiview.isUserInteractionEnabled = true
                    uiview.addGestureRecognizer(gesture)
                    textField.addSubview(uiview)
                }
                
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
        
        
        let defaults = UserDefaults.standard
        
        if defaults.value(forKey: Constants.SaveKey.countryKey) == nil
        {
            let request = CustView.RegisterCheck(tokenRequired:false , dataTransfered:nil, theService:"countryList/", Method: "GET")
            Constants.MyNavi.webRequest(hasLoading: false, theRequest: request) { (respo, hasVal, errC) in
                
                if errC == 200
                {
                    if let contentDict = respo as? NSDictionary, let dataDict = contentDict["data"] as? NSArray, (dataDict.count > 0)
                    {
                        defaults.set(dataDict, forKey: Constants.SaveKey.countryKey)
                    }
                }
                
                
            }
        }
        
        defaults.synchronize()
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
            if let txtfield = conView as? UITextField, (conView.layer.name != "ignore")
            {
                
                let keyStr = txtfield.placeholder
                let contStr = txtfield.text
                mutableContent.addEntries(from: [ "\(keyStr!)" : "\(contStr ?? "-")"])
                if contStr?.count == 0 {   notValid = true }
            }
        }
        
       
        let ToConvertTempoDict = (!Constants.MyNavi.updateInfo && CustView.isSignIn()) ? CustView.fillUpTempo() : Constants.MyNavi.TempoProfile
        let convertTempoDict = CustView.processTempoData(tempoData: ToConvertTempoDict)
        
        let contentMod : NSMutableDictionary = NSMutableDictionary.init(dictionary:convertTempoDict)
        print("--> BEFORE \(contentMod)")
   //     print("---> filled \(mutableContent)")
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
                "Address" : "address",
                "Country" : "country",
                "Email address" : "email",
                "Phone number" : "phone",
                "Postcode" : "postcode",
                "Suburb" : "suburb",
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
    
            
            
            Constants.MyNavi.CleanBufferRequest { (success) in
                if success {   self.ProcDivSubmit(content: mutableContent, profileInfo: contentMod)  }
                else
                {
                    Constants.MyNavi.Alertshow(title: "Unable to clear the buffer!", themessage: "", with: [])
                    
                }
            }
           
          //  self.ProcessSubmit(content: mutableContent, profileInfo: contentMod)
            
        }
        else
        {
            Constants.MyNavi.Alertshow(title: "Notice", themessage: "All fields are required.", with: [])
        }
    

     
    }
    
    //#####################################################################################################################################
    //#####################################################################################################################################
    @objc func tapDate(_ gesture: UITapGestureRecognizer)
    {

        self.view.endEditing(true)

        
        let dateformatter = DateFormatter.init()
        dateformatter.dateFormat = "yyyy"
        dateformatter.locale = NSLocale.current
        
        let stringCYear = dateformatter.string(from: Date.init())
          let yearArr = NSMutableArray.init()
        if let baseYear = Int(stringCYear)
        {
            for ctYYYY in 0..<50
            {
                yearArr.add("\(baseYear + ctYYYY)")
            }
        }
      
       
        let arrayList = gesture.view?.layer.name == "YYYY" ? yearArr : ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December" ]
        
        if arrayList.count > 0
        {
            Constants.MyNavi.Pickercreate(ArrayContents: arrayList) { (content, _) in
                if let currentTap = gesture.view, let textfield = currentTap.superview as? UITextField
                { textfield.text = "\(content)" }
            }
        }
    }
    
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
        
        if let cont = textField.text, ((textField.placeholder?.uppercased() == "YOUR FULL NAME") || (textField.placeholder?.uppercased() == "NAME ON CARD"))
        {
            textField.text = cont.firstUppercased
        }
        else if let postaltxt = textField.text, ((textField.placeholder?.uppercased() == "POSTCODE") || (textField.placeholder?.uppercased() == "PHONE NUMBER") || (textField.placeholder?.uppercased() == "CARD NUMBER") || (textField.placeholder?.uppercased() == "CCV"))
        {
        
            var digitSet = CharacterSet.decimalDigits
            if (textField.placeholder?.uppercased() == "PHONE NUMBER") { digitSet.insert(charactersIn:"/+*()-")  }
            let filteredName = String(postaltxt.unicodeScalars.filter { digitSet.contains($0) }).replacingOccurrences(of: " ", with: "")
            textField.text = filteredName
        }
        
        if textField.layer.name == "ignore"
        {
            textField.text = textField.text?.uppercased()
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        
        textField.text = CustView.hasWhitespace(string: textField.text)
        
        let thekb : CGFloat = CGFloat(Constants.DeviceProperty.KBHeight) + 10
        let thedifference : CGFloat  = Constants.DeviceProperty.devHeight - thekb
        let thealotment : CGFloat = (self.theScroll?.frame.origin.y)! + CustView.yObject(theview: textField) + (textField.superview!.frame.origin.y)
        
        UIView.animate(withDuration: 0.1, delay: 0.0, options: .curveEaseInOut, animations: {() -> Void in
            
            if (thedifference <= thealotment) {
                self.theScroll?.contentOffset = CGPoint(x:0, y:thealotment - thekb)
            }
            
        }, completion: {(finished: Bool) -> Void in
            
            
        })
        
        
        
        
    }

    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.text = CustView.hasWhitespace(string: textField.text)
        
        if let cont = textField.text, ((textField.placeholder?.uppercased() == "YOUR FULL NAME") || (textField.placeholder?.uppercased() == "NAME ON CARD"))
        {
            textField.text = cont.firstUppercased
        }
        else if let postaltxt = textField.text,((textField.placeholder?.uppercased() == "POSTCODE") || (textField.placeholder?.uppercased() == "PHONE NUMBER") || (textField.placeholder?.uppercased() == "CARD NUMBER") || (textField.placeholder?.uppercased() == "CCV"))
        {
            
            var digitSet = CharacterSet.decimalDigits
            if (textField.placeholder?.uppercased() == "PHONE NUMBER") { digitSet.insert(charactersIn:"/+*()-")  }
            let filteredName = String(postaltxt.unicodeScalars.filter { digitSet.contains($0) }).replacingOccurrences(of: " ", with: "")
            textField.text = filteredName
        }
        
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if ((textField.placeholder?.uppercased() == "CARD NUMBER") || (textField.placeholder?.uppercased() == "CCV"))
        {
            
            guard let text = textField.text else { return true }
            let count = text.count + string.count - range.length
            return count <= ((textField.placeholder?.uppercased() == "CARD NUMBER") ? 16 : 4)
        }
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    
    func ProcessSubmit(content:NSDictionary, profileInfo:NSDictionary)
    {

        var AddressStr = "-"
        
   
        if let AddressStrP = content["Address"] as? String {  AddressStr = AddressStrP  }
        let mutableMedia = NSMutableArray.init()
        
        if let arrImg = self.ContentSubmit["medias"] as? NSArray
        {
             for ximg in 0..<arrImg.count
             {
                if let uiimgFile = arrImg[ximg] as? UIImage
                {
                    if let imgadata = UIImageJPEGRepresentation(uiimgFile, 0.85)
                    {
                       
//                        let strBase64 = imgadata.base64EncodedString(options: .lineLength64Characters)
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
//                let strBase64 = dataVid.base64EncodedString(options: .lineLength64Characters)
                
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
        
        if let cnStr = content["Card number"] as? String { cardDit["card_number"] = cnStr  }
        if let nsStr = content["Name on card"] as? String { cardDit["card_name"] = nsStr  }
        if let yyyyStr = content["YYYY"] as? String { cardDit["expiry_yyyy"] = yyyyStr  }
        if let ccvStr = content["CCV"] as? String { cardDit["card_validation"] = ccvStr  }
        
        if let mmstr = content["Expiry date MM"] as? String {
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
        
        
        let submissionInfo = NSDictionary.init(dictionary: [
            "brand_preferences": "-",
            "notes": "-",
            "referral_code" : self.stringRefCode,
            "shipping_address": AddressStr,
            "items": mutableMedia,
            "card_details": cardDit
            ])

        
        let profileDict = NSMutableDictionary.init(dictionary:profileInfo )
        profileDict["submissions"] = [submissionInfo]
        
        if let dataProf = UserDefaults.standard.value(forKey: Constants.SaveKey.profile) as? Data, CustView.isSignIn() {
            if let profileParsed = CustView.UDDictionaryUnarchiver(AnyInput: dataProf)
            {
                if let profileID = profileParsed["id"] as? String {  profileDict["id"] = profileID }
            }
        }
        
        let contentSubmit = NSDictionary.init(dictionary: [
//           "username" : profileDict["email"]!,
//            "password" : "1234",
            "guest" : NSNumber.init(value: 0),
            "profiles" : [profileDict]
            ])
        
        let TestCheck = NSMutableDictionary.init(dictionary: submissionInfo)
        TestCheck.removeObject(forKey: "items")
        
        print("final submit \(TestCheck)")

        let request = CustView.RegisterCheck(tokenRequired: CustView.isSignIn() , dataTransfered: contentSubmit, theService:"user/", Method: "POST")
        Constants.MyNavi.webRequest(hasLoading: true, theRequest: request) { (respo, hasVal, errC) in
           print("---- profiles info \(respo)")
            if errC == 200
            {
                    var responseStr = "Unknown response."
                    let userDef = UserDefaults.standard
                    if let contentDict = respo as? NSDictionary
                    {
                        if let dataDict = contentDict["data"] as? NSDictionary
                        {
                            if let userDict = dataDict["user"] as? NSDictionary
                            {
                                if let profilesArr = userDict["profiles"] as? NSArray
                                {
                                    if let profilesDict = profilesArr.firstObject as? NSDictionary,  (profilesArr.count > 0)
                                    {
                                        //profile info

                                        let toStore = CustView.UDArchiver(AnyInput: profilesDict)
                                        userDef.set(toStore, forKey: Constants.SaveKey.profile)
                                    }

                                }
                            }

                            if let accestokenStr = dataDict["access_token"] as? String
                            {
                                Constants.MyNavi.AccessToken = accestokenStr
                                userDef.set(accestokenStr, forKey: Constants.SaveKey.token)

                            }




                            if let emailnot = dataDict["email_notifs"] as? NSArray
                            {
                                if emailnot.count > 0
                                {
                                    if let stringP = emailnot.firstObject as? String  {  responseStr = stringP }
                                }
                            }


                        }
                    }

                    userDef.synchronize()


                let theNext : CheckoutSuccess = self.navigationController?.storyboard!.instantiateViewController(withIdentifier: "CheckoutSuccess") as! CheckoutSuccess
                theNext.successString = responseStr
                Constants.MyNavi.goNextCrossFade(viewcontroller: theNext) { (_) in
                   Constants.MyNavi.referelCounter = 3
                }
            }
            else
            {
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
    
    @IBAction func ApplyCode(_ sender: UIButton) {
        self.view.endEditing(true)
        self.stringRefCode = ""
        if self.refTxtfield?.text != ""  {
            self.confirmReferral(content: ["code" : "\(self.refTxtfield?.text ?? "-")"], completion: {Response in
                
                if let dataDict = Response as? NSDictionary
                {
                    if let rate = dataDict["rate"] as? NSNumber
                    {
                        
                        let discountedPrice : Double = Double(self.priceTagString)! * (1.0 - rate.doubleValue)
                    
                    
                        let formatter = NumberFormatter()
                        formatter.minimumFractionDigits = 0
                        formatter.maximumFractionDigits = 0
    
                        formatter.numberStyle = .none
                        let stringpercent = formatter.string(from: NSNumber.init(value: rate.doubleValue * 100)) ?? "n/a"
                        
                        formatter.minimumFractionDigits = 2
                        formatter.maximumFractionDigits = 2
                        let pricestring = formatter.string(from: NSNumber.init(value: discountedPrice)) ?? "n/a"

                        self.dcpricelbl?.attributedText = self.pricetagAttribProc(String: pricestring, color: UIColor(netHex: 0x32C832))

                        self.dcprice?.isHidden = false
                        self.origprice?.isHidden = true
                        
                        Constants.MyNavi.referelCounter = 3
                        self.refCT?.isHidden = true
                        self.refTxtfield?.isEnabled = false
                        self.refTxtfield?.backgroundColor = .lightGray
                        sender.backgroundColor = UIColor.init(netHex: 0x5EC12A, a: 1.0)
                        sender.layer.borderColor = UIColor.clear.cgColor
                        sender.setTitleColor(.white, for: .normal)
                        sender.setTitle("\(stringpercent)% discount applied", for: .normal)
                        sender.isUserInteractionEnabled = false
                        
                        self.stringRefCode = (self.refTxtfield?.text)!
                        
                    }
                    else {  self.reduceRef() }
                }
                else if let _ = Response as? String
                {  self.reduceRef() }
            })
        }
        else {  Constants.MyNavi.Alertshow(title: "Empty Field", themessage: "", with: []) }
      
        
        
 

 
        
        
    }
    
    func reduceRef()
    {
        Constants.MyNavi.referelCounter-=1
        
        if Constants.MyNavi.referelCounter > 0
        {
            self.refCT?.text = "\(Constants.MyNavi.referelCounter)"
            let stringNo = Constants.MyNavi.referelCounter == 2 ? "Two" : "One"
            let dotstr = Constants.MyNavi.referelCounter == 1 ? "" : "s"
            self.refTxtfield?.text = ""
            Constants.MyNavi.Alertshow(title: "Incorrect code", themessage: "\(stringNo) more attempt\(dotstr).", with: [])
        }
        else
        {
            self.refCT?.isHidden = true
            self.refTxtfield?.isEnabled = false
            self.refTxtfield?.backgroundColor = .lightGray
            self.buttonApply?.backgroundColor = UIColor.init(netHex: 0x000000, a: 0.05)
             self.buttonApply?.layer.borderColor = UIColor.clear.cgColor
             self.buttonApply?.setTitleColor(UIColor.init(netHex: 0xff6a2b), for: .normal)
             self.buttonApply?.setTitle("Referrals disabled after 3 failed attempts", for: .normal)
             self.buttonApply?.isUserInteractionEnabled = false
        }
    }
    
    func confirmReferral(content:NSDictionary, completion:@escaping (Any?)->Void)
    {
        

        
        let request = CustView.RegisterCheck(tokenRequired:false, dataTransfered: content, theService:"referralCode/", Method: "POST")
        Constants.MyNavi.webRequest(hasLoading: true, theRequest: request) { (respo, hasVal, errC) in
            print("---- profiles info \(respo)")
            if errC == 200
            {
                if let contentDict = respo as? NSDictionary
                {  completion(contentDict["data"]) }
                else  {   completion(nil) }
            }
            else
            {
                
                completion(nil)
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

