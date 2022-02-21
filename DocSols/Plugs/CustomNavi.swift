//
//  CustomNavi.swift
//  Custom Zero Plug-in
//
//  Created by Jene Kirishima on 19/07/2016.
//  Copyright © 2016 Fresh Mktg. All rights reserved.
//


import Foundation
import UIKit

struct Constants {
    
    //bid = com.redddigital.DocSols
    //bid = com.redddigital.DocSols-FTP
    //com.redddigital.DocSols
    
    struct webSvc
    {
        static let baseApi = "https://docsols.azurewebsites.net/api/" //"https://docsols.appcontrol.com.au/api/"
        static let liveApi = "https://docsols.azurewebsites.net/api/"
    }
    
    static let Test_Mode : Bool = false
    static let Location_DelayChecker : UInt64 = 60
    static let userUID = UIDevice.current.identifierForVendor?.uuidString.uppercased()
    
    
    struct DeviceProperty {
        static let devWidth = UIScreen.main.bounds.size.width
        static let devHeight = UIScreen.main.bounds.size.height
        static let iPhone6Height = 667
        static let iPhone6PlusHeight = 736
        static let iPhone5Height = 568
        static let KBHeight = 300
    }
    

    
    static let MyNavi = ((UIApplication.shared.delegate as! AppDelegate).window!.rootViewController! as! MyNavigationController)

    

    
    struct SaveKey
    {
        static let profile = "DocSols_DataKey_ArchivedProfile"
        static let scans = "DocSols_DataKey_Scans"
        static let token = "DocSols_DataKey_AccessToken"
        static let userID = "DocSols_DataKey_PROFILE_ID"
        
        static let termsKey = "DocSols_DataKey_AGREETRIGGER"
        
        static let countryKey = "DocSols_DataKey_CountryListKey"
        static let errorIDs = "DocSols_DataKey_FlushID"
    }
    
    struct cameraSubs
    {
        static let FloorHt : CGFloat = 50.0
    }
}

enum Arrow_Layer {
    case left
    case right
    case up
    case down
}

enum slider_type {
    case height
    case weight
    case age
}

extension String {
    func deletingPrefix(_ prefix: String) -> String {
        guard self.hasPrefix(prefix) else { return self }
        return String(self.dropFirst(prefix.count))
    }
}

extension StringProtocol {
    var firstUppercased: String {
        guard let first = first else { return "" }
        return String(first).uppercased() + dropFirst()
    }
}

extension UIColor {
    
    
    
    convenience init(red: Int, green: Int, blue: Int, a:CGFloat) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: a)
    }
    
    convenience init(netHex:Int) {
        self.init(red:(netHex >> 16) & 0xff, green:(netHex >> 8) & 0xff, blue:netHex & 0xff, a:1.0)
    }
    
    convenience init(r:CGFloat, g:CGFloat, b:CGFloat) {
        self.init(red: (r/255.0), green: (g/255.0), blue: (b/255.0), alpha: 1.0)
    }
    
    convenience init(netHex:Int, a:CGFloat) {
        self.init(red:(netHex >> 16) & 0xff, green:(netHex >> 8) & 0xff, blue:netHex & 0xff, a:a)
    }
}


extension UIImage {
    func makeImageWithColorAndSize(color: UIColor, size: CGSize) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        color.setFill()
        UIRectFill(CGRect(x: 0, y: 0, width: size.width, height: size.height))
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
    
    func jpeg(_ quality:CGFloat) -> Data? {
        return UIImageJPEGRepresentation(self, quality)
    }
    
    convenience init(view: UIView) {
        UIGraphicsBeginImageContext(view.frame.size)
        view.layer.render(in:UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        self.init(cgImage: image!.cgImage!)
    }
    
   
}

extension String {
    var floatValue: Float {
        return (self as NSString).floatValue
    }
}

extension UILabel {
    func setTextColorToGradient(image: UIImage) {
        UIGraphicsBeginImageContext(frame.size)
        image.draw(in: bounds)
        let myGradient = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        self.textColor = UIColor(patternImage: myGradient!)
    }
    
    private struct AssociatedKeys {
        static var padding = UIEdgeInsets()
    }
    
    public var padding: UIEdgeInsets? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.padding) as? UIEdgeInsets
        }
        set {
            if let newValue = newValue {
                objc_setAssociatedObject(self, &AssociatedKeys.padding, newValue as UIEdgeInsets?, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            }
        }
    }
    
    override open func draw(_ rect: CGRect) {
        if let insets = padding {
            self.drawText(in: UIEdgeInsetsInsetRect(rect, insets))
        } else {
            self.drawText(in: rect)
        }
    }
    
    override open var intrinsicContentSize: CGSize {
        guard let text = self.text else { return super.intrinsicContentSize }
        
        var contentSize = super.intrinsicContentSize
        var textWidth: CGFloat = frame.size.width
        var insetsHeight: CGFloat = 0.0
        
        if let insets = padding {
            textWidth -= insets.left + insets.right
            insetsHeight += insets.top + insets.bottom
        }
        
        let newSize = text.boundingRect(with: CGSize(width: textWidth, height: CGFloat.greatestFiniteMagnitude),
                                        options: NSStringDrawingOptions.usesLineFragmentOrigin,
                                        attributes: [NSAttributedStringKey.font: self.font], context: nil)
        
        contentSize.height = ceil(newSize.size.height) + insetsHeight
        
        return contentSize
    }
}

extension UIView {
    
    // OUTPUT 1
    func dropShadow(scale: Bool = true) {
        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 0.5
        self.layer.shadowOffset = CGSize(width: -1, height: 1)
        self.layer.shadowRadius = 1
        
        self.layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        // self.layer.shouldRasterize = true
        self.layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
    
    // OUTPUT 2
    func dropShadow(color: UIColor, opacity: Float = 0.5, offSet: CGSize, radius: CGFloat = 1, scale: Bool = true) {
        self.layer.masksToBounds = false
        self.layer.shadowColor = color.cgColor
        self.layer.shadowOpacity = opacity
        self.layer.shadowOffset = offSet
        self.layer.shadowRadius = radius
        
        self.layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        //  self.layer.shouldRasterize = true
        self.layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
}

extension Array {
    mutating func shuffleArr() {
        for i in 0 ..< (count - 1) {
     
            let j = Int(arc4random_uniform(UInt32(count - i))) + i
            swapAt(i, j)
  
        }

    }
}
//#########################################################################################################################

//#########################################################################################################################
class MyNavigationController: UINavigationController, UINavigationControllerDelegate, UIScrollViewDelegate, UITextFieldDelegate {
    let DisablerView : LoadingScreen = LoadingScreen.init(frame:(CGRect(x: 0, y: 0, width: Constants.DeviceProperty.devWidth, height: Constants.DeviceProperty.devHeight)))

    var isLoading : Bool = false

    var TempoProfile : NSDictionary = NSDictionary.init()
    var TempoScans : NSArray = NSArray.init()
    var updateScans:Bool = false
    var updateInfo:Bool = false
    
    var AccessToken : String = "-"
    var referelCounter : Int = 3
    
    @IBOutlet var scrollLogin : UIScrollView?
    @IBOutlet var loginVIew : UIView?

    
    override func viewDidLoad() {
        
        
        UIApplication.shared.isIdleTimerDisabled = true
        super.viewDidLoad()
        
        self.scrollLogin?.frame = self.view.frame
        self.scrollLogin?.contentSize = self.view.frame.size
        
        let xLog = (self.view.frame.size.width - 300)*0.5
        let yLog = (self.view.frame.size.height - 230)*0.5
        self.loginVIew?.frame = CGRect(x: xLog, y: yLog, width: 300, height: 230)
        
        self.scrollLogin?.addSubview(self.loginVIew!)
        self.view.addSubview(self.scrollLogin!)
        self.view.addSubview(self.DisablerView)
        self.DisablerView.hideLoading()
    
        let gesture : UITapGestureRecognizer = UITapGestureRecognizer.init(target: self, action:#selector(tapToHide(_:)))
        gesture.numberOfTapsRequired = 1
        self.scrollLogin?.isUserInteractionEnabled = true
        self.scrollLogin?.addGestureRecognizer(gesture)
        
        
        for pView in (self.loginVIew?.subviews)!
        {
            if let textField = pView as? UITextField
            {
                
                let paddingView: UIView = UIView.init(frame: CGRect(x: 0, y: 0, width: 5.0, height: textField.frame.size.height))
                textField.leftView = paddingView
                textField.leftViewMode = .always
                textField.delegate = self
                textField.addTarget(self, action: #selector(TFChange(_:)), for: .editingChanged   )
                
            }
        }
        
        
        if #available(iOS 11.0, *) {
            self.scrollLogin?.contentInsetAdjustmentBehavior = .never
        } else { self.automaticallyAdjustsScrollViewInsets = false  }

    }
    
    
    
    override var shouldAutorotate: Bool {
        return (self.viewControllers.last?.shouldAutorotate)!
    }
//
    override var supportedInterfaceOrientations : UIInterfaceOrientationMask {
        return (self.viewControllers.last?.supportedInterfaceOrientations)!
    }
    
    @objc func tapToHide(_ gesture: UITapGestureRecognizer)
    {
        self.view.endEditing(true)
        self.hideLogin()
    }

    
    //#####################################################################################################################
    //LOGIN
    //#####################################################################################################################
    @IBAction func signIn(_ sender: UIButton) {
        self.view.endEditing(true)
        
        
            
        var username = ""
        var password = ""
        
        
        for conView in (self.loginVIew?.subviews)!
        {
            if let txtfield = conView as? UITextField
            {
                if txtfield.placeholder == "Password" && txtfield.text != ""
                {
                    password = txtfield.text!
                }
                else if txtfield.placeholder == "Email address" && txtfield.text != ""
                {
                    username = txtfield.text!
                }
            }
        }
        
        if username != "" && password != ""
        {
            
            if !(CustView.validateEmail(enteredEmail: username))
            {
                Constants.MyNavi.Alertshow(title: "Notice", themessage: "Invalid email.", with: [])
                return
            }
            //
            let contentsubmit = Constants.Test_Mode ?
                ["email": "who1.delacruz@yahoo.com", "password": "123456"] :
                ["email": username, "password": password]

            print(contentsubmit)
           
            let request = CustView.RegisterCheck(tokenRequired: false, dataTransfered: contentsubmit as [NSObject : AnyObject], theService: "login/", Method: "POST")
            Constants.MyNavi.webRequest(hasLoading: true, theRequest: request) { (respo, hasVal, errC) in
                print(respo)
                if errC == 200
                {
                    let userDef = UserDefaults.standard
                    if let contentDict = respo as? NSDictionary
                    {
                        if let strData = contentDict["data"] as? NSDictionary
                        {
                            if let accstoken = strData["access_token"] as? String
                            {
                                
                                Constants.MyNavi.AccessToken = accstoken
                                userDef.setValue(accstoken, forKey: Constants.SaveKey.token)
                                
                            }
                            
                            if let userDict = strData["user"] as? NSDictionary
                            {
                                if let profilesArr = userDict["profiles"] as? NSArray
                                {
                                    if let profilesDict = profilesArr.firstObject as? NSDictionary,  (profilesArr.count > 0)
                                    {
                                   
                                        let toStore = CustView.UDArchiver(AnyInput: profilesDict)
                                        userDef.set(toStore, forKey: Constants.SaveKey.profile)
                                    }
                                    
                                }
                            }
                        
                            
                            DispatchQueue.main.async { userDef.synchronize()  }
                            
                       
                            
                        }
                    }
                    

                    
                    Constants.MyNavi.GoToMain(completion: nil)
                    for naviSel in Constants.MyNavi.viewControllers  {  if let homeRef = naviSel as? Tutorial_Screen {  homeRef.refreshDisplay()  }  }
                    self.hideLogin()
                }
                
                else
                {
                    var errormsg = "Login Error"
                    if let contentDict = respo as? NSDictionary
                    {
                        if let strError = contentDict["error"] as? String
                        { errormsg = strError }
                    }
                    Constants.MyNavi.Alertshow(title: "Error \(errC)", themessage: errormsg, with: [])
                }
               
            }
        }
        else
        {
            Constants.MyNavi.Alertshow(title: "Notice", themessage: "All fields are required.", with: [])
        }
        
    }
    
    @IBAction func forgotPass(_ sender: UIButton) {
        self.view.endEditing(true)
        
        
        var username = ""
        
        
        for conView in (self.loginVIew?.subviews)!
        {
            if let txtfield = conView as? UITextField
            {
              if txtfield.placeholder == "Email address" && txtfield.text != ""
                {
                    username = txtfield.text!
                }
            }
        }
        
        if username != ""
        {
            if !(CustView.validateEmail(enteredEmail: username))
            {
                Constants.MyNavi.Alertshow(title: "Notice", themessage: "Invalid email.", with: [])
                return
            }
            
            let nextAct : ActionButton = CustView.OAbuttoncreate(txtlbl: "Yes", completion: {() in
                
                
                let request = CustView.RegisterCheck(tokenRequired: false, dataTransfered:nil, theService: "forgot-password/?email=\(username)", Method: "POST")
                Constants.MyNavi.webRequest(hasLoading: true, theRequest: request) { (respo, hasVal, errC) in
                    print(respo)
                    if errC == 200
                    {
                        let cancelAct : ActionButton = CustView.OAbuttoncreate(txtlbl: "Okay", completion: {() in
                             self.hideLogin()
                        })
                        
                        Constants.MyNavi.Alertshow(title: "Password has been reset", themessage: "", with: [cancelAct])
                       
                        
                    }
                    else
                    {
                        var errormsg = "Error"
                        if let contentDict = respo as? NSDictionary
                        {
                            if let strError = contentDict["error"] as? String
                            { errormsg = strError }
                        }
                        Constants.MyNavi.Alertshow(title: "Error \(errC)", themessage: errormsg, with: [])
                    }
                }
                
            })
            
            let cancelAct : ActionButton = CustView.OAbuttoncreate(txtlbl: "No", completion: {() in
                
            })
            
            Constants.MyNavi.Alertshow(title: "Your new password will be sent to your email address", themessage: "Continue?", with: [cancelAct, nextAct])
        }
        else
        {
            Constants.MyNavi.Alertshow(title: "Notice", themessage: "Email address is required.", with: [])
        }
 
    }
    
    func showLogin()
    {
        self.scrollLogin?.contentSize = self.view.frame.size
        
        let xLog = (self.view.frame.size.width - 300)*0.5
        let yLog = (self.view.frame.size.height - 230)*0.5
        self.loginVIew?.frame = CGRect(x: xLog, y: yLog, width: 300, height: 230)
        self.DisablerView.frame = self.view.frame
        self.loginVIew?.setNeedsDisplay()
        self.scrollLogin?.setNeedsDisplay()
        self.view.endEditing(true)
        self.view.isUserInteractionEnabled = false
        self.scrollLogin?.isHidden = false
        
        
        for pView in (self.loginVIew?.subviews)!
        {
            if let textField = pView as? UITextField
            {
                textField.text = ""
            }
        }
        
        UIView.animate(withDuration: 0.2, delay: 0.0, options: .curveEaseInOut, animations: {() -> Void in
            
             self.scrollLogin?.alpha = 1.0
        }, completion: {(finished: Bool) -> Void in
            
           self.view.isUserInteractionEnabled = true
            
        })
    }
    
    func hideLogin()
    {
        self.view.endEditing(true)
        self.view.isUserInteractionEnabled = false
        UIView.animate(withDuration: 0.2, delay: 0.0, options: .curveEaseInOut, animations: {() -> Void in
            
            self.scrollLogin?.alpha = 0.0
        }, completion: {(finished: Bool) -> Void in
            self.scrollLogin?.isHidden = true

            self.view.isUserInteractionEnabled = true
            
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
        
    
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        
        textField.text = CustView.hasWhitespace(string: textField.text)
        
        
    }
    
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.text = CustView.hasWhitespace(string: textField.text)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
//
//    func preferredInterfaceOrientationForPresentation() -> UIInterfaceOrientation {
//        return (self.viewControllers.last?.preferredInterfaceOrientationForPresentation)!
//    }

    //#####################################################################################################################
    //Alert
    //#####################################################################################################################
    func Alertshow(title:String, themessage:String, with buttons:NSArray)
    {
        self.DisablerView.frame = self.view.frame
         self.DisablerView.OAshow(title: title, themessage: themessage, with: buttons)
    }
 
    
    func AlertCover(title:String, withColor titC:UIColor, themessage:String, withColor messC:UIColor, with buttons:NSArray)
    {
        self.DisablerView.frame = self.view.frame
        self.DisablerView.CustomOAshow(title: title, withColor: titC, themessage: themessage, withColor: messC, with: buttons)
    }
    
    
    func  Pickercreate(ArrayContents:NSArray, completion:@escaping (String, Int)->Void)
    {
        self.DisablerView.frame = self.view.frame
        self.DisablerView.OApickercreate(ArrayContents: ArrayContents, completion: completion)
    }
    
    func  DatePickercreate(minD:Date?, maxD:Date?, completion:@escaping (String, Int)->Void)
    {
        self.DisablerView.frame = self.view.frame
        self.DisablerView.OADatePCreate(minDate: minD, maxDate: maxD, completion: completion)
    }

    
    
    
    func loadingStatus() -> Bool {
        return isLoading
    }
    
    
    func  setloadingStatus(stat:Bool) {
        self.isLoading = stat
    }
    //#######################################################################################################################
    //Loading
    //#####################################################################################################################
    
    func showloading(completion:@escaping ()->Void) {
        self.DisablerView.showloading(completion: completion)
    }
    
    func hideLoading(completion:@escaping ()->Void) {
        self.DisablerView.fadeloading(completion: completion)
    }
    
    func startLoading() { self.DisablerView.showLoading() }
    func stopLoading() { self.DisablerView.hideLoading() }
    
    func LoadingProgress(percent:CGFloat) { self.DisablerView.LoadingProgressNavi(percent:percent) }
    func showStatus(string:String) { self.DisablerView.showStatusLabel(string: string) }
    //#####################################################################################################################
    //Transtion
    //#####################################################################################################################
    func pushFromRoot (viewcontroller:UIViewController) {
        self.view!.isUserInteractionEnabled = false
        self.popToRootViewController(animated: false)
        UIView.transition(with: self.view!, duration: 0.25, options: .transitionCrossDissolve, animations: {() -> Void in
            self.pushViewController(viewcontroller, animated: false)
            }, completion: {(finished: Bool) -> Void in
                self.view!.isUserInteractionEnabled = true
                
        })
    }
    
    func  popBack() {
        if (self.viewControllers.count > 1) {
            self.view!.isUserInteractionEnabled = false
            UIView.transition(with: self.view!, duration: 0.25, options: .transitionCrossDissolve, animations: {() -> Void in
                
                }, completion: {(finished: Bool) -> Void in
                    self.view!.isUserInteractionEnabled = true
                    
            })
            
            self.popToViewController(self.viewControllers[self.viewControllers.count - 2], animated: false)
        }
    }
    
    func  QuickPopBack(completion:((Bool) -> Void)?) {
        if (self.viewControllers.count > 1) {
            UIView.transition(with: self.view!, duration: 0.0, options: .transitionCrossDissolve, animations: {() -> Void in }, completion: completion)
            self.popToViewController(self.viewControllers[self.viewControllers.count - 2], animated: false)
        }
    }
    
    func goNextCrossFade(viewcontroller:UIViewController) {
        self.view!.isUserInteractionEnabled = false
        UIView.transition(with: self.view!, duration: 0.25, options: .transitionCrossDissolve, animations: {() -> Void in
            self.pushViewController(viewcontroller, animated: false)
            }, completion: {(finished: Bool) -> Void in
                self.view!.isUserInteractionEnabled = true
                
        })
    }
    
    
    func goOverCrossFade(viewcontroller:UIViewController) {
        self.view!.isUserInteractionEnabled = false
        self.popViewController(animated: false)
        UIView.transition(with: self.view!, duration: 0.25, options: .transitionCrossDissolve, animations: {() -> Void in
            self.pushViewController(viewcontroller, animated: false)
        }, completion: {(finished: Bool) -> Void in
            self.view!.isUserInteractionEnabled = true
            
        })
    }
    
    
    //#####################################################################################################################
    //Transtion with completion
    //#####################################################################################################################
    
    func pushFromRoot (viewcontroller:UIViewController, withCompletion completion:((Bool) -> Void)?) {
        self.popToRootViewController(animated: false)
        UIView.transition(with: self.view!, duration: 0.25, options: .transitionCrossDissolve, animations: {() -> Void in
            self.pushViewController(viewcontroller, animated: false)
            }, completion: completion)
    }
    
    func goNextCrossFade(viewcontroller:UIViewController, withCompletion completion:((Bool) -> Void)?) {
        UIView.transition(with: self.view!, duration: 0.25, options: .transitionCrossDissolve, animations: {() -> Void in
            self.pushViewController(viewcontroller, animated: false)
            }, completion:completion)
    }
    
    
    func goOverCrossFade(viewcontroller:UIViewController, withCompletion completion:((Bool) -> Void)?) {
       // self.view!.isUserInteractionEnabled = false
        self.popViewController(animated: false)
        UIView.transition(with: self.view!, duration: 0.25, options: .transitionCrossDissolve, animations: {() -> Void in
            self.pushViewController(viewcontroller, animated: false)
        }, completion: completion)
    }
    
    func  popBack(completion:((Bool) -> Void)?) {
        if (self.viewControllers.count > 1) {
            UIView.transition(with: self.view!, duration: 0.25, options: .transitionCrossDissolve, animations: {() -> Void in }, completion: completion)
            self.popToViewController(self.viewControllers[self.viewControllers.count - 2], animated: false)
        }
    }
    
    func  GoToMain(completion:((Bool) -> Void)?) {
       if (self.viewControllers.count > 1) {
            UIView.transition(with: self.view!, duration: 0.25, options: .transitionCrossDissolve, animations: {() -> Void in }, completion: completion)
        self.popToViewController(self.viewControllers[1], animated: false)
       }
    }
    
    func  RestartSubmission(completion:((Bool) -> Void)?) {
        UIView.transition(with: self.view!, duration: 0.25, options: .transitionCrossDissolve, animations: {() -> Void in }, completion: completion)

        if (self.viewControllers.count > 2) {
            self.popToViewController(self.viewControllers[2], animated: false)
        }
        else
        {
            self.popViewController(animated: false)

        }
    }

    //#####################################################################################################################
    //#####################################################################################################################
    
    func LoadJSONRequest(theRequest:NSMutableURLRequest, with returnCompletion:@escaping (Any, Bool, Int)->Void)
    {
        self.DisablerView.LoadJSONRequest(theRequest: theRequest, with: returnCompletion)
    }
    

    func webRequest(hasLoading:Bool, theRequest:NSMutableURLRequest, with returnCompletion:@escaping (Any, Bool, Int)->Void )
    {
        if hasLoading
        {
            self.showloading { self.DisablerView.LoadJSONRequest(theRequest: theRequest) { (Content, hasResponse, StatusCode) in self.hideLoading {  returnCompletion(Content, hasResponse, StatusCode) } }  }
            
        }
        else
        { self.DisablerView.LoadJSONRequest(theRequest: theRequest, with: returnCompletion) }
    }
    
    
    func CleanBufferRequest(returnCompletion:@escaping (Bool)->Void )
    {
        let userdef = UserDefaults.standard
        if let currentArray = userdef.value(forKey: Constants.SaveKey.errorIDs) as? NSArray, currentArray.count > 0
        {
            
            Constants.MyNavi.showStatus(string: "Clearing buffer...")
            let request = CustView.RegisterCheck(tokenRequired: CustView.isSignIn() , dataTransfered: currentArray, theService:"user/", Method: "DELETE")
            Constants.MyNavi.webRequest(hasLoading: true, theRequest: request) { (respo, hasVal, errC) in
                print("---- Clear buffer \(respo)")
                if errC >= 200 && errC < 300
                {
                    userdef.removeObject(forKey:  Constants.SaveKey.errorIDs)
                    userdef.synchronize()
                    returnCompletion(true)
                    
                    
                }
                else  {   returnCompletion(false)  }
                
            }
        }
        else
        { returnCompletion(true) }
        
    }
    
    
}

