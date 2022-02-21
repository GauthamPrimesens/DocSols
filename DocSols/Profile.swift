//
//  Profile.swift
//  DocSolsM
//
//  Created by Jene Kirishima on 13/06/2018.
//  Copyright © 2018 Jene Kirishima. All rights reserved.
//

import Foundation
import UIKit

class Profile_Screen: CustView,  UITableViewDelegate, UITableViewDataSource
{
    
    let cellsize : CGFloat = 50.0
    @IBOutlet var cList : UITableView?
    var cellList : NSMutableArray = NSMutableArray.init()

    
    @IBOutlet var startBtn : UIButton?
    @IBOutlet var nameLbl : UILabel?
    

    @IBOutlet var genderLbl : UILabel?
    @IBOutlet var wtLbl : UILabel?
    @IBOutlet var sizeLbl : UILabel?
    @IBOutlet var htLbl : UILabel?
    
    
    override func viewDidLoad() {
       

        Constants.MyNavi.updateInfo = false
        super.viewDidLoad()
        if let dataFromStorage = UserDefaults.standard.value(forKey: Constants.SaveKey.profile) as? Data
        {
            if let profileDict = CustView.UDDictionaryUnarchiver(AnyInput: dataFromStorage)
            {
                if let userName = profileDict["full_name"] as? String
                {
                    self.nameLbl?.text = userName
                }
                
                
                if let sizetxt = profileDict["foot_size_unit"] as? NSNumber, let sizeno = profileDict["foot_size"] as? NSNumber, let genderSize = profileDict["foot_size_gender"] as? NSNumber 
                {
                    var genderHandler = "Mens"
                    if genderSize.intValue == 1 { genderHandler = "Womens" }
                    else if genderSize.intValue == 2 { genderHandler = "Kids" }
                    
                    
                    var textUNIT = "US"
                    if sizetxt.intValue != 0
                    { textUNIT = sizetxt.intValue != 2 ? "UK" : "EUR" }
                    
                    
                    self.sizeLbl?.text =  textUNIT + " \(genderHandler)" + " \(sizeno.doubleValue)"
                    
                }
                
                if let gendrStr = profileDict["gender"] as? NSNumber
                {
                    self.genderLbl?.text = gendrStr.intValue != 0 ? "FEMALE" : "MALE"
                }
                
                if let wtStr = profileDict["weight"] as? NSNumber
                {
                    self.wtLbl?.text = "\(wtStr) kg"
                }
                
                if let htStr = profileDict["age"] as? NSNumber
                {
                    self.htLbl?.text = "\(htStr) yo"
                }
                
            }
        }
        
        self.cList?.rowHeight = cellsize
        self.cList!.register(UITableViewCell.self, forCellReuseIdentifier: "cell")


    }

    
    override func viewDidAppear(_ animated: Bool) {
        
        if let dataFromStorage = UserDefaults.standard.value(forKey: Constants.SaveKey.profile) as? Data
        {
            if let profileDict = CustView.UDDictionaryUnarchiver(AnyInput: dataFromStorage)
            {
                if let userName = profileDict["full_name"] as? String
                {
                    self.nameLbl?.text = userName
                }
                
                
                if let sizetxt = profileDict["foot_size_unit"] as? NSNumber, let sizeno = profileDict["foot_size"] as? NSNumber, let genderSize = profileDict["foot_size_gender"] as? NSNumber
                {
                    var genderHandler = "Mens"
                    if genderSize.intValue == 1 { genderHandler = "Womens" }
                    else if genderSize.intValue == 2 { genderHandler = "Kids" }
                    
                    
                    var textUNIT = "US"
                    if sizetxt.intValue != 0
                    { textUNIT = sizetxt.intValue != 2 ? "UK" : "EUR" }
                    
                    
                    self.sizeLbl?.text =  textUNIT + " \(genderHandler)" + " \(sizeno.doubleValue)"
                    
                }
                
                if let gendrStr = profileDict["gender"] as? NSNumber
                {
                    self.genderLbl?.text = gendrStr.intValue != 0 ? "FEMALE" : "MALE"
                }
                
                if let wtStr = profileDict["weight"] as? NSNumber
                {
                    self.wtLbl?.text = "\(wtStr) kg"
                }
                
                if let htStr = profileDict["age"] as? NSNumber
                {
                    self.htLbl?.text = "\(htStr) yo"
                }
                
            }
        }
        
        
        
        super.viewDidAppear(animated)
        
        if let contentArr = UserDefaults.standard.value(forKey: Constants.SaveKey.scans) as? NSArray
        {
            if contentArr.count > 0
            {
                
                for ctx in 0..<contentArr.count
                {
                    if let dataImg = contentArr[ctx] as? Data, let imgV = self.view.viewWithTag(11 + ctx) as? UIImageView
                    {
                        if let theImage = UIImage.init(data: dataImg)
                        {
                            imgV.image = theImage
                            imgV.setNeedsDisplay()
                        }
                      
                    }
                }
            }
        }
        
        
    }
    
    @IBAction func cReturn(_ sender: UIButton) {
        Constants.MyNavi.GoToMain(completion: nil)
        
    }
    
    @IBAction func cSignOut(_ sender: UIButton) {
        CustView.SignOut()
        Constants.MyNavi.GoToMain(completion: nil)
    }
    
    @IBAction func reDoPush(_ sender: UIButton) {
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
    
    @IBAction func ChangePush(_ sender: UIButton) {
        Constants.MyNavi.updateInfo = true
        let theNext : UnregSteps_Screen = self.navigationController?.storyboard!.instantiateViewController(withIdentifier: "UnregSteps_Screen") as! UnregSteps_Screen
        Constants.MyNavi.goNextCrossFade(viewcontroller: theNext) { (_) in
        }
    }
    
    //#################################################################################################################################################################
    //################################################################################################################################################################
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        if let pView = self.cellList[indexPath.row] as? UIView  { return pView.frame.size.height }
        return cellsize
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return  cellList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell")! as UITableViewCell
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        if !cell.isEqual(nil)
        {
            let subviews = cell.contentView.subviews
            for anyobj : AnyObject in subviews {   if (anyobj is UIView) { anyobj.removeFromSuperview()   }  }
            
        }
        cell.backgroundColor = .clear
        cell.contentView.backgroundColor = .clear
        
        if let pView = self.cellList[indexPath.row] as? UIView  { cell.contentView.addSubview(pView) }
        
        
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
   
    }
    
    //#############################################################################################################################################################
    //#############################################################################################################################################################
    
    func createcellTable(Dictionary:NSDictionary) -> UIView
    {
        
        let strAtt = CustView.getAttributeDict(fontName: "HelveticaNeue-Medium", alignment:.left, size: 12, color:.init(netHex: 0x22385B))

        let  strTitle = NSMutableAttributedString(string:"\(Dictionary["title"] ?? "-")", attributes:strAtt )

        let substrAtt = CustView.getAttributeDict(fontName: "HelveticaNeue-Light", alignment:.left, size: 12, color:.init(netHex: 0x22385B))

        let subStrMinor = NSAttributedString(string: "\n\(Dictionary["subtitle"] ?? "-")", attributes: substrAtt)
        strTitle.append(subStrMinor)

        let padding:CGFloat = 15.0
        let yPadding:CGFloat = 10.0
        let contentWidth : CGFloat = Constants.DeviceProperty.devWidth - ((padding*1.5)*2.0)
        let theAttN = CustView.getAttributeDict(fontName: "HelveticaNeue-Medium", alignment:.left, size: 12.0, color:.init(netHex: 0x22385B))
        let dateStr = NSAttributedString.init(string: "\(Dictionary["date"] ?? "-")", attributes: theAttN)

        let dateLbl = CustView.statLabel(rect: CGRect(x: padding, y: 0, width:75.0, height: cellsize), attStr: dateStr)
       
        let boundRect = strTitle.boundingRect(with: CGSize(width: contentWidth - 80.0, height:CGFloat.greatestFiniteMagnitude), options: [.usesLineFragmentOrigin, .usesFontLeading], context: nil)
        
         let descLbl = CustView.statLabel(rect: CGRect(x: CustView.xObject(theview: dateLbl) + 5.0, y: yPadding, width:contentWidth - 80.0, height: boundRect.size.height), attStr: strTitle)
        
        let thereturnView = UIView.init(frame: CGRect(x: 0, y: 0, width: Constants.DeviceProperty.devWidth, height: CustView.yObject(theview: descLbl) + yPadding))
        
        let theLine = self.createLine(fromPoint: CGPoint(x:0, y: 0), toPoint: CGPoint(x:Constants.DeviceProperty.devWidth , y:0), color: UIColor.init(netHex: 0xd1d1d1), lineWidth: 0.5)
        
        thereturnView.addSubview(dateLbl)
        thereturnView.addSubview(descLbl)
        thereturnView.layer.addSublayer(theLine)
        
        return thereturnView
        
    }
    
    
    //#############################################################################################################################################################
    //#############################################################################################################################################################
    
    func fetchHistory()
    {
        Constants.MyNavi.showStatus(string: "Fetching Info...")
        let request = CustView.RegisterCheck(tokenRequired:true, dataTransfered: nil, theService:"orders/", Method: "GET")
        Constants.MyNavi.webRequest(hasLoading: true, theRequest: request) { (respo, hasVal, errC) in
            if errC == 200
            {
                if let contentDict = respo as? NSDictionary, let dataDict = contentDict["data"] as? NSArray, (dataDict.count > 0)
                {
                  // print("---- xxxx \(dataDict)")
                    
                    for unkDict in dataDict
                    {
                        
                        
                        if let dctnry = unkDict as? NSDictionary   {
                            
                            if let gcolor = dctnry["colour"] as? String, let gtype = dctnry["type"] as? String, let gunit = dctnry["unit"] as? String, let ggender = dctnry["gender"] as? String, let gsize = dctnry["size"] as? NSNumber, let gdate = dctnry["order_date"] as? String, let ailmentStr = dctnry["profile_ailments"] as? [String]
                            {
                                
                                
                                var topTitle = "\(gcolor) \(gtype) DOCSOLS"
                                if ailmentStr.count > 0
                                {
                                    topTitle = ""
                                    for stringAilment in ailmentStr
                                    {
                                        topTitle = topTitle + ", \(stringAilment)"
                                    }
                                    
                                    topTitle = topTitle.deletingPrefix(", ")
                                }
                                
                                let subTitle = "\(gunit) \(ggender) \(gsize.doubleValue)"
                                //print ("UTC = \(gdate)")
                                self.cellList.add(self.createcellTable(Dictionary: [
                                    "title" : topTitle.uppercased(),
                                    "subtitle" : subTitle,
                                    "date" : CustView.UTCToLocal(date: gdate)
                                    ]))

                            }
                            
                        }
                    }
         
                    self.cList?.reloadData()
                    self.cList?.isHidden = false
                }
               
            //    self.cellList.add(self.createcellTable(string: "UK MENS 55.55"))
              
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
}
