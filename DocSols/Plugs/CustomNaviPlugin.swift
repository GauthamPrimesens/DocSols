//
//  CustomNaviPlugin.swift
//  Custom Zero Plug-in
//
//  Created by Jene Kirishima on 19/07/2016.
//  Copyright © 2016 Fresh Mktg. All rights reserved.
//

import Foundation
import UIKit


//#########################################################################################################################
//LOADING SCREEN
//#########################################################################################################################


public class LoadingScreen: UIView, UIPickerViewDelegate, UIPickerViewDataSource {
    @available(iOS 2.0, *)
    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    let spinner : UIActivityIndicatorView = UIActivityIndicatorView.init(activityIndicatorStyle:  UIActivityIndicatorViewStyle.whiteLarge)
    var pickerList: NSArray?
    let StatusLabel : UILabel = UILabel.init()
    
    let progressLoad : UIProgressView = UIProgressView.init(progressViewStyle: .bar)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.programSetup()
    }
    
    required public init(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)!
        self.programSetup()
    }
    
    
    func programSetup()
    {
        
        
        self.isUserInteractionEnabled = true
        self.backgroundColor = UIColor.clear
        self.spinner.color = UIColor.init(netHex: 0xFF3351)
        
        let bufferWidth:CGFloat = 8.0
        let totalWidth = (self.spinner.frame.size.width + bufferWidth)
        var spinnerFrame: CGRect = spinner.frame
        spinnerFrame.origin.x = (self.bounds.size.width - totalWidth) / 2.0
        spinnerFrame.origin.y = (self.bounds.size.height - spinnerFrame.size.height) / 2.0
        self.spinner.frame = spinnerFrame
        self.spinner.center = CGPoint(x: self.frame.size.width / 2, y:self.frame.size.height / 2)
        let theBlackline: UIView = UIView(frame:   CGRect(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.height))
       
        
        
        theBlackline.center = self.center
        theBlackline.backgroundColor = UIColor(white: 0.0, alpha: 0.4)
        
        
        self.addSubview(self.spinner)
        
        let sizeWProg = self.frame.width/3.0
        self.progressLoad.frame = CGRect(x: sizeWProg, y: CustView.yObject(theview: spinner) + 30.0, width: sizeWProg, height: 2.0)
         self.progressLoad.isHidden = true
        self.progressLoad.isUserInteractionEnabled = false
        self.progressLoad.progress = 0.0
        
        
        self.progressLoad.progressTintColor = UIColor.init(netHex: 0xFF3351)
        self.progressLoad.trackTintColor = UIColor.init(netHex: 0xAAAAAA)
        self.addSubview(self.progressLoad)
        
        
        self.StatusLabel.frame = CGRect(x: 20.0, y: CustView.yObject(theview: spinner) + 35, width: Constants.DeviceProperty.devWidth-40, height: 24)
        self.StatusLabel.text = ""
        self.StatusLabel.font = UIFont.boldSystemFont(ofSize: 18)
        self.StatusLabel.textAlignment = .center
        self.StatusLabel.textColor = .white
        self.StatusLabel.isHidden = true
        self.addSubview(self.StatusLabel)

    }
    
    func showLoading()
    {
        self.spinner.center = self.center
        self.StatusLabel.center = CGPoint(x:  self.spinner.center.x, y: CustView.yObject(theview: spinner) + 47)
        Constants.MyNavi.setloadingStatus(stat: true)
        self.spinner.startAnimating()
        self.isHidden = false
        
    }
    
    
    func hideLoading()
    {
          self.progressLoad.progress = 0.0
         self.progressLoad.isHidden = true
        self.spinner.stopAnimating()
        self.isHidden = true
        
        Constants.MyNavi.setloadingStatus(stat: false)
    }
    
    func LoadingProgressNavi(percent:CGFloat)
    {
        self.progressLoad.progress = Float(percent)
        self.progressLoad.isHidden = false
      //  self.insertSubview(self.spinner, aboveSubview: self.progressLoad)
        self.progressLoad.setNeedsDisplay()

    }
    
    func setupBlur()  {
        //REMOVE BLUR
        let subviews = self.subviews
        for subview : AnyObject in subviews { if subview is UIVisualEffectView { subview.removeFromSuperview() }  }
        
        if !UIAccessibilityIsReduceTransparencyEnabled() {
            self.backgroundColor = UIColor.clear
            
            let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.dark)
            let blurEffectView = UIVisualEffectView(effect: blurEffect)
            blurEffectView.frame = self.bounds
            blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            self.insertSubview(blurEffectView, belowSubview: self.spinner)
         
        }
        else { self.backgroundColor = UIColor.init(white: 0.0, alpha: 0.5) }
    }
    
    
    func showStatusLabel(string:String)
    {
        self.StatusLabel.center = CGPoint(x:  self.spinner.center.x, y: CustView.yObject(theview: spinner) + 47)

        self.StatusLabel.isHidden = false
        self.StatusLabel.text = string
        self.StatusLabel.setNeedsDisplay()

    }
    //##############################################################################################################################################################
    // BLOCKS
    //##############################################################################################################################################################
    
    func showloading(completion:@escaping ()->Void) {
        self.spinner.center = self.center
        self.StatusLabel.center = CGPoint(x:  self.spinner.center.x, y: CustView.yObject(theview: spinner) + 47)
        if !Constants.MyNavi.loadingStatus()
        {
            
            Constants.MyNavi.setloadingStatus(stat: true)
            let toDisableForAnimation = Constants.MyNavi.topViewController?.view
            toDisableForAnimation?.isUserInteractionEnabled = false
            
            self.setupBlur()
            
            self.alpha = 0.0
            self.isHidden = false
            UIView.animate(withDuration: 0.2, delay: 0.0, options: .curveEaseInOut, animations: {() -> Void in
                
                self.alpha = 1.0
            }, completion: {(finished: Bool) -> Void in
                
                self.spinner.startAnimating()
                toDisableForAnimation?.isUserInteractionEnabled = true
                
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    completion()
                }
                
            })
        }
        else
        {  completion() }
        
        
        
    }
    
    func fadeloading(completion:@escaping ()->Void) {
        let toDisableForAnimation = Constants.MyNavi.topViewController?.view
        
        
        
        toDisableForAnimation?.isUserInteractionEnabled = false
        self.spinner.stopAnimating()
        self.progressLoad.isHidden = true
        self.StatusLabel.isHidden = true
        UIView.animate(withDuration: 0.15, delay: 0.0, options: .curveEaseInOut, animations: {() -> Void in
            
            self.alpha = 0.0
            }, completion: {(finished: Bool) -> Void in
              
                toDisableForAnimation?.isUserInteractionEnabled = true
                self.isHidden = true
                Constants.MyNavi.setloadingStatus(stat: false)
           
                completion()
                
                
        })
    }
    
    
    //##########################################################################################################
    //Picker
    //##########################################################################################################
    func OApickercreate(ArrayContents:NSArray, completion:@escaping (String, Int)->Void) {
        self.spinner.stopAnimating()
        self.progressLoad.isHidden = true
        self.StatusLabel.isHidden = true
        let subviews = self.subviews
        for removeMe : AnyObject in subviews
        {
            if (!(removeMe.isEqual(self.progressLoad)) && !(removeMe.isEqual(self.spinner)) && (removeMe is UIPickerView) && (removeMe is UIDatePicker))  { removeMe.removeFromSuperview() }
        }
        
        
        self.setupBlur()
        self.pickerList = ArrayContents
        let thePicker : UIPickerView = UIPickerView.init(frame:CGRect(x:0,  y: self.frame.height - 160, width:self.frame.width, height: 160))
        thePicker.backgroundColor = UIColor.white
        thePicker.layer.cornerRadius = 10.0
        thePicker.showsSelectionIndicator = true
        thePicker.dataSource = self
        thePicker.delegate = self
        
        
        let selectPButton = ActionButton.init()
        selectPButton.CreateButtonPicker(frame: CGRect(x:self.frame.width - (85*2),  y: self.frame.height - 160 - 50, width:75, height: 40), title:"Select", completion: completion)
        selectPButton.backgroundColor = .clear
        selectPButton.layer.cornerRadius = 20.0
        selectPButton.layer.borderWidth = 1.5
        selectPButton.layer.borderColor = UIColor.white.cgColor
        selectPButton.layer.setValue(self, forKey:"selfCover")
        self.addSubview(selectPButton)
        
        let cancelPButton = ActionButton.init()
        cancelPButton.CreateButtonPicker(frame: CGRect(x:CustView.xObject(theview: selectPButton) + 10,  y: selectPButton.frame.origin.y, width:75, height: 40), title:"Cancel", completion:{(str,id)->Void in})
        cancelPButton.backgroundColor = .clear
        cancelPButton.layer.cornerRadius = 20.0
        cancelPButton.layer.borderWidth = 1.5
        cancelPButton.layer.borderColor = UIColor.white.cgColor
        cancelPButton.layer.setValue(self, forKey:"selfCover")
        self.addSubview(cancelPButton)
        
        
        thePicker.reloadAllComponents()
        self.addSubview(thePicker)
        self.alpha = 0.0
        self.isHidden = false
        self.layer.setValue(thePicker, forKey:"thePicker")
        self.layer.setValue(ArrayContents, forKey:"pickerArray")
        thePicker.isUserInteractionEnabled = false
        
        Constants.MyNavi.setloadingStatus(stat: true)
        UIView.animate(withDuration: 0.2, delay: 0.0, options: .curveEaseInOut, animations: {() -> Void in
            
            self.alpha = 1.0
            }, completion: {(finished: Bool) -> Void in
                
                thePicker.isUserInteractionEnabled = true
                
        })
    }
    
    
    
    
    //##########################################################################################################
    //Picker Delegate
    //##########################################################################################################
    public func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.pickerList!.count
    }
    
    public func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return (self.pickerList![row] as! String)
    }
    
    
//    public func pickerView(pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusingView view: UIView?) -> UIView {
//        <#code#>
//    }
    public func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        
        var label = view as! UILabel?
        if label == nil {
            label = UILabel()
        }
        
        let data = (self.pickerList![row] as! String)
        let fontBeLike = UIFont.systemFont(ofSize: 18)
        label?.font = fontBeLike
        label?.adjustsFontSizeToFitWidth = true
        label?.text = data
        label?.textAlignment = .center
//        label.numberOfLines = 0
//        label.lineBreakMode = .ByWordWrapping
        return label!
        
    }
    
    
    //##########################################################################################################
    //Date Picker
    //##########################################################################################################
    func OADatePCreate(minDate:Date?, maxDate:Date?, completion:@escaping (String, Int)->Void) {
        self.spinner.stopAnimating()
        self.progressLoad.isHidden = true
        self.StatusLabel.isHidden = true
        let subviews = self.subviews
        for removeMe : AnyObject in subviews
        {
            if (!(removeMe.isEqual(self.progressLoad)) && !(removeMe.isEqual(self.spinner)) && (removeMe is UIPickerView) && (removeMe is UIDatePicker))  { removeMe.removeFromSuperview() }
        }
        
        
        self.setupBlur()
//        self.pickerList = ArrayContents
        let datePicker : UIDatePicker = UIDatePicker.init(frame:CGRect(x:0,  y: self.frame.height - 160, width:self.frame.width, height: 160))
        datePicker.backgroundColor = .white
        datePicker.layer.cornerRadius = 10.0
        datePicker.minimumDate = minDate
        datePicker.maximumDate = maxDate
        datePicker.datePickerMode = .date
        datePicker.setDate(Date(), animated: false)
 
        
        let selectPButton = ActionButton.init()
        selectPButton.CreateButtonDPicker(frame: CGRect(x:self.frame.width - (85*2),  y: self.frame.height - 160 - 50, width:75, height: 40), title:"Done", completion: completion)
        selectPButton.backgroundColor = .clear
        selectPButton.layer.cornerRadius = 20.0
        selectPButton.layer.borderWidth = 1.5
        selectPButton.layer.borderColor = UIColor.white.cgColor
        selectPButton.layer.setValue(self, forKey:"selfCover")
        self.addSubview(selectPButton)
        
        let cancelPButton = ActionButton.init()
        cancelPButton.CreateButtonDPicker(frame: CGRect(x:CustView.xObject(theview: selectPButton) + 10,  y: selectPButton.frame.origin.y, width:75, height: 40), title:"Cancel", completion:{(str,id)->Void in})
        cancelPButton.backgroundColor = .clear
        cancelPButton.layer.cornerRadius = 20.0
        cancelPButton.layer.borderWidth = 1.5
        cancelPButton.layer.borderColor = UIColor.white.cgColor
        cancelPButton.layer.setValue(self, forKey:"selfCover")
        self.addSubview(cancelPButton)
        
        
        self.addSubview(datePicker)
        self.alpha = 0.0
        self.isHidden = false
        self.layer.setValue(datePicker, forKey:"datePicker")
//        self.layer.setValue(ArrayContents, forKey:"pickerArray")
        datePicker.isUserInteractionEnabled = false
        
        Constants.MyNavi.setloadingStatus(stat: true)
        UIView.animate(withDuration: 0.2, delay: 0.0, options: .curveEaseInOut, animations: {() -> Void in
            
            self.alpha = 1.0
        }, completion: {(finished: Bool) -> Void in
            
            datePicker.isUserInteractionEnabled = true
            
        })
    }
}


//#########################################################################################################################
//ACTION BUTTON
//#########################################################################################################################
public class ActionButton: UIView {
    var buttonBlock : ()->Void = {()->Void in}
    var pickerButton : (String, Int)-> Void = {(String, Int)->Void in}
    var buttonName : String = ""
    var isBold : Bool = false
    
    override init(frame: CGRect) { super.init(frame: frame) }
    
    required public init(coder aDecoder: NSCoder) {  super.init(coder: aDecoder)! }
    
    func layout(frame:CGRect, isArrowed:Bool) {
        let theAttN = CustView.getAttributeDict(fontName:self.isBold ? "Helvetica-Bold" : "Helvetica", alignment:.center, size: 16, color:UIColor.init(netHex: 0x191919))
     //   let theimageEx : UIImage = UIImage(named:"R_Arrow")!
        
        let theAttStrN = NSAttributedString(string:self.buttonName, attributes: theAttN )
        
        
        let buttonLbl : UILabel = CustView.statLabel(rect: CGRect(x:10,  y:  10, width:frame.size.width-20, height: frame.size.height-20), attStr: theAttStrN)
        self.addSubview(buttonLbl)
        self.layer.cornerRadius = 5.0
        self.frame = frame
    }
    
    func layoutH(frame:CGRect, isTop:Bool) {
        let theAttN = CustView.getAttributeDict(fontName: "Avenir-Book", alignment:.center, size: isTop ? 15 : 12, color:UIColor.white)
        let theAttStrN = NSAttributedString(string:self.buttonName, attributes: theAttN )
       
        
        let buttonLbl : UILabel = CustView.statLabel(rect: CGRect(x:10,  y: 10, width:frame.size.width-20, height: frame.size.height-20), attStr: theAttStrN)
        self.addSubview(buttonLbl)
        self.layer.cornerRadius = frame.size.height/2.0
        self.layer.borderColor = UIColor.white.cgColor
        self.layer.borderWidth = 2.0
        self.frame = frame
    }
    
    func layoutM(frame:CGRect, isHighlight:Bool) {
        let theAttN = CustView.getAttributeDict(fontName: "HelveticaNeue-Bold", alignment:.center, size: 12, color:isHighlight ? UIColor.white : .init(netHex: 0x22385B))
        let theAttStrN = NSAttributedString(string:self.buttonName, attributes: theAttN )
        
        let buttonLbl : UILabel = CustView.statLabel(rect: CGRect(x:10,  y: 10, width:frame.size.width-20, height: frame.size.height-20), attStr: theAttStrN)
        self.addSubview(buttonLbl)
        self.layer.cornerRadius = 5.0
        self.layer.borderColor = isHighlight ? UIColor.clear.cgColor : UIColor.init(netHex: 0x22385B).cgColor
        self.layer.borderWidth = 1.0
        self.frame = frame
    }
    
    func Layout_ImgBtn(frame:CGRect, isYes:Bool)
    {
        let theImageBe = UIImageView.init(frame:  CGRect(origin: CGPoint.zero, size: frame.size) )
        theImageBe.image = UIImage.init(named:isYes ?  "btnYES" : "btnNO")
        theImageBe.contentMode = .scaleAspectFit
        self.addSubview(theImageBe)
        self.frame = frame
        
    }
    
    func CreateButtonName(title:String, completion : @escaping ()->Void) {
        self.buttonBlock = completion
        self.buttonName = title
        
        
        let gesture : UITapGestureRecognizer = UITapGestureRecognizer.init(target: self, action:#selector(callaction(_:)))
        gesture.numberOfTapsRequired = 1
        self.isUserInteractionEnabled = true
        self.addGestureRecognizer(gesture)
    }
    
    @objc func callaction(_ tapRec:UITapGestureRecognizer) {
        
        
        let tappedView : UIView = tapRec.view!
        let toHide : UIView = tappedView.layer.value(forKey: "selfCover") as! UIView
        let theAlert : UIView = toHide.layer.value(forKey: "AlertEx") as! UIView
        
        theAlert.isUserInteractionEnabled = false
        UIView.animate(withDuration: 0.25, delay: 0.0, options: .curveEaseInOut, animations: {() -> Void in
            
            toHide.alpha = 0.0
            }, completion: {(finished: Bool) -> Void in
                toHide.isHidden = true
                theAlert.isUserInteractionEnabled = true
                theAlert.removeFromSuperview()
                
                let subviews = theAlert.subviews
                for viewsE : AnyObject in subviews
                {
                    if (viewsE is ActionButton)
                    {
                        for recogs : UIGestureRecognizer in viewsE.gestureRecognizers! {  viewsE.removeGestureRecognizer(recogs) }
                    }
                }
                
                
                Constants.MyNavi.setloadingStatus(stat: false)
                
                self.buttonBlock()
        })
    }
    
    
    func CreateButtonPicker(frame:CGRect, title:String, completion : @escaping (String, Int)-> Void) {
        self.pickerButton = completion
        self.buttonName = title
        
        
        let gesture : UITapGestureRecognizer = UITapGestureRecognizer.init(target: self, action:#selector(SelectItemPicker(_:)))
        gesture.numberOfTapsRequired = 1
        self.isUserInteractionEnabled = true
        self.addGestureRecognizer(gesture)
        
        
        let theAttN = CustView.getAttributeDict(fontName: "Avenir-Book", alignment:.center, size: 15, color:UIColor.white)
        let theAttStrN =  NSAttributedString(string:self.buttonName, attributes: theAttN )
        let buttonLbl : UILabel = CustView.statLabel(rect: CGRect(x:10,  y: 10, width:frame.size.width-20, height: frame.size.height-20), attStr: theAttStrN)
        self.addSubview(buttonLbl)
        self.layer.cornerRadius = 3.0
        self.frame = frame
    }
    
    func CreateButtonDPicker(frame:CGRect, title:String, completion : @escaping (String, Int)-> Void) {
        self.pickerButton = completion
        self.buttonName = title
        
        
        let gesture : UITapGestureRecognizer = UITapGestureRecognizer.init(target: self, action:#selector(SelectDateItem(_:)))
        gesture.numberOfTapsRequired = 1
        self.isUserInteractionEnabled = true
        self.addGestureRecognizer(gesture)
        
        
        let theAttN = CustView.getAttributeDict(fontName: "Avenir-Book", alignment:.center, size: 15, color:UIColor.white)
        let theAttStrN =  NSAttributedString(string:self.buttonName, attributes: theAttN )
        let buttonLbl : UILabel = CustView.statLabel(rect: CGRect(x:10,  y: 10, width:frame.size.width-20, height: frame.size.height-20), attStr: theAttStrN)
        self.addSubview(buttonLbl)
        self.layer.cornerRadius = 3.0
        self.frame = frame
    }
    
    @objc func SelectDateItem(_ tapRec:UITapGestureRecognizer)
    {
        let tappedView : UIView = tapRec.view!
        let toHide : UIView = tappedView.layer.value(forKey: "selfCover") as! UIView
        let thePicker : UIDatePicker = toHide.layer.value(forKey: "datePicker") as! UIDatePicker
        
        
        
        thePicker.isUserInteractionEnabled = false
        UIView.animate(withDuration: 0.25, delay: 0.0, options: .curveEaseInOut, animations: {() -> Void in
            
            toHide.alpha = 0.0
        }, completion: {(finished: Bool) -> Void in
            toHide.isHidden = true
            thePicker.isUserInteractionEnabled = true
            thePicker.removeFromSuperview()
            
            let subviews = toHide.subviews
            for viewsE : AnyObject in subviews
            {
                if (viewsE is ActionButton)
                {
                    viewsE.removeFromSuperview()
                }
            }
            
       
            let dateformatter = DateFormatter.init()
            dateformatter.dateFormat = "MM / dd / yyyy"
            dateformatter.locale = NSLocale.current
            
            let stringText = dateformatter.string(from: thePicker.date  as Date)
            
            Constants.MyNavi.setloadingStatus(stat: false)
            self.pickerButton(stringText, 0)
        })
    }
    
    @objc func SelectItemPicker(_ tapRec:UITapGestureRecognizer)
    {
        let tappedView : UIView = tapRec.view!
        let toHide : UIView = tappedView.layer.value(forKey: "selfCover") as! UIView
        let thePicker : UIPickerView = toHide.layer.value(forKey: "thePicker") as! UIPickerView
        let arrayofText = toHide.layer.value(forKey: "pickerArray") as! NSArray

        
        
        thePicker.isUserInteractionEnabled = false
        UIView.animate(withDuration: 0.25, delay: 0.0, options: .curveEaseInOut, animations: {() -> Void in
            
            toHide.alpha = 0.0
            }, completion: {(finished: Bool) -> Void in
                toHide.isHidden = true
                thePicker.isUserInteractionEnabled = true
                thePicker.removeFromSuperview()
                
                let subviews = toHide.subviews
                for viewsE : AnyObject in subviews
                {
                    if (viewsE is ActionButton)
                    {
                        viewsE.removeFromSuperview()
                    }
                }
                
                let theReturnIndex =  thePicker.selectedRow(inComponent: 0)
//                let test = thePicker.delegate?.pickerView!(thePicker, titleForRow:theReturnIndex, forComponent: 0)
                let stringText = arrayofText[theReturnIndex] as? String
                
                Constants.MyNavi.setloadingStatus(stat: false)
                self.pickerButton(stringText!, theReturnIndex)
        })
    }
}

//#########################################################################################################################
//CUSTOM ALERT BLOCK BASED
//#########################################################################################################################
@available(iOS 8.2, *)
extension LoadingScreen {
    func OAshow(title:String, themessage:String, with buttons:NSArray)
    {
        self.spinner.stopAnimating()
        self.progressLoad.isHidden = true
        self.StatusLabel.isHidden = true
        let subviews = self.subviews
        for removeMe : AnyObject in subviews
        {
            if (!(removeMe.isEqual(self.progressLoad)) && !(removeMe.isEqual(self.spinner)) && (removeMe is UIPickerView) && (removeMe is UIDatePicker)) { removeMe.removeFromSuperview() }
        }
        
        
        self.setupBlur()
        let sidespace : CGFloat = 60
        let w_Alert = self.frame.width - sidespace
        
        
        let titleAtt = CustView.getAttributeDict(fontName: "HelveticaNeue-Medium", alignment:.center, size: 17, color:.init(r: 0, g: 0, b: 0))
        let titleAttStr = NSMutableAttributedString(string:title, attributes:titleAtt )
        
        let spaceAtt = CustView.getAttributeDict(fontName: "HelveticaNeue", alignment:.center, size: 5, color:.init(r: 0, g: 0, b: 0))
        let spaceAttStr = NSAttributedString(string:"\n\n", attributes:spaceAtt )
        
        let MsgAtt = CustView.getAttributeDict(fontName: "HelveticaNeue", alignment:.center, size: 14, color:.init(r: 0, g: 0, b: 0))
        let MsgAttStr = NSAttributedString(string:themessage, attributes:MsgAtt )
        
        if ((title.count > 0) && (themessage.count > 0)) { titleAttStr.append(spaceAttStr)  }
        
        titleAttStr.append(MsgAttStr)
        let theSize : CGRect = titleAttStr.boundingRect(with: CGSize(width:w_Alert-30, height: CGFloat.greatestFiniteMagnitude), options: [.usesLineFragmentOrigin, .usesFontLeading], context: nil)
        let theView : UIView = UIView.init()
        
        let bodyLbl : UILabel = CustView.statLabel(rect: CGRect(x:15,  y: 15, width:w_Alert-30, height: theSize.size.height > 300 ? 300 : theSize.size.height), attStr: titleAttStr)
        theView.addSubview(bodyLbl)
        
        var endHeight :CGFloat = CustView.yObject(theview: bodyLbl)
        
        
        
        
        
        if (buttons.count > 0) {
            if (buttons.count > 1) {
                let btnWidthEx : CGFloat  = (w_Alert/2);
                for x in (0 ..< 2 )
                {
                    
                    let cstBtn : ActionButton = buttons[x] as! ActionButton
                    cstBtn.layout(frame: CGRect(x:(btnWidthEx * CGFloat(x)),  y: CustView.yObject(theview:bodyLbl) + 15 , width:btnWidthEx, height: 45), isArrowed: false)
                    theView.addSubview(cstBtn)
                    cstBtn.layer.setValue(self, forKey: "selfCover")
                    endHeight = CustView.yObject(theview:cstBtn)
                }
            }
            else
            {
                let sgBtn : ActionButton = buttons.lastObject as! ActionButton
                sgBtn.layout(frame: CGRect(x:0,  y: CustView.yObject(theview:bodyLbl) + 15 ,width:w_Alert, height: 45), isArrowed: false)
                theView.addSubview(sgBtn)
                sgBtn.layer.setValue(self, forKey: "selfCover")
                endHeight = CustView.yObject(theview:sgBtn)
            }
            
        }
        else
        {
            let defaultBtn : ActionButton =  CustView.OAbuttoncreate(txtlbl: "OK", completion: {()->Void in })
            defaultBtn.layout(frame: CGRect(x:0,  y: CustView.yObject(theview:bodyLbl) + 15 , width:w_Alert, height: 45), isArrowed: false)
            defaultBtn.layer.setValue(self, forKey: "selfCover")
            theView.addSubview(defaultBtn)
            endHeight = CustView.yObject(theview:defaultBtn)
        }
        
        
        
        theView.backgroundColor = .white
        theView.clipsToBounds = true
        
        theView.frame = CGRect(x:sidespace/2,  y: (self.frame.height - (0 + endHeight))/2, width:w_Alert,  height: (endHeight))
        theView.layer.cornerRadius = 7.0
        
        //### adding Line ###########
        let originY : CGFloat = CustView.yObject(theview: bodyLbl) + 15
        let pathShape : UIBezierPath = UIBezierPath.init()
        pathShape.move(to: CGPoint(x:0, y:originY))
        pathShape.addLine(to: CGPoint(x:w_Alert, y:originY))
        
        if (buttons.count > 1)
        {
            pathShape.move(to: CGPoint(x:w_Alert/2.0, y:originY))
            pathShape.addLine(to: CGPoint(x:w_Alert/2.0, y:endHeight))
        }
        
        let calayer : CAShapeLayer = CAShapeLayer.init()
        calayer.path = pathShape.cgPath
        calayer.fillColor = UIColor.clear.cgColor
        calayer.lineWidth = 0.5
        calayer.strokeColor = UIColor.init(netHex: 0xb2b2b2, a: 1.0).cgColor
        theView.layer.addSublayer(calayer)
        
        
        
        //##########################
        
        
        
        
        self.addSubview(theView)
        
        
        
        self.alpha = 0.0
        self.isHidden = false
        self.layer.setValue(theView, forKey:"AlertEx")
        theView.isUserInteractionEnabled = false
        Constants.MyNavi.setloadingStatus(stat: true)
        UIView.animate(withDuration: 0.2, delay: 0.0, options: .curveEaseInOut, animations: {() -> Void in
            
            self.alpha = 1.0
        }, completion: {(finished: Bool) -> Void in
            
            theView.isUserInteractionEnabled = true
            
        })
    }
    
    
    func CustomOAshow(title:String, withColor titC:UIColor, themessage:String, withColor messC:UIColor, with buttons:NSArray) {
        self.spinner.stopAnimating()
        self.progressLoad.isHidden = true
        self.StatusLabel.isHidden = true
        let subviews = self.subviews
        for removeMe : AnyObject in subviews
        {
            if (!(removeMe.isEqual(self.progressLoad)) && !(removeMe.isEqual(self.spinner)) && (removeMe is UIPickerView) && (removeMe is UIDatePicker)) { removeMe.removeFromSuperview() }
        }
        
        
        self.setupBlur()
        let sidespace : CGFloat = 60
        let w_Alert = self.frame.width - sidespace
        
        
        let titleAtt = CustView.getAttributeDict(fontName: "HelveticaNeue-Bold", alignment:.center, size: 16, color:titC)
        let titleAttStr = NSMutableAttributedString(string:title, attributes:titleAtt )
        
        let spaceAtt = CustView.getAttributeDict(fontName: "HelveticaNeue-Light", alignment:.center, size: 8, color:.init(r: 0, g: 0, b: 0))
        let spaceAttStr = NSAttributedString(string:"\n\n\n", attributes:spaceAtt )
        
        let MsgAtt = CustView.getAttributeDict(fontName: "HelveticaNeue-Light", alignment:.center, size: 12, color:messC)
        let MsgAttStr = NSAttributedString(string:themessage, attributes:MsgAtt )
        
        if ((title.count > 0) && (themessage.count > 0)) { titleAttStr.append(spaceAttStr)  }
        
        titleAttStr.append(MsgAttStr)
        let theSize : CGRect = titleAttStr.boundingRect(with: CGSize(width:w_Alert-30, height:CGFloat.greatestFiniteMagnitude), options: [.usesLineFragmentOrigin, .usesFontLeading], context: nil)
        let theView : UIView = UIView.init()


        
        print("--> size \(theSize.size.height)")
        let LIMITER = self.frame.height - 65
//        let bodyLbl : UILabel = CustView.statLabel(CGRect(15, 30, w_Alert-30, theSize.size.height > LIMITER ? LIMITER : theSize.size.height), attStr: titleAttStr)
//        theView.addSubview(bodyLbl)
        
        
        
        
        let bodyLbl : UITextView = UITextView.init(frame: CGRect(x:15,y: 30,width:w_Alert-30,   height: (theSize.size.height > LIMITER ? LIMITER : theSize.size.height) + 12))
        bodyLbl.backgroundColor = .clear
        bodyLbl.attributedText = titleAttStr
        bodyLbl.isEditable = false
        bodyLbl.bounces = false
        bodyLbl.showsVerticalScrollIndicator = false
        bodyLbl.showsHorizontalScrollIndicator = false
        bodyLbl.textContainerInset = UIEdgeInsets.zero
        bodyLbl.textContainer.lineFragmentPadding = 0.0
        bodyLbl.textContainer.lineBreakMode = .byWordWrapping
        bodyLbl.isScrollEnabled = false
        
        if  (theSize.size.height > LIMITER) {
             bodyLbl.bounces = true
            bodyLbl.isScrollEnabled = true
             bodyLbl.showsVerticalScrollIndicator = true
        }

        
        theView.addSubview(bodyLbl)
        
        if #available(iOS 11.0, *) {
            bodyLbl.contentInsetAdjustmentBehavior = .never
        } 
  
        
        let buttonSize = (w_Alert - 70)*0.5
        if (buttons.count > 0) {
         
            if (buttons.count > 1) {
                for x in (0 ..< 2 )
                {
                    
                    let cstBtn : ActionButton = buttons[x] as! ActionButton
                    cstBtn.layoutM(frame: CGRect(x:30 + CGFloat(x)*(buttonSize + 10),  y: CustView.yObject(theview:bodyLbl) + 10  , width:buttonSize, height: 40), isHighlight:x == 0 ? false : true)
              
                    cstBtn.backgroundColor = (x == 0 ? .clear : .init(netHex:0xff6a2b))
                    theView.addSubview(cstBtn)
                    cstBtn.layer.setValue(self, forKey: "selfCover")
                }
            }
            else
            {
         
                
                let sgBtn : ActionButton = buttons.lastObject as! ActionButton
                sgBtn.layoutM(frame: CGRect(x:(w_Alert - buttonSize) * 0.5,  y: CustView.yObject(theview:bodyLbl) + 10  , width:buttonSize, height: 40), isHighlight:true)
                
                sgBtn.backgroundColor = .init(netHex:0xff6a2b)
                theView.addSubview(sgBtn)
                sgBtn.layer.setValue(self, forKey: "selfCover")
            }
            
        }
        else
        {
            let sgBtn : ActionButton = CustView.OAbuttoncreate(txtlbl: "Okay", completion: {()->Void in })
            sgBtn.layoutM(frame: CGRect(x:(w_Alert - buttonSize) * 0.5,  y: CustView.yObject(theview:bodyLbl) + 10  , width:buttonSize, height: 40), isHighlight:true)
            
            sgBtn.backgroundColor = .init(netHex:0xff6a2b)
            theView.addSubview(sgBtn)
            sgBtn.layer.setValue(self, forKey: "selfCover")
            
    
        }
        
        
        theView.layer.cornerRadius = 10.0
        theView.backgroundColor = .white
        theView.clipsToBounds = true
        
        let endHeight = CustView.yObject(theview:bodyLbl) + 10 + 40
        theView.frame = CGRect(x:sidespace/2, y:  (self.frame.height - (15 + endHeight))/2, width:w_Alert, height: (25 + endHeight))
        
        self.addSubview(theView)
        
        
        if #available(iOS 11.0, *) {
            bodyLbl.contentInsetAdjustmentBehavior = .never
        }
        
        self.alpha = 0.0
        self.isHidden = false
        self.layer.setValue(theView, forKey:"AlertEx")
        theView.isUserInteractionEnabled = false
        Constants.MyNavi.setloadingStatus(stat: true)
        UIView.animate(withDuration: 0.2, delay: 0.0, options: .curveEaseInOut, animations: {() -> Void in
            
            self.alpha = 1.0
            }, completion: {(finished: Bool) -> Void in
                
                theView.isUserInteractionEnabled = true
                
        })
    }
    
    
    //##############################################################################################################################################################
    // REQUESTS
    //##############################################################################################################################################################

    
    func LoadJSONRequest(theRequest:NSMutableURLRequest, with returnCompletion:@escaping (Any, Bool, Int)->Void) {
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        
        let task =  session.dataTask(with: theRequest as URLRequest, completionHandler: {(data, response, error) in
            var statC : Int = 0
            if let httpResponse = response as? HTTPURLResponse {
                statC = httpResponse.statusCode
                print("statusCode ", httpResponse.statusCode)
            }
            var jsonResult : Any = []
            var strAvail : Bool = false
            if ((data != nil) && (data!.count > 0)) {
                strAvail = true
                do { jsonResult = try JSONSerialization.jsonObject(with: data!, options:[]) }
                catch let dataError {
                    // Did the JSONObjectWithData constructor return an error? If so, log the error to the console
                    print(dataError)
                    let jsonStr = String(data:data!, encoding: String.Encoding.utf8)
                    print("content of Data", jsonStr!)
                }
                
            }
            
            
            DispatchQueue.main.async {
                returnCompletion(jsonResult,strAvail, statC)
                
            }
            
            
        })
        
        task.resume( )
    }
    
    
  
  
}



