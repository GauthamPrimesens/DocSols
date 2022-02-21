//
//  AppCore.swift
//  Custom Zero Plug-in
//
//  Created by Jene Kirishima on 19/07/2016.
//  Copyright © 2016 Fresh Mktg. All rights reserved.
//

import Foundation
import UIKit


extension UIImage {
    func maskWithColor(color: UIColor) -> UIImage? {
        
        let maskImage = self.cgImage
        let width = self.size.width
        let height = self.size.height
        let bounds = CGRect(x: 0, y: 0, width: width, height: height)
        
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedLast.rawValue)
        let bitmapContext = CGContext(data: nil, width: Int(width), height: Int(height), bitsPerComponent: 8, bytesPerRow: 0, space: colorSpace, bitmapInfo: bitmapInfo.rawValue) //needs rawValue of bitmapInfo
        
        bitmapContext!.clip(to: bounds, mask: maskImage!)
        bitmapContext!.setFillColor(color.cgColor)
        bitmapContext!.fill(bounds)
        
        //is it nil?
        if let cImage = bitmapContext!.makeImage() {
            let coloredImage = UIImage(cgImage: cImage)
            
            return coloredImage
            
        } else {
            return nil
        } 
    }
}

extension NSAttributedString {
    convenience init(html:String) throws {
        guard let data = html.data(using: String.Encoding.utf8) else {
            throw NSError(domain: "Invalid HTML", code: -500, userInfo: nil)
        }
        
        let options = [NSAttributedString.DocumentAttributeKey.documentType.rawValue : NSAttributedString.DocumentType.html, NSAttributedString.DocumentAttributeKey.characterEncoding: NSNumber(value:String.Encoding.utf8.rawValue)] as [AnyHashable : Any]
        try self.init(data: data, options: options as! [NSAttributedString.DocumentReadingOptionKey : Any], documentAttributes: nil)
    }
}

extension CustView {
    class func updateBufferToDelete(id:String)
    {
        let userDef = UserDefaults.standard
        if let currentArray = userDef.value(forKey: Constants.SaveKey.errorIDs) as? NSMutableArray, (currentArray.count > 0)
        {
            let nextupdate = NSMutableArray.init(array: currentArray)
            if !currentArray.contains(id) { nextupdate.add(id) }
            
            userDef.setValue(nextupdate, forKey: Constants.SaveKey.errorIDs)
        }
        else
        {
            let nextupdate = NSMutableArray.init(array: [id])
            userDef.setValue(nextupdate, forKey: Constants.SaveKey.errorIDs)
        }
        
        userDef.synchronize()
    
    }
    
    
    class func fillUpTempo()->NSDictionary
    {
        let contentReturn = NSMutableDictionary.init(dictionary:
            [
            "age" : "1",
            "ailments" : "0",
            "foot_size_gender" : NSNumber.init(value: 2),
            "foot_shape" : "Standard",
            "foot_size" : "0",
            "foot_size_unit" : "US",
            "gender" : "Male",
            "pain_areas" : [],
            "weight" : "1"
            ])
        
        if let dataProf = UserDefaults.standard.value(forKey: Constants.SaveKey.profile) as? Data {
            if let profileDict = CustView.UDDictionaryUnarchiver(AnyInput: dataProf)
            {
                print("xxxx -> \(profileDict)")
                let newPain = NSMutableArray.init()
                if let painAreas = profileDict["pain_areas"] as? [NSDictionary]
                {
                    for perPain in painAreas
                    {
                        let mutaDict = NSMutableDictionary.init(dictionary: perPain)
                        mutaDict.removeObject(forKey: "id")
                        
                        newPain.add(mutaDict)
                    }
                    
                }
                
                contentReturn["pain_areas"] = newPain
                
                
                let keyPassArr = [
                    "age",
                    "foot_size",
                    "ailments",
                    "foot_shape",
                    "foot_size_unit",
                    "foot_size_gender",
                    "gender",
                    "weight"
                ]
                
                for keyStr in keyPassArr
                {
                    if let proCont = profileDict[keyStr] as? NSNumber
                    {
                        if proCont.intValue != 0
                        {
                            
                            var contentStore = "\(proCont.intValue)"
                            switch keyStr
                            {
                            case "foot_size_unit":
                                contentStore = proCont.intValue > 1 ? "EUR" : "UK"
                                break
                            case "foot_shape":
                                contentStore = proCont.intValue > 1 ? "Narrow" : "Wide"
                                break
                            case "gender":
                                contentStore = "Female"
                                break
                            default:
                                break
                                
                            }
                         
                            contentReturn[keyStr] = contentStore
                        }
                    }
                }
                
                
            }
        }
        /*
         age = "24 yo";
         ailments = 0;
         "foot_shape" = Wide;
         "foot_size" = "KID 2.5";
         "foot_size_unit" = US;
         gender = Female;
         "pain_areas" =     (
         {
         "foot_area" = 1;
         location = 0;
         },
         {
         "foot_area" = 2;
         location = 0;
         },
         {
         "foot_area" = 3;
         location = 0;
         },
         {
         "foot_area" = 4;
         location = 0;
         }
         );
         weight = "101 kg";

         */
        
        /*
         age = 28;
         ailments = 0;
         "foot_shape" = 1;
         "foot_size" = "2.5";
         "foot_size_unit" = 0;
         gender = 1;
         "kid_size" = 1;
         weight = 83;
         */
        
        return contentReturn
    }
    
    
    class func UDArchiver(AnyInput:Any) -> Data
    {
        let dataToSave: Data = NSKeyedArchiver.archivedData(withRootObject: AnyInput)
        return dataToSave
    }
    
    class func UDDictionaryUnarchiver(AnyInput:Any) -> NSDictionary?
    {
        if let anyInputData : Data = AnyInput as? Data {
            if let DictFromData = NSKeyedUnarchiver.unarchiveObject(with:anyInputData) as? NSDictionary {  return DictFromData }
        }
        
        return nil
    }
    
    

    class func validateEmail(enteredEmail:String) -> Bool {
        
        let emailFormat = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailFormat)
        return emailPredicate.evaluate(with: enteredEmail)
    }

    
    class func isSignIn()->Bool
    {
        var tSignStat = false
        
        let userDef = UserDefaults.standard
       // if (userDef.value(forKey: Constants.SaveKey.profile) as? NSDictionary) != nil {  tSignStat = true }
        if let accsasve = userDef.value(forKey: Constants.SaveKey.token) as? String, let dataProf = userDef.value(forKey: Constants.SaveKey.profile) as? Data {
            if CustView.UDDictionaryUnarchiver(AnyInput: dataProf) != nil
            {
                tSignStat = true
                Constants.MyNavi.AccessToken = accsasve
            }
        }

        return tSignStat
    }
    
    class func SaveProfile(name:String)
    {
        let userDef = UserDefaults.standard
        let contentDict = NSMutableDictionary.init(dictionary: Constants.MyNavi.TempoProfile)
        contentDict["full_name"] = name
        
        userDef.setValue(contentDict, forKey: Constants.SaveKey.profile)
        userDef.synchronize()
    }
    
    
    class func SaveAllProfile(Dictionary:NSDictionary)
    {
        let userDef = UserDefaults.standard
        if Dictionary.allKeys.count > 0
        {
            userDef.setValue(Dictionary, forKey: Constants.SaveKey.profile)
            userDef.synchronize()
        }
        
       
    }
    
    class func SignOut()
    {
        Constants.MyNavi.TempoProfile = NSDictionary.init()
        Constants.MyNavi.TempoScans = NSArray.init()
        Constants.MyNavi.updateInfo = false
        let userDef = UserDefaults.standard
    

        userDef.removeObject(forKey: Constants.SaveKey.scans)
        userDef.removeObject(forKey: Constants.SaveKey.profile)
        Constants.MyNavi.AccessToken = "-"
        userDef.removeObject(forKey: Constants.SaveKey.token)
        userDef.synchronize()
    }
    
    class func saveScans(scans:NSArray)
    {
        if scans.count > 0
        {
           
            
            let mutableArry = NSMutableArray()
            for unknown in scans
            {
                if let newImage = unknown as? UIImage
                {
                    if let newData = UIImageJPEGRepresentation(newImage, 1.0)
                    {
                         mutableArry.add(newData)
                    }
                   
                }
            }
            
            if mutableArry.count > 0
            {
              //  Constants.MyNavi.updateInfo = false
                
                let userDef = UserDefaults.standard
                userDef.setValue(mutableArry, forKey: Constants.SaveKey.scans)
                userDef.synchronize()
            }
      
        }
    }
    
    
    class func imageCrop(theImage:UIImage, with rect:CGRect)->UIImage
    {

        let imageRef = theImage.cgImage?.cropping(to: rect)
        let image = UIImage(cgImage: imageRef!, scale:1.0, orientation: theImage.imageOrientation)
        
        return image
    }
    
    
    
    class func shuffleArr(theArray:NSArray)-> NSArray
    {
        let mutabShuffled = NSMutableArray.init()
        if theArray.count > 1
        {
            var MuCol = [0]
            for x in (1..<theArray.count)
            { MuCol.append(x) }
            
            MuCol.shuffleArr()
            
            for shX in (0..<MuCol.count)
            {
                let Shuffled_index = MuCol[shX]
                if (Shuffled_index < theArray.count)  { mutabShuffled.add(theArray[Shuffled_index]) }
 
                
            }
            
        }
        else {  mutabShuffled.setArray(theArray as! [Any])  }
   

        
        return mutabShuffled
    }
    
    class func Radianfrom(degrees:Double) -> Double
    {
        return ((degrees * .pi ) / 180)
    }
    

    class func imageNamer(thedate:NSDate)->String {
        let dateformatter = DateFormatter.init()
        dateformatter.dateFormat = "ddMMyyyyHHmmss"
        dateformatter.locale = NSLocale.current
        
        return String(format:"IMG%@_%@", arguments:[(UIDevice.current.identifierForVendor?.uuidString)!, dateformatter.string(from: thedate as Date)]).uppercased()
    }
    
//    class func DateToDay(thedate:NSDate)->String {
//        let dateformatter = NSDateFormatter.init()
//        dateformatter.dateFormat = "EEEE"
//        dateformatter.locale = NSLocale.currentLocale()
//        
//        return dateformatter.stringFromDate(thedate)
//    }
//    
//    class func DateToTime(thedate:NSDate)->String {
//        let dateformatter = NSDateFormatter.init()
//        dateformatter.dateFormat = "HH:mm"
//        dateformatter.locale = NSLocale.currentLocale()
//        
//        return dateformatter.stringFromDate(thedate)
//    }
//    
//    class func DateToJustDate(thedate:NSDate)->String {
//        let dateformatter = NSDateFormatter.init()
//        dateformatter.dateFormat = "MM-dd-yyyy"
//        dateformatter.locale = NSLocale.currentLocale()
//        
//        return dateformatter.stringFromDate(thedate)
//    }
//    


    //#########################################################################################################################
    
    //#########################################################################################################################
    class func OAbuttoncreate(txtlbl : String, completion:@escaping ()->Void) -> ActionButton
    {
        let OaButton : ActionButton = ActionButton.init()
        OaButton.CreateButtonName(title: txtlbl, completion: completion)
        return OaButton
    }
    
    //#########################################################################################################################
    
    //#########################################################################################################################
    class func createArrow(rect:CGRect, direction:Arrow_Layer, color:UIColor, lineWidth:CGFloat)->CAShapeLayer
    {
        let Ax = rect.origin.x
        let Ay = rect.origin.y
        let Aw = rect.size.width
        let Ah = rect.size.height
        
        let baseArc = UIBezierPath.init()
        
        
        switch direction {
        case .right:
            baseArc.move(to:CGPoint(x:Ax,y:Ay))
            baseArc.addLine(to:CGPoint(x:Ax + Aw,y:Ay + (Ah/2.0)))
            baseArc.addLine(to:CGPoint(x:Ax, y:Ay + Ah))
            
            break
        case .left:
            baseArc.move(to:CGPoint(x:Ax + Aw,y:Ay))
            baseArc.addLine(to:CGPoint(x:Ax,y:Ay + (Ah/2.0)))
            baseArc.addLine(to:CGPoint(x:Ax + Aw, y:Ay + Ah))
            break
        case .up:
            baseArc.move(to:CGPoint(x:Ax, y:Ay + Ah))
            baseArc.addLine(to:CGPoint(x:Ax + (Aw/2.0),y:Ay))
            baseArc.addLine(to:CGPoint(x:Ax + Aw, y:Ay + Ah))
            break
        default:
            baseArc.move(to:CGPoint(x:Ax, y:Ay))
            baseArc.addLine(to:CGPoint(x:Ax + (Aw/2.0),y: Ay + Ah))
            baseArc.addLine(to:CGPoint(x:Ax + Aw, y:Ay))
            break
        }
        
        let baselayer = CAShapeLayer.init()
        baselayer.path = baseArc.cgPath
        baselayer.strokeColor = color.cgColor
        baselayer.lineWidth = lineWidth
        baselayer.fillColor = UIColor.clear.cgColor
        baselayer.lineCap = kCALineJoinRound
        
        return baselayer
    }
    
    
    class func yObject(theview:UIView) -> CGFloat {
        return theview.frame.size.height + theview.frame.origin.y
    }
    
    class func xObject(theview:UIView) -> CGFloat {
        return theview.frame.size.width + theview.frame.origin.x
    }
    
    
    class func statLabel(rect:CGRect, attStr:NSAttributedString) -> UILabel
    {
        let thelabel : UILabel = UILabel.init(frame: rect)
        thelabel.backgroundColor = UIColor.clear
        thelabel.numberOfLines = 0
        thelabel.lineBreakMode = .byWordWrapping
        thelabel.attributedText = attStr
        
        return thelabel
    }
    
    
    class func statTxtView(rect:CGRect, attStr:NSAttributedString) -> UITextView
    {
        let thetxtV : UITextView = UITextView.init(frame: rect)
        thetxtV.backgroundColor = UIColor.clear
        thetxtV.attributedText = attStr
        thetxtV.isScrollEnabled = false
        thetxtV.isEditable = false
        thetxtV.isSelectable = false
        thetxtV.isUserInteractionEnabled = false
        thetxtV.bounces = false
        thetxtV.showsVerticalScrollIndicator = false
        thetxtV.showsHorizontalScrollIndicator = false
        
        return thetxtV
    }
    
    
    class func getAttributeDict(fontName: String, alignment Falignment: NSTextAlignment, size FSize: CGFloat, color Fcolor: UIColor) -> [NSAttributedStringKey : Any] {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = Falignment
        paragraphStyle.lineBreakMode = NSLineBreakMode.byWordWrapping
        let attributesDefault: [NSAttributedStringKey : Any] = [NSAttributedStringKey(rawValue: NSAttributedStringKey.backgroundColor.rawValue): UIColor.clear, NSAttributedStringKey(rawValue: NSAttributedStringKey.foregroundColor.rawValue): Fcolor, NSAttributedStringKey.font: UIFont(name: fontName, size: FSize)!, NSAttributedStringKey.paragraphStyle: paragraphStyle]
        return attributesDefault
    }
    
    class func fitFontFromContainer(containerSize:CGFloat, maxFontSize:CGFloat, Attributes:[NSAttributedStringKey : Any], Content:String)->NSAttributedString
    {
        var fontsize : CGFloat = maxFontSize
        
        var theAttN = Attributes
        var theAttStrN = NSAttributedString(string:Content, attributes: theAttN )
        var theSize : CGRect = theAttStrN.boundingRect(with: CGSize(width:CGFloat.greatestFiniteMagnitude, height: containerSize), options: [.usesLineFragmentOrigin, .usesFontLeading], context: nil)
        while (theSize.height > containerSize) {
            fontsize-=1.0
            let mutableDict = NSMutableDictionary.init(dictionary: theAttN)
            if let theFont : UIFont = mutableDict[NSAttributedStringKey.font] as? UIFont
            { mutableDict[NSAttributedStringKey.font] =  UIFont(name: theFont.fontName, size: fontsize) }
            
            theAttN = mutableDict as! [NSAttributedStringKey : Any]
            theAttStrN = NSAttributedString(string:Content, attributes: theAttN )
            theSize = theAttStrN.boundingRect(with: CGSize(width:CGFloat.greatestFiniteMagnitude, height: containerSize), options: [.usesLineFragmentOrigin, .usesFontLeading], context: nil)
        }
        
        return theAttStrN
    }
    
    class func addGradient(colorArray:NSArray, maxContainer:CGSize, Attributes:[NSAttributedStringKey : Any], Content:String)->NSAttributedString
    {
        
        var theAttN = Attributes
        var theAttStrN = NSAttributedString(string:Content, attributes: theAttN )

        
        let gradientView = UIView.init(frame:  CGRect(x:-2.0,  y:  0, width:maxContainer.width + 4.0, height:maxContainer.height))
        let gradientLayer:CAGradientLayer = CAGradientLayer()
        gradientLayer.frame.size = gradientView.frame.size
        gradientLayer.colors = colorArray as? [Any]
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 1.0)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 1.0)
        gradientView.layer.addSublayer(gradientLayer)
        
        let gradientImg = UIImage.init(view: gradientView)
        
        let mutableDictUp = NSMutableDictionary.init(dictionary: theAttN)
        mutableDictUp[NSAttributedStringKey(rawValue: NSAttributedStringKey.foregroundColor.rawValue)] = UIColor(patternImage: gradientImg)
        
        let shadowAdd = NSShadow.init()
        shadowAdd.shadowOffset = CGSize.zero
        shadowAdd.shadowBlurRadius = 10.0
        shadowAdd.shadowColor = UIColor.init(cgColor: colorArray.firstObject as! CGColor)
        mutableDictUp[NSAttributedStringKey.shadow] = shadowAdd
        mutableDictUp[NSAttributedStringKey.strokeWidth] = -1.0
        mutableDictUp[NSAttributedStringKey.strokeColor] = UIColor.init(cgColor: colorArray.firstObject as! CGColor)
        
      
        theAttN = mutableDictUp as! [NSAttributedStringKey : Any]
        theAttStrN = NSAttributedString(string:Content, attributes: theAttN )
        
        return theAttStrN
    }
    
    class func getResizeableAtt(initFS:CGFloat, stringTxt:String, fontName:String, alignment:NSTextAlignment, color:UIColor, limitbound:CGSize) -> NSAttributedString
    {
        var initialSize : CGFloat = initFS
        let theAttS  = CustView.getAttributeDict(fontName: fontName, alignment:alignment, size: initialSize, color:color)
        
        var text1Att = NSAttributedString.init(string:stringTxt, attributes: theAttS)
        let wDframe = limitbound.width
        let hDframe = limitbound.height
        var theSize : CGRect = text1Att.boundingRect(with: CGSize(width: wDframe, height:CGFloat.greatestFiniteMagnitude), options: [.usesLineFragmentOrigin, .usesFontLeading], context: nil)
        while (theSize.size.height > hDframe)
        {
            initialSize -= 1
            let theAttSex  = CustView.getAttributeDict(fontName: fontName, alignment:alignment, size: initialSize, color:color)
            text1Att = NSAttributedString.init(string:stringTxt, attributes: theAttSex)
            theSize = text1Att.boundingRect(with: CGSize(width: wDframe, height:CGFloat.greatestFiniteMagnitude), options: [.usesLineFragmentOrigin, .usesFontLeading], context: nil)
            
        }
        
        
        return text1Att
    }
    
    class func getFontSizeFor(containerSize:CGFloat, maxFontSize:CGFloat, Attributes:[NSAttributedStringKey : Any])->CGFloat
    {
        var fontsize : CGFloat = maxFontSize
        
        var theAttN = Attributes
        var theAttStrN = NSAttributedString(string:"W", attributes: theAttN )
        var theSize : CGRect = theAttStrN.boundingRect(with: CGSize(width:CGFloat.greatestFiniteMagnitude, height: containerSize), options: [.usesLineFragmentOrigin, .usesFontLeading], context: nil)
        while (theSize.height > containerSize) {
            fontsize-=1.0
            let mutableDict = NSMutableDictionary.init(dictionary: theAttN)
            if let theFont : UIFont = mutableDict[NSAttributedStringKey.font] as? UIFont
            { mutableDict[NSAttributedStringKey.font] =  UIFont(name: theFont.fontName, size: fontsize) }
            
            theAttN = mutableDict as! [NSAttributedStringKey : Any]
            theAttStrN = NSAttributedString(string:"W", attributes: theAttN )
            theSize = theAttStrN.boundingRect(with: CGSize(width:CGFloat.greatestFiniteMagnitude, height: containerSize), options: [.usesLineFragmentOrigin, .usesFontLeading], context: nil)
        }
        
       return fontsize
    }
    
    
    class func AttStringwithImage(theImage:UIImage, Astring:NSAttributedString) -> NSAttributedString
    {
        let theMUTA : NSMutableAttributedString = NSMutableAttributedString.init(attributedString: Astring)
        let txtAtt = NSTextAttachment.init()
        txtAtt.image = theImage
        let attSTR = NSAttributedString.init(attachment: txtAtt)
        
        theMUTA.append(attSTR)
        
        return theMUTA;
    }
    
    class func AttStringwithImage(theImage:UIImage, att:[NSAttributedStringKey : Any], string:String) -> NSAttributedString
    {
        let theMUTA : NSMutableAttributedString = NSMutableAttributedString.init(string: string, attributes: att)
        let thefont = att[NSAttributedStringKey.font]
        
        
        
        let txtAtt = NSTextAttachment.init()
        txtAtt.image = theImage
        let switchRatio = (thefont! as AnyObject).pointSize * (txtAtt.image!.size.width / txtAtt.image!.size.height)
        
        txtAtt.bounds = CGRect(x: 0, y: (thefont! as AnyObject).descender, width: switchRatio, height: (thefont! as AnyObject).pointSize)
        let attSTR = NSAttributedString.init(attachment: txtAtt)
        theMUTA.append(attSTR)
//        print(thefont!.descender, thefont!.capHeight, thefont!.pointSize, thefont!.xHeight, txtAtt.image!.size.width, txtAtt.image!.size.height, switchRatio)

        return theMUTA;
    }
    
    
    
    
    
    class func splitFromStr(stringO:String, with startString:String, endString:String)->String
    {
        
        let startRange = stringO.range(of: startString)
        if startRange != nil {
            let FirstRange : Range = (startRange?.upperBound)!..<stringO.endIndex
            let firstCut = String(stringO[FirstRange])
            // let firstCut = stringO.substring(with: FirstRange)
            let EndRange = firstCut.range(of: endString)
            if EndRange != nil {
                let SecondRange : Range = firstCut.startIndex..<EndRange!.lowerBound
                 let finalCut = String(firstCut[SecondRange])
              //  let finalCut = firstCut.substring(with: SecondRange)
                
                return finalCut
            }
            
        }
        
        return ""
    }
    
    
    class func hasWhitespace(string : String?) -> String
    {
        if (string != nil) {
            var exSt = string!
            while ((exSt.hasPrefix(" ")) || (exSt.hasPrefix("\n"))) {
                let curInd = exSt.startIndex
                exSt = String(exSt[exSt.index(after: curInd)...])
              //  exSt = exSt.substring(from: exSt.index(after: curInd))
            
            }
            
            while ((exSt.hasSuffix(" ")) || (exSt.hasSuffix("\n"))) {
                let curInd = exSt.endIndex
                 exSt = String(exSt[..<exSt.index(before: curInd)])
               // exSt = exSt.substring(to: exSt.index(before: curInd))
            }
            
            return exSt
        }
        
        
        return ""
    }
    

    class func createShape(fromPoints:NSArray, color:UIColor, lineWidth:CGFloat)->CAShapeLayer
    {
        let baseShape = UIBezierPath.init()
        for x in (0..<fromPoints.count)
        {
            
            if let thisPoint = (fromPoints[x] as AnyObject).cgPointValue
            {
                if x == 0 { baseShape.move(to:thisPoint)  }
                else { baseShape.addLine(to: thisPoint) }
            }
            
        }
        
        baseShape.close()
        
        let baselayer = CAShapeLayer.init()
        baselayer.path = baseShape.cgPath
        baselayer.strokeColor = color.cgColor
        baselayer.lineWidth = lineWidth
        baselayer.fillColor = UIColor.clear.cgColor
        baselayer.lineCap = kCALineCapButt
        
        return baselayer
    }

    
    class func UnixDateConverterStr(thedate:NSDate)-> String {
        let dateformatter = DateFormatter.init()
        dateformatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZ"
        //dateformatter.locale = NSLocale.current
        let timezone : NSTimeZone = NSTimeZone.init(name: "UTC")!
        dateformatter.timeZone = timezone as TimeZone?
        
        let thenewDate = dateformatter.string(from: thedate as Date)
        
        return thenewDate
    }
    
    class func UnixDateConverterStrAU(thedate:NSDate)-> String {
        let dateformatter = DateFormatter.init()
        dateformatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZ"
        //dateformatter.locale = NSLocale.current
        let timezone : NSTimeZone = NSTimeZone.init(name: "Australia/Melbourne")!
        dateformatter.timeZone = timezone as TimeZone?
        
        let thenewDate = dateformatter.string(from: thedate as Date)
        
        return thenewDate
    }
    
    class func AUTimeFileNamer(thedate:NSDate)-> String {
        let dateformatter = DateFormatter.init()
        dateformatter.dateFormat = "yyyyMMdd'T'HHmmss"
        //dateformatter.locale = NSLocale.current
        let timezone : NSTimeZone = NSTimeZone.init(name: "Australia/Melbourne")!
        dateformatter.timeZone = timezone as TimeZone?
        
        let thenewDate = dateformatter.string(from: thedate as Date)
        
        return thenewDate
    }
    
    class func UTCToLocal(date:String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSSSSS"
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        
        guard let dt = dateFormatter.date(from: date) else { return "-" }
        
        let dateFormatterStr = DateFormatter()
        dateFormatterStr.timeZone = TimeZone.current
        dateFormatterStr.dateFormat = "dd/MM/yyyy\nhh:mm a"
        
        let stringResponse = dateFormatterStr.string(from: dt)
        
        return stringResponse
    }
   
    
    class func saveImageToDocumentDirectory(DIRpath:URL, filename:String, chosenImage: UIImage, quality:CGFloat) -> String {
   
        let filepath = DIRpath.appendingPathComponent(filename)
        do {
            try UIImageJPEGRepresentation(chosenImage, quality)?.write(to: filepath, options: .atomic)
            return String.init("\(filepath.path)")
            
        } catch {
            print(error)
            print("file cant not be save at path \(filepath), with error : \(error)");
            return filepath.path
        }
    }
    
    class func recreateFolder() -> URL
    {
        let filemngr = FileManager.default
        let documentsPath1 = NSURL(fileURLWithPath: NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0])
        let logsPath = documentsPath1.appendingPathComponent("DolSols")
        print(logsPath!)
        
        var isDir : ObjCBool = false
        if filemngr.fileExists(atPath: (logsPath?.path)!, isDirectory:&isDir) {
            print(isDir.boolValue ? "Directory exists" : "File exists")
            
            do {
                try  filemngr.removeItem(atPath: (logsPath?.path)!)
            } catch let error as NSError {  NSLog("Unable to create directory \(error.debugDescription)") }
        } else {
            print("File does not exist")
        }
        
        
        
        do {
            try filemngr.createDirectory(atPath: logsPath!.path, withIntermediateDirectories: true, attributes: nil)
        } catch let error as NSError {
            NSLog("Unable to create directory \(error.debugDescription)")
        }
        
        return logsPath!
    }
    
    
    
    //#########################################################################################################################
    //#########################################################################################################################
    class func RegisterCheck(tokenRequired:Bool, dataTransfered: Any?, theService extSvc: String, Method:String) -> NSMutableURLRequest {
        
        var varURLStr: String =  Constants.webSvc.baseApi
        #if LIVE
        varURLStr = Constants.webSvc.liveApi
        #endif
        
       
        
        let urlString: String = varURLStr + extSvc
         print("websvc---> \(urlString)")
        let escapedUrl: String = urlString.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlFragmentAllowed)!
        
        
        
        let request: NSMutableURLRequest = NSMutableURLRequest()
        if dataTransfered != nil {
            do {
                request.httpBody = try JSONSerialization.data(withJSONObject: dataTransfered!, options:[])
            } catch {
                print("ERROR RegisterCheck")
                
            }
        }
        request.url = NSURL(string: escapedUrl)! as URL
        request.httpMethod = Method
        request.setValue("application/json", forHTTPHeaderField:"Content-Type")
        if tokenRequired == true {
            //let tokenStrHEx = Constants.GTab.AccessToken.uppercased().hasPrefix("PENDING") ? Constants.GTab.RefreshToken : Constants.GTab.AccessToken
            print("token plugs \(Constants.MyNavi.AccessToken)")
            request.setValue("Bearer \(Constants.MyNavi.AccessToken)", forHTTPHeaderField:"Authorization")
        }
        
        
        return request
    }
}


