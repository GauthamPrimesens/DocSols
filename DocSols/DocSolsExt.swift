//
//  DocSolsExt.swift
//  DocSolsM
//
//  Created by Jene Kirishima on 08/06/2018.
//  Copyright © 2018 Jene Kirishima. All rights reserved.
//

import Foundation
import UIKit

extension CustView {
    class func getPathby(ID:Int, container:CGRect)-> UIBezierPath
    {
        var lineFeet = UIBezierPath.init()
        
        switch ID {
        case 1: //Heels
            lineFeet = CustView.drawAnkleFoot(container: container)
            break
        case 2: //Knee
            lineFeet = CustView.drawstanceMode(container: container)
            break
        case 3: //Right Normal
            lineFeet = CustView.drawNormFoot(isRight: true, container: container)
            break
        case 4: //Right Normal Arc
            lineFeet = CustView.drawArcFoot(isRight: true, container: container)
            break
        case 5: //Left Normal
            lineFeet = CustView.drawNormFoot(isRight: false, container: container)
            break
        case 6: //Left Normal Arc
            lineFeet = CustView.drawArcFoot(isRight: false, container: container)
            break
        default:
            break
        }
        
        return lineFeet
    }
    
    
    class func drawAnkleFoot(container:CGRect)-> UIBezierPath
    {
        let xF : CGFloat = container.origin.x
        let yF : CGFloat = container.origin.y
        let wdthF : CGFloat = container.width
        let centerF : CGFloat = wdthF * 0.5
        let baseCenterGap : CGFloat = 35.0
        let feetGap : CGFloat = 65
        
        
        let floorBase : CGFloat = container.height -  Constants.cameraSubs.FloorHt
        let floorCoordY : CGFloat = floorBase + 10.0
        
        
        let lineFeet = UIBezierPath.init()
        
        
        //left
        lineFeet.move(to: CGPoint(x: xF + centerF - (baseCenterGap + feetGap), y: yF + floorCoordY - 145))
        
        lineFeet.addCurve(to: CGPoint(x: xF +  centerF - (baseCenterGap + feetGap - 5), y: yF + floorCoordY - 105),
                          controlPoint1: CGPoint(x:  xF +  centerF - (baseCenterGap + feetGap - 5), y: yF + floorCoordY - 125),
                          controlPoint2: CGPoint(x: xF +  centerF - (baseCenterGap + feetGap - 5), y: yF + floorCoordY - 125))
        
        lineFeet.addCurve(to: CGPoint(x: xF +   centerF - (baseCenterGap + feetGap), y: yF + floorCoordY - 35),
                          controlPoint1: CGPoint(x:  xF +   centerF - (baseCenterGap + feetGap - 10), y: yF + floorCoordY - 80),
                          controlPoint2: CGPoint(x: xF +   centerF - (baseCenterGap + feetGap + 5), y: yF + floorCoordY - 60))
        
        
        lineFeet.addCurve(to: CGPoint(x: xF +   centerF - (baseCenterGap + feetGap + 10), y: yF + floorCoordY),
                          controlPoint1: CGPoint(x:  xF +   centerF - (baseCenterGap + feetGap), y: yF + floorCoordY - 30),
                          controlPoint2: CGPoint(x: xF +   centerF - (baseCenterGap + feetGap + 15), y: yF + floorCoordY - 15))
        
        
        lineFeet.move(to: CGPoint(x: xF +  centerF - (baseCenterGap), y: yF + floorCoordY - 145))
        lineFeet.addCurve(to: CGPoint(x: xF + centerF - (baseCenterGap + 10), y: yF + floorCoordY - 50),
                          controlPoint1: CGPoint(x:  xF +  centerF - (baseCenterGap + 15), y: yF + floorCoordY - 95),
                          controlPoint2: CGPoint(x: xF +  centerF - (baseCenterGap + 5), y: yF + floorCoordY - 80))
        
        lineFeet.addCurve(to: CGPoint(x: xF +  centerF - (baseCenterGap + 10), y: yF + floorCoordY),
                          controlPoint1: CGPoint(x:  xF +  centerF - (baseCenterGap + 15), y: yF + floorCoordY - 30),
                          controlPoint2: CGPoint(x: xF +  centerF - (baseCenterGap + 5), y: yF + floorCoordY - 15))
        
        
        //right
        lineFeet.move(to: CGPoint(x: xF + centerF + (baseCenterGap + feetGap), y: yF + floorCoordY - 145))
        
        lineFeet.addCurve(to: CGPoint(x: xF +  centerF + (baseCenterGap + feetGap - 5), y: yF + floorCoordY - 105),
                          controlPoint1: CGPoint(x:  xF +  centerF + (baseCenterGap + feetGap - 5), y: yF + floorCoordY - 125),
                          controlPoint2: CGPoint(x: xF +  centerF + (baseCenterGap + feetGap - 5), y: yF + floorCoordY - 125))
        
        lineFeet.addCurve(to: CGPoint(x: xF +   centerF + (baseCenterGap + feetGap), y: yF + floorCoordY - 35),
                          controlPoint1: CGPoint(x:  xF + centerF + (baseCenterGap + feetGap - 10), y: yF + floorCoordY - 80),
                          controlPoint2: CGPoint(x: xF + centerF + (baseCenterGap + feetGap + 5), y: yF + floorCoordY - 60))
        
        
        lineFeet.addCurve(to: CGPoint(x: xF +   centerF + (baseCenterGap + feetGap + 10), y: yF + floorCoordY),
                          controlPoint1: CGPoint(x:  xF + centerF + (baseCenterGap + feetGap), y: yF + floorCoordY - 30),
                          controlPoint2: CGPoint(x: xF + centerF + (baseCenterGap + feetGap + 15), y: yF + floorCoordY - 15))
        
        
        lineFeet.move(to: CGPoint(x: xF +  centerF + (baseCenterGap), y: yF + floorCoordY - 145))
        lineFeet.addCurve(to: CGPoint(x: xF + centerF + (baseCenterGap + 10), y: yF + floorCoordY - 50),
                          controlPoint1: CGPoint(x:  xF + centerF + (baseCenterGap + 15), y: yF + floorCoordY - 95),
                          controlPoint2: CGPoint(x: xF + centerF + (baseCenterGap + 5), y: yF + floorCoordY - 80))
        
        lineFeet.addCurve(to: CGPoint(x: xF + centerF + (baseCenterGap + 10), y: yF + floorCoordY),
                          controlPoint1: CGPoint(x: xF + centerF + (baseCenterGap + 15), y: yF + floorCoordY - 30),
                          controlPoint2: CGPoint(x: xF + centerF + (baseCenterGap + 5), y: yF + floorCoordY - 15))
        return lineFeet
    }
    
    
    class func drawNormFoot(isRight :Bool, container:CGRect)-> UIBezierPath
    {
        let xF : CGFloat = container.origin.x
        let yF : CGFloat = container.origin.y
        let wdthF : CGFloat = container.width
        let centerF : CGFloat = wdthF * 0.5
        let baseCenterGap : CGFloat = 92.0
        let feetGap : CGFloat = 60
        
        
        let floorBase : CGFloat = container.height -  Constants.cameraSubs.FloorHt
        let floorCoordY : CGFloat = floorBase + 5.0
        
      //  let isLeft :Bool = true
        let isMult:CGFloat = isRight ? 1 : -1
        
        let lineFeet = UIBezierPath.init()
        lineFeet.move(to: CGPoint(x: xF +  centerF - (isMult*(baseCenterGap - 20)), y: yF + floorCoordY - 160))
        lineFeet.addLine(to: CGPoint(x: xF +  centerF - (isMult*(baseCenterGap - 25)), y: yF + floorCoordY - 95))
        lineFeet.addCurve(to: CGPoint(x: xF +  centerF - (isMult*(baseCenterGap - 20)), y: yF + floorCoordY),
                          controlPoint1: CGPoint(x:  xF +  centerF - (isMult*(baseCenterGap - 25)), y: yF + floorCoordY - 75),
                          controlPoint2: CGPoint(x: xF + centerF - (isMult*(baseCenterGap)), y: yF + floorCoordY - 20))
        
        
        lineFeet.move(to: CGPoint(x: xF + centerF - (isMult*(baseCenterGap - 20 - (feetGap))), y: yF + floorCoordY - 155))
        lineFeet.addCurve(to: CGPoint(x: xF +  centerF - (isMult*(baseCenterGap - 20 - (feetGap + 50))), y: yF + floorCoordY - 45),
                          controlPoint1: CGPoint(x:  xF + centerF - (isMult*(baseCenterGap - 20 - (feetGap + 5))), y: yF + floorCoordY - 90),
                          controlPoint2: CGPoint(x: xF + centerF - (isMult*(baseCenterGap - 20 - (feetGap + 5))), y: yF + floorCoordY - 70))
        lineFeet.addCurve(to: CGPoint(x: xF +  centerF - (isMult*(baseCenterGap - 20 - (feetGap + 105))), y: yF + floorCoordY - 15),
                          controlPoint1: CGPoint(x:  xF + centerF - (isMult*(baseCenterGap - 20 - (feetGap + 60))), y: yF + floorCoordY - 40),
                          controlPoint2: CGPoint(x: xF + centerF - (isMult*(baseCenterGap - 20 - (feetGap + 105))), y: yF + floorCoordY - 25))
        
        return lineFeet
    }
    
    
    class func drawArcFoot(isRight :Bool, container:CGRect)-> UIBezierPath
    {
        let xF : CGFloat = container.origin.x
        let yF : CGFloat = container.origin.y
        let wdthF : CGFloat = container.width
        let centerF : CGFloat = wdthF * 0.5
        let baseCenterGap : CGFloat = 92.0
        let feetGap : CGFloat = 60
        
        
        let floorBase : CGFloat = container.height -  Constants.cameraSubs.FloorHt
        let floorCoordY : CGFloat = floorBase + 5.0
        
        //let isLeft :Bool = false
        let isMult:CGFloat = isRight ? 1 : -1
        
        let lineFeet = UIBezierPath.init()
        lineFeet.move(to: CGPoint(x: xF +  centerF - (isMult*(baseCenterGap - 20)), y: yF + floorCoordY - 160))
        lineFeet.addLine(to: CGPoint(x: xF +  centerF - (isMult*(baseCenterGap - 25)), y: yF + floorCoordY - 95))
        lineFeet.addCurve(to: CGPoint(x: xF +  centerF - (isMult*(baseCenterGap - 20)), y: yF + floorCoordY),
                          controlPoint1: CGPoint(x:  xF +  centerF - (isMult*(baseCenterGap - 25)), y: yF + floorCoordY - 75),
                          controlPoint2: CGPoint(x: xF + centerF - (isMult*(baseCenterGap)), y: yF + floorCoordY - 20))
        
        
        lineFeet.move(to: CGPoint(x: xF + centerF - (isMult*(baseCenterGap - 20 - (feetGap))), y: yF + floorCoordY - 155))
        lineFeet.addCurve(to: CGPoint(x: xF +  centerF - (isMult*(baseCenterGap - 20 - (feetGap + 50))), y: yF + floorCoordY - 45),
                          controlPoint1: CGPoint(x:  xF + centerF - (isMult*(baseCenterGap - 20 - (feetGap + 5))), y: yF + floorCoordY - 90),
                          controlPoint2: CGPoint(x: xF + centerF - (isMult*(baseCenterGap - 20 - (feetGap + 5))), y: yF + floorCoordY - 70))
        
        
        lineFeet.addCurve(to: CGPoint(x: xF + centerF - (isMult*(baseCenterGap - 20 - (feetGap + 105))), y: yF + floorCoordY - 55),
                          controlPoint1: CGPoint(x:  xF +  centerF - (isMult*(baseCenterGap - 20 - (feetGap + 70))), y: yF + floorCoordY - 35),
                          controlPoint2: CGPoint(x: xF +  centerF - (isMult*(baseCenterGap - 20 - (feetGap + 80))), y: yF + floorCoordY - 35))
        
        return lineFeet
    }
    
    class func drawstanceMode(container:CGRect)-> UIBezierPath
    {
        let xF : CGFloat = container.origin.x
        let yF : CGFloat = container.origin.y
        let wdthF : CGFloat = container.width
        let centerF : CGFloat = wdthF * 0.5
        let baseCenterGap : CGFloat = 15.0
        let feetGap : CGFloat = 70
        
        
        let floorBase : CGFloat = container.height - Constants.cameraSubs.FloorHt
        let floorCoordY : CGFloat = floorBase - 20.0
        
        
        //NOTE: No floor basis yet. From bottom point (270) + 20px is the Line for the FLOOR
        
        
        
        let lineFeet = UIBezierPath.init()
        //right
        lineFeet.move(to: CGPoint(x: xF +  centerF - (baseCenterGap + feetGap), y: yF + (floorCoordY - 265)))
        lineFeet.addCurve(to: CGPoint(x: xF +  centerF - ((baseCenterGap + feetGap) - 15), y: yF + (floorCoordY - 50)),
                          controlPoint1: CGPoint(x:  xF +  centerF - ((baseCenterGap + feetGap) - 15), y: yF + (floorCoordY - 225)),
                          controlPoint2: CGPoint(x: xF +  centerF - ((baseCenterGap + feetGap) + 15), y: yF + (floorCoordY - 185)))
        
        lineFeet.addCurve(to: CGPoint(x:  xF +  centerF - ((baseCenterGap + feetGap) - 15), y: yF + floorCoordY) ,
                          controlPoint1: CGPoint(x:  xF +  centerF - ((baseCenterGap + feetGap) - 20), y: yF + (floorCoordY - 30)),
                          controlPoint2: CGPoint(x:  xF +  centerF - ((baseCenterGap + feetGap) - 20), y: yF + (floorCoordY - 30)))
        
        
        lineFeet.move(to: CGPoint(x: xF + centerF - (baseCenterGap), y: yF + (floorCoordY - 265)))
        lineFeet.addCurve(to: CGPoint(x: xF + centerF - (baseCenterGap + 10), y: yF + (floorCoordY - 150)),
                          controlPoint1: CGPoint(x: xF + centerF - (baseCenterGap), y: yF + (floorCoordY - 220)),
                          controlPoint2: CGPoint(x: xF + centerF - (baseCenterGap + 15), y: yF + (floorCoordY - 190)))
        
        lineFeet.addCurve(to: CGPoint(x: xF + centerF - (baseCenterGap + 15), y: yF + floorCoordY),
                          controlPoint1: CGPoint(x: xF + centerF - (baseCenterGap + 5), y: yF + (floorCoordY - 60)),
                          controlPoint2: CGPoint(x: xF + centerF - (baseCenterGap + 20), y: yF +  (floorCoordY - 50)))
        
        
        //left
        lineFeet.move(to: CGPoint(x: xF +  centerF + (baseCenterGap + feetGap), y: yF + (floorCoordY - 265)))
        lineFeet.addCurve(to: CGPoint(x: xF +  centerF + ((baseCenterGap + feetGap) - 15), y: yF + (floorCoordY - 50)),
                          controlPoint1: CGPoint(x:  xF +  centerF + ((baseCenterGap + feetGap) - 15), y: yF + (floorCoordY - 225)),
                          controlPoint2: CGPoint(x: xF +  centerF + ((baseCenterGap + feetGap) + 15), y: yF + (floorCoordY - 185)))
        
        lineFeet.addCurve(to: CGPoint(x:  xF +  centerF + ((baseCenterGap + feetGap) - 15), y: yF + floorCoordY) ,
                          controlPoint1: CGPoint(x:  xF +  centerF + ((baseCenterGap + feetGap) - 20), y: yF + (floorCoordY - 30)),
                          controlPoint2: CGPoint(x:  xF +  centerF + ((baseCenterGap + feetGap) - 20), y: yF + (floorCoordY - 30)))
        
        
        lineFeet.move(to: CGPoint(x: xF + centerF + (baseCenterGap), y: yF + (floorCoordY - 265)))
        lineFeet.addCurve(to: CGPoint(x: xF + centerF + (baseCenterGap + 10), y: yF + (floorCoordY - 150)),
                          controlPoint1: CGPoint(x: xF + centerF + (baseCenterGap), y: yF + (floorCoordY - 220)),
                          controlPoint2: CGPoint(x: xF + centerF + (baseCenterGap + 15), y: yF + (floorCoordY - 190)))
        
        lineFeet.addCurve(to: CGPoint(x: xF + centerF + (baseCenterGap + 15), y: yF + floorCoordY),
                          controlPoint1: CGPoint(x: xF + centerF + (baseCenterGap + 5), y: yF + (floorCoordY - 60)),
                          controlPoint2: CGPoint(x: xF + centerF + (baseCenterGap + 20), y: yF +  (floorCoordY - 50)))
        
        
        return lineFeet
    }
    
    
    class func processTempoFiles()->NSDictionary
    {
        
        let contentMod : NSMutableDictionary = NSMutableDictionary.init(dictionary:  [
            "full_name": "-",
            "email": "-",
            "phone": "0",
            "country": "-",
            "address": "-",
            "suburb": "-",
            "postcode": "0",
            "ailments" : "0",
            "age": "0",
            "gender": "0",
            "height": "0",
            "weight": "0",
            "foot_size": "0",
            "foot_size_unit": "0",
            "foot_size_gender" : "0",
            "foot_shape": "0",
            "shoe_type": "0",
            "shoe_colour": "black",
            "pain_areas": []
            ])
        
        let keysStr = ["gender", "height", "weight", "foot_size_unit", "foot_shape", "pain_areas", "age", "ailments", "foot_size",  "foot_size_gender"]
        
        for strKeys in keysStr
        {
            
            if let parsedString = Constants.MyNavi.TempoProfile[strKeys] as? String
            {
                if ((strKeys == "gender") || (strKeys == "foot_size_unit") || (strKeys == "foot_shape"))
                {
                    var strVal = NSNumber.init(value: 0)
                    let contentKeyString = parsedString.uppercased()
                    
                    switch contentKeyString
                    {
                    case "FEMALE", "UK", "WIDE":
                        strVal = NSNumber.init(value:1)
                        break
                    case "NARROW", "EUR":
                        strVal = NSNumber.init(value:2)
                        break
                    default:
                        break
                    }
                    
                    contentMod[strKeys] = strVal
                }
                else { contentMod[strKeys] = parsedString }
                
            }
            else if let parsedArray = Constants.MyNavi.TempoProfile[strKeys] as? NSArray  {  contentMod[strKeys] = parsedArray  }
            else if let parsedNum = Constants.MyNavi.TempoProfile[strKeys] as? NSNumber {  contentMod[strKeys] = parsedNum }
            
            
        }
        
        
        return contentMod
    }
    
    class func processTempoData(tempoData:NSDictionary)->NSDictionary
    {
        
        let contentMod : NSMutableDictionary = NSMutableDictionary.init(dictionary:  [
            "full_name": "-",
            "email": "-",
            "phone": "0",
            "country": "-",
            "address": "-",
            "suburb": "-",
            "postcode": "0",
            "ailments" : "0",
            "age": "0",
            "gender": "0",
            "height": "0",
            "weight": "0",
            "foot_size": "0",
            "foot_size_unit": "0",
            "foot_size_gender" : "0",
            "foot_shape": "0",
            "shoe_type": "0",
            "shoe_colour": "black",
            "pain_areas": []
            ])
        
        let keysStr = ["gender", "height", "weight", "foot_size_unit", "foot_shape", "pain_areas", "age", "ailments", "foot_size", "foot_size_gender"]
        
        for strKeys in keysStr
        {
            
            if let parsedString = tempoData[strKeys] as? String
            {
                if ((strKeys == "gender") || (strKeys == "foot_size_unit") || (strKeys == "foot_shape"))
                {
                    var strVal = NSNumber.init(value: 0)
                    let contentKeyString = parsedString.uppercased()
                    
                    switch contentKeyString
                    {
                    case "FEMALE", "UK", "WIDE":
                        strVal = NSNumber.init(value:1)
                        break
                    case "NARROW", "EUR":
                         strVal = NSNumber.init(value:2)
                        break
                    default:
                        break
                    }
                    
                    contentMod[strKeys] = strVal
                }
                else { contentMod[strKeys] = parsedString }

            }
            else if let parsedArray = tempoData[strKeys] as? NSArray  {  contentMod[strKeys] = parsedArray  }
            else if let parsedNum = tempoData[strKeys] as? NSNumber {  contentMod[strKeys] = parsedNum }

        }
        
        
        return contentMod
    }
}
