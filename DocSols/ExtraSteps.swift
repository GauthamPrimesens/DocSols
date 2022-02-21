//
//  ExtraSteps.swift
//  DocSolsM
//
//  Created by Jene Kirishima on 12/06/2018.
//  Copyright © 2018 Jene Kirishima. All rights reserved.
//

import Foundation
import UIKit


class UnregSteps_Screen: CustView, UIScrollViewDelegate
{
    
    @IBOutlet var pageCont : UIPageControl?
    @IBOutlet var scrollView :  UIScrollView?
    @IBOutlet var cBackBtn :  UIButton?
    
    let kCellSpacing : CGFloat = 10.0
    let maxBtns :Int = 4
    
    
    @IBOutlet var firstView :  UIView?
    @IBOutlet var toplabel :  UILabel?
    
    
    @IBOutlet var firstNext :  UIButton?
    @IBOutlet var iconImage :  UIImageView?
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        let arrowL = CustView.createArrow(rect: CGRect(x:0 ,y:7, width:8 ,height:16) , direction: .left, color: .white , lineWidth: 3.0)
        self.cBackBtn?.layer.addSublayer(arrowL)
        
        // 60 space - width
        //20 10 300
        
        
        let widthV : CGFloat = self.view.frame.size.width - 60
     
        
        for ct in 0..<maxBtns
        {
            
            if ct != 0
            {
                let uiv = SelectView.init(frame: CGRect(x: 30 + (CGFloat(ct)*(widthV + kCellSpacing)), y: 0, width: widthV, height: scrollView!.frame.size.height))
                
                switch ct
                {
                case 1:
                    uiv.GenderDrawLayout(TTarget:self, tSelector:#selector(NextScreenTrigger))
                    break
                case 2:
                    uiv.DrawTextBox(TTarget:self, tSelector:#selector(NextScreenTrigger))
                    break
                case 3:
                    uiv.DrawMultiLayout(TTarget:self, tSelector:#selector(NextScreenTrigger))
                    break
                default:
                    break
                }

                self.scrollView?.addSubview(uiv)
            }
            else
            {
                self.firstView?.frame = CGRect(x: 30 + (CGFloat(ct)*(widthV + kCellSpacing)), y: 0, width: widthV, height: scrollView!.frame.size.height)
                self.scrollView?.addSubview(self.firstView!)
            }
    
        }
        
      //  self.scrollView?.contentSize = CGSize(width: 60 + (CGFloat(maxBtns)*(widthV + kCellSpacing)), height: scrollView!.frame.size.height)
        self.scrollView?.contentSize = CGSize(width: 60 + (widthV + kCellSpacing), height: scrollView!.frame.size.height)

        self.scrollView?.isScrollEnabled = false
        self.pageCont?.currentPage = 0
        self.pageCont?.numberOfPages = maxBtns
        
        self.iconImage?.isHidden = false
        if self.view.frame.size.height < 568 {  self.iconImage?.isHidden = true }
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        
   
        super.viewDidAppear(animated)
        
    }
    
    @IBAction func selectionPush(_ sender: UIButton) {
        
        let typeOfBtn = sender.layer.name
        self.firstNext?.isEnabled = true
        self.firstNext?.backgroundColor = UIColor.init(netHex: 0xFF6A2B)
        if typeOfBtn != "default"
        {
            for subs in (self.firstView?.subviews)!
            {
                if let ButtonSelect = subs as? UIButton, subs.tag != 300, ButtonSelect.layer.name == "default"
                {
                    
                    
                    ButtonSelect.setImage(UIImage.init(named: "chckbox_D"), for: .normal)
                    ButtonSelect.tag = 0
                    
                    
                }
            }
            
            if (sender.tag == 1)
            {
                sender.setImage(UIImage.init(named: "chckbox_D"), for: .normal)
                sender.tag = 0
                
                self.scrollView?.isScrollEnabled = false
                self.firstNext?.isEnabled = false
                self.firstNext?.backgroundColor = UIColor.init(netHex: 0xAAAAAA)
            }
            else
            {
                sender.setImage(UIImage.init(named: "chckbox_S"), for: .normal)
                sender.tag = 1
            }
        
        }
        else
        {
            var canUncheck = false
            for subs in (self.firstView?.subviews)!
            {
                if let ButtonSelect = subs as? UIButton, subs.tag != 300
                {
                    if ButtonSelect.layer.name != "default"
                    {
                        ButtonSelect.setImage(UIImage.init(named: "chckbox_D"), for: .normal)
                        ButtonSelect.tag = 0
                    }
                    else
                    {
                        //other active button
                       if ButtonSelect.tag == 1 && ButtonSelect != sender
                       { canUncheck = true }
                    }
                   
                }
            }
            
            
            if (sender.tag == 1)
            {
                sender.setImage(UIImage.init(named: "chckbox_D"), for: .normal)
                sender.tag = 0
                
                if !canUncheck
                {
                    self.scrollView?.isScrollEnabled = false
                    self.firstNext?.isEnabled = false
                    self.firstNext?.backgroundColor = UIColor.init(netHex: 0xAAAAAA)
                }
            }
            else
            {
                sender.setImage(UIImage.init(named: "chckbox_S"), for: .normal)
                sender.tag = 1
            }

            
        }
        
        
    }
    
    
    
    @IBAction func signIn(_ sender: UIButton) {
        

    }
    
    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let kCellWidth : CGFloat = self.view.frame.size.width - 60
         self.pageCont?.currentPage =  Int(scrollView.contentOffset.x/(kCellWidth + self.kCellSpacing))
    }
    
    public func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>)
    {
        self.view.endEditing(true)
        
        let kCellWidth : CGFloat = self.view.frame.size.width - 60
        let  kMaxIndex:CGFloat = CGFloat(maxBtns)
        let targetX : CGFloat = scrollView.contentOffset.x + velocity.x * 60.0
        var targetIndex : CGFloat = round(targetX / (kCellWidth + kCellSpacing))
        if (targetIndex < 0) { targetIndex = 0 }
        if (targetIndex > kMaxIndex) { targetIndex = kMaxIndex }
        
        targetContentOffset.pointee.x = targetIndex * (kCellWidth + kCellSpacing)
        
    
     
//        self.pageCont?.currentPage = Int(targetIndex)
            self.toplabel?.isHidden = false
            self.iconImage?.isHidden = false
        

        if (targetIndex == 0) || ((targetIndex + 1.0) == CGFloat(maxBtns))
        {
            self.toplabel?.isHidden = true
            if self.view.frame.size.height < 568 {  self.iconImage?.isHidden = true }
        }
    }
    
    @IBAction func NextRaw(_ sender: UIButton) {
        var isSpecial = false
        for subs in (self.firstView?.subviews)!
        {
            if let ButtonSelect = subs as? UIButton, subs.tag != 300
            {
                if ButtonSelect.layer.name != "default" && ButtonSelect.tag == 1
                {  isSpecial = true }
              
                
            }
        }
        
        if !isSpecial
        {
            //popUp
            let nextAct : ActionButton = CustView.OAbuttoncreate(txtlbl: "Next", completion: {() in
                self.toplabel?.isHidden = false
                self.iconImage?.isHidden = false
                self.NextScreenTrigger()
            })
            
            let cancelAct : ActionButton = CustView.OAbuttoncreate(txtlbl: "Cancel", completion: {() in
                
            })
            
            
            Constants.MyNavi.AlertCover(title: "We're sorry", withColor: .init(netHex:0xff6a2b), themessage: "Unfortunately, due to one of the conditions you just mentioned, we can not allow you to purchase an insole through this application.\n\nYou may still proceed with the scan and we will be in touch with you to provide you with further assistance.", withColor: .init(netHex:0x22385B), with: [cancelAct, nextAct])
        }
        else
        {
         
            
            self.toplabel?.isHidden = false
            self.iconImage?.isHidden = false
            self.NextScreenTrigger()
        }
        
        
    }
    
    @objc func NextScreenTrigger()
    {
        self.view.endEditing(true)

        let kCellWidth : CGFloat = self.view.frame.size.width - 60
        let currentpage = pageCont?.currentPage
        if currentpage! + 1 == 1 {  self.scrollView?.isScrollEnabled = true  }
        
        
        if (currentpage! + 1 < maxBtns)
        {
           // print("-----> \(self.pageCont?.currentPage ?? 999)")
            
            let scrollwidth : CGFloat =  50 + (CGFloat(currentpage! + 2)*(kCellWidth + kCellSpacing))
            if scrollwidth > (self.scrollView?.contentSize.width)!
            { self.scrollView?.contentSize = CGSize(width:scrollwidth, height: scrollView!.frame.size.height) }
            
            self.view.isUserInteractionEnabled = false
            UIView.animate(withDuration: 0.25, delay: 0.0, options: .curveEaseInOut, animations: {() -> Void in
                
                self.scrollView?.contentOffset = CGPoint(x: CGFloat(currentpage!+1) * (kCellWidth + self.kCellSpacing), y: 0)
                
            }, completion: {(finished: Bool) -> Void in
                self.pageCont?.currentPage = currentpage! + 1

                if (self.pageCont?.currentPage)! + 1 == self.maxBtns
                {
                    self.toplabel?.isHidden = true
                    if self.view.frame.size.height < 568 {  self.iconImage?.isHidden = true }
                }
                
                  self.view.isUserInteractionEnabled = true
            })
        }
        else
        {
            
            let contOutput = NSMutableDictionary()
            for sbview in (self.scrollView?.subviews)!
            {
                if let cView = sbview as? SelectView
                {
                    if let content = cView.layer.value(forKey: "Data") as? NSDictionary { contOutput.addEntries(from: content as! [AnyHashable : Any]) }
                }
            }
            
            let btnsON = NSMutableArray.init()
            for subs in (self.firstView?.subviews)!
            {
                if let ButtonSelect = subs as? UIButton, subs.tag != 300
                {
                    if ButtonSelect.layer.name == "default" && ButtonSelect.tag == 1 {  btnsON.add(ButtonSelect.title(for: .normal)!) }
                }
            }
 
            
            var ailemntsCT = 0
            let prefixesArr = ["D", "N", "P", "V", "S"]
            for sctSTR in 0..<btnsON.count
            {
                if let stringLbl = btnsON[sctSTR] as? String
                {
                    for strChecker in 0..<prefixesArr.count
                    {
                        if stringLbl.uppercased().hasPrefix(prefixesArr[strChecker])
                        {
                            let xoutpot = pow(2, strChecker)
                            let result = NSDecimalNumber(decimal: xoutpot).intValue
                            ailemntsCT = ailemntsCT + result
                        }
                    }

                }

            }
            
            contOutput["ailments"] = NSNumber.init(value:ailemntsCT)

            print(contOutput)
            Constants.MyNavi.TempoProfile = contOutput
            
            
            let theNext : Pressure_Screen = self.navigationController?.storyboard!.instantiateViewController(withIdentifier: "Pressure_Screen") as! Pressure_Screen
            Constants.MyNavi.goNextCrossFade(viewcontroller: theNext) { (_) in
                
                
            }
            

        }
    }
    
   

}

//##############################################################################################################################################################
// PLUG-INS
//##############################################################################################################################################################

public class SelectView: UIView, UITextFieldDelegate {

    var cTarget : UIViewController?
    var cSelector : Selector?
    var VarSizeArray : NSMutableArray = NSMutableArray()

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.layer.cornerRadius = 10.0
        self.clipsToBounds = true
        self.backgroundColor = .white
    }
    
    required public init(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)!
    }
    
    //###########################################################################################################################################
    //###########################################################################################################################################
    func GenderDrawLayout(TTarget:Any?, tSelector:Selector?)
    {
        if let newTarget = TTarget as? UIViewController  { self.cTarget = newTarget }
        if let nSelector = tSelector { self.cSelector = nSelector }
        
        
        let vSpace : CGFloat = 30.0
        let sideSpace : CGFloat = 25.0
        let centerSpace : CGFloat = 10.0
        let buttonSize : CGFloat = (self.frame.width - (sideSpace*2.0) - centerSpace)*0.5
        
        let titleAtt = CustView.getAttributeDict(fontName: "HelveticaNeue-Bold", alignment:.center, size: 16, color:.init(netHex: 0x22385B))
        let titleAttStr = NSMutableAttributedString(string:"What is your gender?", attributes:titleAtt )
        

        let CtitleLbl : UILabel = CustView.statLabel(rect: CGRect(x:sideSpace,  y:  vSpace, width:self.frame.width - (sideSpace*2.0), height:20), attStr: titleAttStr)
        self.addSubview(CtitleLbl)
        
        let titleBtns = ["Male", "Female"]
        for btnCt in 0..<titleBtns.count
        {
            let btnAtt = CustView.getAttributeDict(fontName: "HelveticaNeue-Light", alignment:.center, size: 14, color:.init(netHex: 0x22385B))
            let  btnAtStr = NSMutableAttributedString(string:titleBtns[btnCt], attributes:btnAtt )
            let theBtn = CustView.statLabel(rect: CGRect(x: sideSpace + (CGFloat(btnCt)*(buttonSize + centerSpace)), y: CustView.yObject(theview: CtitleLbl) + 20, width: buttonSize, height: 40.0), attStr: btnAtStr)
            theBtn.layer.cornerRadius = 5.0
            theBtn.layer.borderColor = UIColor.init(netHex: 0x22385B).cgColor
            theBtn.layer.borderWidth = 1.0
            theBtn.tag = btnCt + 1
            theBtn.backgroundColor = .clear
            theBtn.layer.name = "GenderBtn"
            theBtn.layer.setValue(titleBtns[btnCt], forKey: "ButtonTitle")
            theBtn.clipsToBounds = true
            
            theBtn.isUserInteractionEnabled = true
            let gesture : UITapGestureRecognizer = UITapGestureRecognizer.init(target: self, action:#selector(tapGender(_:)))
            gesture.numberOfTapsRequired = 1
        
            theBtn.addGestureRecognizer(gesture)
            
            self.addSubview(theBtn)
        }
        
        let finalHeight : CGFloat = CustView.yObject(theview: CtitleLbl) + 20 + 40.0 + vSpace
        
        self.frame = CGRect(x: self.frame.origin.x , y: self.frame.size.height - finalHeight, width: self.frame.size.width, height: finalHeight)
        
        self.layer.setValue(["gender" : "-"], forKey: "Data")
    }

    @objc func tapGender(_ gesture:UITapGestureRecognizer)
    {
        let selectedTag = gesture.view?.tag
        
        for lblVP in (gesture.view?.superview?.subviews)!
        {
            if let theLabel = lblVP as? UILabel, (lblVP.layer.name == "GenderBtn")
            {
                let isSelected = selectedTag == theLabel.tag ? true : false
                if let titleString = theLabel.layer.value(forKey: "ButtonTitle") as? String
                {
                    let btnAtt = CustView.getAttributeDict(fontName: "HelveticaNeue-Light", alignment:.center, size: 14, color: isSelected ? .white : .init(netHex: 0x22385B))
                    let  btnAtStr = NSMutableAttributedString(string:titleString, attributes:btnAtt )
                    theLabel.attributedText = btnAtStr
                    theLabel.layer.borderColor = (isSelected ? UIColor.clear : UIColor.init(netHex: 0x22385B)).cgColor
                    theLabel.backgroundColor = isSelected ? .init(netHex: 0xff6a2b) : .clear
                    theLabel.setNeedsDisplay()
                    
                    if isSelected { gesture.view?.superview?.layer.setValue(["gender" : titleString], forKey: "Data") }
                }
                
            }
        }
        
        if let currentSelector = self.cSelector, let currentVC = self.cTarget {   currentVC.perform(currentSelector) }
    
    }
    
    //###########################################################################################################################################
    //###########################################################################################################################################
    func DrawTextBox(TTarget:Any?, tSelector:Selector?)
    {
        if let newTarget = TTarget as? UIViewController  { self.cTarget = newTarget }
        if let nSelector = tSelector { self.cSelector = nSelector }
        
        let vSpace : CGFloat = 30.0
        let sideSpace : CGFloat = 25.0
        let centerSpace : CGFloat = 10.0
        let buttonSize : CGFloat = (self.frame.width - (sideSpace*2.0) - centerSpace)*0.5
        let txtfieldH : CGFloat = 35.0
        let spacing : CGFloat = 20.0
        
        let titleAtt = CustView.getAttributeDict(fontName: "HelveticaNeue-Bold", alignment:.center, size: 12, color:.init(netHex: 0x22385B))
        let titleAttStr = NSMutableAttributedString(string: "Age / Weight", attributes:titleAtt )
        
        
        let CtitleLbl : UILabel = CustView.statLabel(rect: CGRect(x:sideSpace,  y:  vSpace, width:self.frame.width - (sideSpace*2.0), height:20), attStr: titleAttStr)
        self.addSubview(CtitleLbl)
        
        
        let titleBtns = ["AGE", "WEIGHT"]
        for btnCt in 0..<titleBtns.count
        {
            let textfield = UITextField.init(frame:  CGRect(x: sideSpace + (CGFloat(btnCt)*(buttonSize + centerSpace)), y: CustView.yObject(theview: CtitleLbl) + spacing, width: buttonSize, height: txtfieldH))
            
            let paddingView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: centerSpace, height: txtfieldH))
            textfield.leftView = paddingView
            textfield.leftViewMode = .always
            
            textfield.autocorrectionType = .no
            textfield.keyboardType = .numbersAndPunctuation
            textfield.returnKeyType = .done
            textfield.delegate = self as UITextFieldDelegate
            textfield.font = UIFont.init(name: "HelveticaNeue-Medium", size: 10.0)
            textfield.placeholder = "< ENTER \(titleBtns[btnCt])" + (btnCt != 0 ? " (kg) >" : " >")
            textfield.layer.name = "\(titleBtns[btnCt])"
            textfield.layer.cornerRadius = 5.0
            textfield.tag = btnCt + 1
            textfield.backgroundColor =  .init(netHex: 0xEEEEEE)
            textfield.clipsToBounds = true
     
            textfield.addTarget(self, action: #selector(TFChange(_:)), for: .editingChanged   )

            
            self.addSubview(textfield)
        }
        
        
        let btnAtt = CustView.getAttributeDict(fontName: "HelveticaNeue-Bold", alignment:.center, size: 14, color:.white)
        let  btnAtStr = NSMutableAttributedString(string:"Next", attributes:btnAtt )
        let theBtn = CustView.statLabel(rect: CGRect(x: (self.frame.size.width - buttonSize)*0.5, y: CustView.yObject(theview: CtitleLbl) + txtfieldH + spacing*2.0, width: buttonSize, height: 40.0), attStr: btnAtStr)
        theBtn.layer.cornerRadius = 5.0
        theBtn.backgroundColor = .init(netHex: 0xAAAAAA)
        theBtn.tag = 1228
        //theBtn.backgroundColor = .init(netHex: 0xff6a2b)
        theBtn.clipsToBounds = true
        
        theBtn.isUserInteractionEnabled = false
        let gesture : UITapGestureRecognizer = UITapGestureRecognizer.init(target:self.cTarget, action:self.cSelector)
        gesture.numberOfTapsRequired = 1
        theBtn.addGestureRecognizer(gesture)
        
        self.addSubview(theBtn)
        
        
        let finalHeight : CGFloat = CustView.yObject(theview: theBtn) + vSpace
        
        self.frame = CGRect(x: self.frame.origin.x , y: self.frame.size.height - finalHeight, width: self.frame.size.width, height: finalHeight)
        
        self.layer.setValue([
            "weight" : "UNSPECIFIED",
            "age" : "UNSPECIFIED",
            ], forKey: "Data")
    }
    
    @objc func TFChange(_ textField: UITextField)
    {
        var exSt = textField.text!
        if (exSt.hasPrefix(" ")) {
            let curInd = exSt.startIndex
            exSt = String(exSt[exSt.index(after: curInd)...])
            
            
        }
        
        textField.text = exSt
        
        self.handleButtonEnabler(textField)
        
    }
    
    public func textFieldDidBeginEditing(_ textField: UITextField) {
        
        
        textField.text = CustView.hasWhitespace(string: textField.text)
        
        let thedifference : CGFloat  = Constants.DeviceProperty.devHeight - CGFloat(Constants.DeviceProperty.KBHeight) - 10
        let thealotment : CGFloat = (self.frame.origin.y) + CustView.yObject(theview: textField) + (textField.superview!.frame.origin.y)
        let adjustment =  thealotment - thedifference
        UIView.animate(withDuration: 0.1, delay: 0.0, options: .curveEaseInOut, animations: {() -> Void in
            
            if (adjustment >= 0) {
                self.center = CGPoint(x:   self.center.x, y: self.frame.height * 0.5)
           
            }
            
        }, completion: {(finished: Bool) -> Void in
            
            
        })
        
        self.handleButtonEnabler(textField)
    }
    
    
    public func textFieldDidEndEditing(_ textField: UITextField) {
        textField.text = CustView.hasWhitespace(string: textField.text)
        
        let containerH : CGFloat = (self.superview?.frame.height)!
        if ((self.frame.height * 0.5) == self.center.y) {
            UIView.animate(withDuration: 0.1, delay: 0.0, options: .curveEaseInOut, animations: {() -> Void in
                
                
                self.center = CGPoint(x:   self.center.x, y: containerH - (self.frame.height * 0.5))
                
                
                
            }, completion: {(finished: Bool) -> Void in
                
                
            })
        }
        
        
        if let intVal:Int = Int(textField.text!)
        { textField.text = String(intVal) }
        else { textField.text = "" }
   
        
        let mutableDict = NSMutableDictionary.init(dictionary: [
            "weight" : "UNSPECIFIED",
            "age" : "UNSPECIFIED",
            ])
        for txtfild in self.subviews
        {
            if (txtfild.isKind(of: UITextField.self) && txtfild.layer.name != nil)
            {
                if let keyString = txtfild.layer.name?.lowercased(), let ptxtfield = txtfild as? UITextField
                {
                    mutableDict[keyString] = ptxtfield.text != "0" ? ptxtfield.text :"UNSPECIFIED"
                }
            }
        }
        
        self.layer.setValue(mutableDict, forKey: "Data")
        self.handleButtonEnabler(textField)
    }
    
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let aSet = NSCharacterSet(charactersIn:"0123456789").inverted
        let compSepByCharInSet = string.components(separatedBy: aSet)
        let numberFiltered = compSepByCharInSet.joined(separator: "")
        return string == numberFiltered
    }
    
    
    func handleButtonEnabler(_ textField: UITextField)
    {
        var checkEmpty = false
        let txtsuperview = textField.superview
        for textfieldEx in (txtsuperview?.subviews)!
        {
            if (textfieldEx.isKind(of: UITextField.self))
            {
                if (textfieldEx as! UITextField).text == "" { checkEmpty = true }
            }
        }

        
        if let ebutton = txtsuperview?.viewWithTag(1228) as? UILabel
        {
            ebutton.isUserInteractionEnabled = !checkEmpty
            if !checkEmpty { ebutton.backgroundColor = .init(netHex: 0xff6a2b) }
            else {
                let kCellWidth : CGFloat = Constants.DeviceProperty.devWidth - 60
                let currentpage = 3
                let scrollwidth : CGFloat =  50 + (CGFloat(currentpage)*(kCellWidth + 10.0))
//                if scrollwidth > (self.scrollView?.contentSize.width)!
//                { self.scrollView?.contentSize = CGSize(width:scrollwidth, height: scrollView!.frame.size.height) }
                ebutton.backgroundColor = .init(netHex: 0xAAAAAA)
                
                guard let scrollview = self.superview as? UIScrollView else { return }
                scrollview.contentSize = CGSize(width:scrollwidth, height: scrollview.frame.size.height)
            }
        }
    }
  
    
    
    //###########################################################################################################################################
    //###########################################################################################################################################
    
    func DrawMultiLayout(TTarget:Any?, tSelector:Selector?)
    {
        if let newTarget = TTarget as? UIViewController  { self.cTarget = newTarget }
        if let nSelector = tSelector { self.cSelector = nSelector }
        
        
        let vSpace : CGFloat = 30.0
        let sideSpace : CGFloat = 25.0
        let centerSpace : CGFloat = 10.0
        let buttonSize : CGFloat = (self.frame.width - (sideSpace*2.0) - centerSpace)*0.5
        let buttonSize2 : CGFloat = (self.frame.width - (sideSpace*2.0) - (centerSpace))/3.0
        let btnMult : CGFloat = 35.0
        
        let titleAtt = CustView.getAttributeDict(fontName: "HelveticaNeue-Bold", alignment:.center, size: 12, color:.init(netHex: 0x22385B))
        let titleAttStr = NSMutableAttributedString(string: "Foot size / Shoe width", attributes:titleAtt )
        
        
        let CtitleLbl : UILabel = CustView.statLabel(rect: CGRect(x:sideSpace,  y:  vSpace, width:self.frame.width - (sideSpace*2.0), height:20), attStr: titleAttStr)
        self.addSubview(CtitleLbl)
        
        let titleBtnsMWK = ["Mens", "Womens", "Kids"]
        for btnCtMWK in 0..<titleBtnsMWK.count
        {
            let btnAtt = CustView.getAttributeDict(fontName: "HelveticaNeue-Light", alignment:.center, size: 12, color:.init(netHex: 0x22385B))
            let  btnAtStr = NSMutableAttributedString(string:"\(titleBtnsMWK[btnCtMWK])", attributes:btnAtt )
            let theBtn = CustView.statLabel(rect: CGRect(x: sideSpace + (CGFloat(btnCtMWK)*(buttonSize2 + centerSpace*0.5)), y: CustView.yObject(theview: CtitleLbl) + 20, width: buttonSize2, height: btnMult), attStr: btnAtStr)
            
            theBtn.layer.name = "gender"
            theBtn.layer.cornerRadius = 5.0
            theBtn.layer.borderColor = (btnCtMWK == 0 ? .init(netHex: 0xff6a2b) : UIColor.init(netHex: 0x22385B)).cgColor
            theBtn.layer.borderWidth = 1.0
            theBtn.tag = btnCtMWK + 1
            theBtn.backgroundColor = .clear
            theBtn.clipsToBounds = true
            
            theBtn.layer.setValue(titleBtnsMWK[btnCtMWK], forKey: "ButtonTitle")
            
            theBtn.isUserInteractionEnabled = true
            let gesture : UITapGestureRecognizer = UITapGestureRecognizer.init(target: self, action:#selector(TapMulti(_:)))
            gesture.numberOfTapsRequired = 1
            
            theBtn.addGestureRecognizer(gesture)
            
            self.addSubview(theBtn)
        }
        
        let subLbl = UILabel.init(frame: CGRect(x:sideSpace - 5.0,  y: CustView.yObject(theview: CtitleLbl) + 20 + btnMult + 10, width:self.frame.width - (sideSpace*2.0), height:14))
        subLbl.textColor = UIColor.init(netHex: 0x22385B)
        subLbl.textAlignment = .left
        subLbl.font = UIFont.init(name: "HelveticaNeue-Bold", size: 10)
        subLbl.backgroundColor = .clear
        subLbl.text = "Size"
        self.addSubview(subLbl)
        
        
        let titleBtns = ["SELECT UNIT", "SELECT SIZE"]
        for btnCt in 0..<titleBtns.count
        {
            let frameView = UIView.init(frame:  CGRect(x: sideSpace + (CGFloat(btnCt)*(buttonSize + centerSpace)), y: CustView.yObject(theview: subLbl) + 5, width: buttonSize, height: 35.0))
            
            
            let btnAtt = CustView.getAttributeDict(fontName: "HelveticaNeue-Bold", alignment:.left, size: 10, color:.init(netHex: 0x22385B))
            let  btnAtStr = NSMutableAttributedString(string:"\(titleBtns[btnCt])", attributes:btnAtt )
            let theBtn = CustView.statLabel(rect:CGRect(x:10, y:0, width: buttonSize-20, height: 35.0), attStr: btnAtStr)
            theBtn.tag = 300
            theBtn.backgroundColor = .clear
            frameView.addSubview(theBtn)
        
            frameView.layer.name = "size"
            frameView.layer.cornerRadius = 5.0
            frameView.tag = btnCt + 1
            frameView.backgroundColor =  .init(netHex: 0xEEEEEE)
            frameView.clipsToBounds = true
            
            let arrowD = CustView.createArrow(rect: CGRect(x:buttonSize - 20 ,y:15, width:10 ,height:5) , direction: .down, color: UIColor.init(netHex: 0x22385B) , lineWidth: 1.5)
            frameView.layer.addSublayer(arrowD)
            
            frameView.isUserInteractionEnabled = true
            let gesture : UITapGestureRecognizer = UITapGestureRecognizer.init(target: self, action:#selector(TapMulti(_:)))
            gesture.numberOfTapsRequired = 1
            
            frameView.addGestureRecognizer(gesture)
            
            self.addSubview(frameView)
        }
        
        let subLbl2 = UILabel.init(frame: CGRect(x:sideSpace - 5.0,  y:  CustView.yObject(theview: subLbl) + 40 + 10, width:self.frame.width - (sideSpace*2.0), height:14))
        subLbl2.textColor = UIColor.init(netHex: 0x22385B)
        subLbl2.textAlignment = .left
        subLbl2.font = UIFont.init(name: "HelveticaNeue-Bold", size: 10)
        subLbl2.backgroundColor = .clear
        subLbl2.text = "Shoe width"
        self.addSubview(subLbl2)
        
        
        //let buttonSize2 : CGFloat = (self.frame.width - (sideSpace*2.0) - (centerSpace))/3.0

        let titleBtns2 = ["Standard", "Wide", "Narrow"]
        for btnCt2 in 0..<titleBtns2.count
        {
            let btnAtt = CustView.getAttributeDict(fontName: "HelveticaNeue-Light", alignment:.center, size: 12, color:.init(netHex: 0x22385B))
            let  btnAtStr = NSMutableAttributedString(string:"\(titleBtns2[btnCt2])", attributes:btnAtt )
            let theBtn = CustView.statLabel(rect: CGRect(x: sideSpace + (CGFloat(btnCt2)*(buttonSize2 + centerSpace*0.5)), y: CustView.yObject(theview: subLbl2) + 5, width: buttonSize2, height: 35.0), attStr: btnAtStr)
    
            theBtn.layer.name = "shape"
            theBtn.layer.cornerRadius = 5.0
            theBtn.layer.borderColor = (btnCt2 == 0 ? .init(netHex: 0xff6a2b) : UIColor.init(netHex: 0x22385B)).cgColor
            theBtn.layer.borderWidth = 1.0
            theBtn.tag = btnCt2 + 1
            theBtn.backgroundColor = .clear
            theBtn.clipsToBounds = true
            
            theBtn.layer.setValue(titleBtns2[btnCt2], forKey: "ButtonTitle")

            theBtn.isUserInteractionEnabled = true
            let gesture : UITapGestureRecognizer = UITapGestureRecognizer.init(target: self, action:#selector(TapMulti(_:)))
            gesture.numberOfTapsRequired = 1
            
            theBtn.addGestureRecognizer(gesture)
            
            self.addSubview(theBtn)
        }
        
        
        let btnAtt = CustView.getAttributeDict(fontName: "HelveticaNeue-Bold", alignment:.center, size: 14, color:.white)
        let  btnAtStr = NSMutableAttributedString(string:"Save", attributes:btnAtt )
        let theBtn = CustView.statLabel(rect: CGRect(x: (self.frame.size.width - buttonSize)*0.5, y:  CustView.yObject(theview: subLbl2) + 40 + 30, width: buttonSize, height: 40.0), attStr: btnAtStr)
        theBtn.layer.cornerRadius = 5.0
        theBtn.backgroundColor = .init(netHex: 0xAAAAAA) //.init(netHex: 0xff6a2b)
        theBtn.clipsToBounds = true
        theBtn.tag = 777
        
        theBtn.isUserInteractionEnabled = false
        let gesture : UITapGestureRecognizer = UITapGestureRecognizer.init(target:self.cTarget, action:self.cSelector)
        gesture.numberOfTapsRequired = 1
        theBtn.addGestureRecognizer(gesture)
        
        self.addSubview(theBtn)
        
        
        let finalHeight : CGFloat = CustView.yObject(theview: theBtn) + vSpace
        
        self.frame = CGRect(x: self.frame.origin.x , y: self.frame.size.height - finalHeight, width: self.frame.size.width, height: finalHeight)
        self.layer.setValue([
             "foot_size_gender" : NSNumber.init(value: 0),
            "foot_size_unit" : "-",
            "foot_size" : "-",
            "foot_shape" : "Standard"
            ], forKey: "Data")
    }
    
    
    @objc func TapMulti(_ gesture:UITapGestureRecognizer)
    {
        let selectedTag = gesture.view?.tag
        
        let contentMod = NSMutableDictionary.init(dictionary: [
            "foot_size_unit" : "-",
            "foot_size" : "-",
            "foot_shape" : "Standard",
            "foot_size_gender" : NSNumber.init(value: 0)
            ])
        
        if let sourceContent = gesture.view?.superview?.layer.value(forKey: "Data") as? NSDictionary
        {  contentMod.setDictionary(sourceContent as! [AnyHashable : Any]) }
//
        
        if gesture.view?.layer.name == "gender"
        {
            if let numbertag = contentMod["foot_size_gender"] as? NSNumber
            {
                if selectedTag! - 1 == numbertag.intValue {  return }
            }
        }
        
        if gesture.view?.layer.name == "size"
        {


            
            
            let arrSelect = selectedTag != 1 ? VarSizeArray : ["US", "UK", "EUR"]
            let keyStr = selectedTag != 1 ? "foot_size" : "foot_size_unit"

            if arrSelect.count > 0
            {
                Constants.MyNavi.Pickercreate(ArrayContents: arrSelect as NSArray) { (string, index) in
                    
                    if let theLabel = gesture.view?.viewWithTag(300) as? UILabel
                    {
                     
                        let btnAtt = CustView.getAttributeDict(fontName: "HelveticaNeue-Bold", alignment:.left, size: 12, color:.init(netHex: 0x22385B))
                        let  btnAtStr = NSMutableAttributedString(string:"\(string)", attributes:btnAtt )
                        theLabel.attributedText = btnAtStr
                        theLabel.setNeedsDisplay()
                        
                        if selectedTag == 1
                        {
                            
                            for subviewstoCorr in (gesture.view?.superview?.subviews)!
                            {
                                if let adjLbl = subviewstoCorr.viewWithTag(300) as? UILabel, ((subviewstoCorr.layer.name == "size") && (subviewstoCorr.tag != 1))
                                {
                                    let btnAtt = CustView.getAttributeDict(fontName: "HelveticaNeue-Bold", alignment:.left, size: 10, color:.init(netHex: 0x22385B))
                                    let  btnAtStr = NSMutableAttributedString(string: "SELECT SIZE", attributes:btnAtt )
                                    adjLbl.attributedText = btnAtStr
                                    adjLbl.setNeedsDisplay()
                                }
                                
                                self.VarSizeArray.removeAllObjects()
                                contentMod["foot_size"] = "-"
                            }
                            
                         
                            
                        }

                        
                        
                        contentMod[keyStr] = "\(string)"
                        
                        gesture.view?.superview?.layer.setValue(contentMod, forKey: "Data")
                        
                        var enableButton = true
                        for values in contentMod.allValues
                        {
                            if let stringval = values as? String
                            {
                                if stringval == "-"  {  enableButton = false }
                            }
                            
                        }
                        
                        if let ebutton = gesture.view?.superview?.viewWithTag(777) as? UILabel
                        {
                            ebutton.isUserInteractionEnabled = enableButton
                            if enableButton { ebutton.backgroundColor = .init(netHex: 0xff6a2b) }
                            else { ebutton.backgroundColor = .init(netHex: 0xAAAAAA) }
                        }
                        
                        if selectedTag == 1
                        {
                            self.fetchListOfSize(content: contentMod, completion: { (List) in
                                self.VarSizeArray.setArray(List as! [Any])
                            })
                            
                            
                        }
                    }
              
                    
                    
                }
            }
            else
            {
                if let unitString = contentMod["foot_size_unit"] as? String
                {
                    if unitString != "-"
                    {
                        Constants.MyNavi.AlertCover(title: "Empty List", withColor: .init(netHex:0xff6a2b), themessage: "", withColor: .init(netHex:0x22385B), with: [])
                    }
                    else
                    {
                        Constants.MyNavi.AlertCover(title: "Please select unit size first.", withColor: .init(netHex:0xff6a2b), themessage: "", withColor: .init(netHex:0x22385B), with: [])
                    }
                }
                
            }

        }
        else
        {
            for lblVP in (gesture.view?.superview?.subviews)!
            {
                if let theLabel = lblVP as? UILabel
                {
                    if (lblVP.layer.name == gesture.view?.layer.name)
                    {
                        let isSelected = selectedTag == theLabel.tag ? true : false
                        if let titleString = theLabel.layer.value(forKey: "ButtonTitle") as? String
                        {
                            let btnAtt = CustView.getAttributeDict(fontName: "HelveticaNeue-Light", alignment:.center, size: 12, color:.init(netHex: 0x22385B) )
                            let  btnAtStr = NSMutableAttributedString(string:titleString, attributes:btnAtt )
                            theLabel.attributedText = btnAtStr
                            theLabel.layer.borderColor = (isSelected ? .init(netHex: 0xff6a2b) : UIColor.init(netHex: 0x22385B)).cgColor
                            theLabel.backgroundColor =  .clear
                            theLabel.setNeedsDisplay()
                            
                            //"gender"
                            //"foor_gender"
                            if isSelected {
                                if (lblVP.layer.name == "shape") {  contentMod["foot_shape"] = titleString  }
                                else if (lblVP.layer.name == "gender")  {
                                    contentMod["foot_size_gender"] = NSNumber.init(value: theLabel.tag - 1)
                                    
                                    if let unitString = contentMod["foot_size_unit"] as? String
                                    {
                                        if unitString != "-"
                                        {
                                            for subviewstoCorr in (gesture.view?.superview?.subviews)!
                                            {
                                                if let adjLbl = subviewstoCorr.viewWithTag(300) as? UILabel, ((subviewstoCorr.layer.name == "size") && (subviewstoCorr.tag != 1))
                                                {
                                                    let btnAtt = CustView.getAttributeDict(fontName: "HelveticaNeue-Bold", alignment:.left, size: 10, color:.init(netHex: 0x22385B))
                                                    let  btnAtStr = NSMutableAttributedString(string: "SELECT SIZE", attributes:btnAtt )
                                                    adjLbl.attributedText = btnAtStr
                                                    adjLbl.setNeedsDisplay()
                                                }
                                                
                                                self.VarSizeArray.removeAllObjects()
                                                contentMod["foot_size"] = "-"
                                                
                                                
                                            }
                                            
                                            self.fetchListOfSize(content: contentMod, completion: { (List) in
                                                self.VarSizeArray.setArray(List as! [Any])
                                            })
                                        }
                                        
                                        
                                    }
                                    
                                    if let ebutton = gesture.view?.superview?.viewWithTag(777) as? UILabel
                                    {
                                        ebutton.backgroundColor = .init(netHex: 0xAAAAAA)
                                    }
                                   
                                }
                                
                                gesture.view?.superview?.layer.setValue(contentMod, forKey: "Data")
                            }
                        }
                    }


                }
                
            }
        }
        
    }
    
    
    func fetchListOfSize(content:NSDictionary, completion:@escaping (NSArray?)->Void)
    {

        
        var unit = NSNumber.init(value: 0)
        var gender = NSNumber.init(value: 0)
        
        if let genderP = content["foot_size_gender"] as? NSNumber { gender = genderP }
        if let unitP = content["foot_size_unit"] as? String {
            if unitP.uppercased() == "UK" { unit = NSNumber.init(value: 1) }
            else if unitP.uppercased() == "EUR" {  unit = NSNumber.init(value: 2) }
            
        }

        Constants.MyNavi.showStatus(string: "Fetching sizes...")
        let request = CustView.RegisterCheck(tokenRequired: false, dataTransfered: nil, theService:"footLength/?unit=\(unit)&gender=\(gender)", Method: "GET")
        Constants.MyNavi.webRequest(hasLoading: true, theRequest: request) { (respo, hasVal, errC) in

            
            if let dictConve = respo as? NSDictionary
            {
                if let arrayConve = dictConve["data"] as? [NSDictionary]
                {
                    let sizesMap = arrayConve.compactMap({ $0["size"] })
                    if sizesMap.count > 0  {
                        let stringArrayOfNumbers = sizesMap.map { ($0 as AnyObject).stringValue }
                        if stringArrayOfNumbers.count > 0
                        {
                             completion(stringArrayOfNumbers as NSArray)
                        }
                       
                        
                    }

                    
                }
                
            }
            
        }
        
    
    }
    
}
