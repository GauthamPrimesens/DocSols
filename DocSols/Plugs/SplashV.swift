//
//  SplashV.swift
//  Custom Zero Plug-in
//
//  Created by Jene Kirishima on 19/07/2016.
//  Copyright © 2016 Fresh Mktg. All rights reserved.


import Foundation
import UIKit

//#######################################################################################################################
//#######################################################################################################################
// PARENT VIEWCONTROLLER
//#######################################################################################################################
//#######################################################################################################################

class CustView: UIViewController, UINavigationControllerDelegate
{
    @IBOutlet var exBaseView : UIView?
    var _BaseColor : NSArray = [UIColor.init(netHex: 0x25252d), UIColor.init(netHex: 0x25252d)]
    @IBOutlet var bckBtn : UIButton?
    @IBOutlet var TitleLabel : UILabel?

    @IBOutlet var theBackground: UIImageView?
    var excluTch : Bool = false
   

    
    @IBAction func backGlobal(sender: AnyObject)
    {
        self.view!.endEditing(true)
        
        self.view!.isUserInteractionEnabled = false
        Constants.MyNavi.popBack(completion: {(finished: Bool) -> Void in
            self.view!.isUserInteractionEnabled = true
            //            let thetopview : UIViewController =  Constants.MyNavi.topViewController!
            //
            //            if (thetopview.isKindOfClass(MainScreen))
            //            {
            //                let MainByDelegate = thetopview as! MainScreen
            //                MainByDelegate.fetchLocalData()
            //            }
            
            
            
        })
        
        
    }
    
    //For Swipe Back

    
//    @nonobjc func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
////        let viewlers = Constants.MyNavi.viewControllers
////        var hasEnteredHome : Bool = false
////        for items : AnyObject in viewlers { if (items is HomeScreen) { hasEnteredHome = true } }
//        if ((Constants.MyNavi.viewControllers.count > 2)  && (Constants.MyNavi.isLoading != true) ) {
//            return true
//       }
//        return false
//    }
    override func viewDidLoad() {
        super.viewDidLoad()
         Constants.MyNavi.DisablerView.frame = self.view.frame
        
        UIApplication.shared.isIdleTimerDisabled = true
        let arrowL = CustView.createArrow(rect: CGRect(x:0 ,y:7, width:8 ,height:16) , direction: .left, color: UIColor.init(netHex: 0xff6a2b) , lineWidth: 3.0)
        self.bckBtn?.layer.addSublayer(arrowL)
       
        let value = UIInterfaceOrientation.portrait.rawValue
        UIDevice.current.setValue(value, forKey: "orientation")
//        var theNameBG: String = "BaseBG4"
//        let theHeight: Int = Int(Constants.DeviceProperty.devHeight)
//        switch theHeight {
//        case Constants.DeviceProperty.iPhone5Height:
//            theNameBG = "BaseBG5S"
//            break3
//        case Constants.DeviceProperty.iPhone6Height:
//            theNameBG = "BaseBG6"
//            break
//        default:
//            break
//        }
//
//        self.theBackground!.image = UIImage(named: theNameBG)
//        self.theBackground!.setNeedsDisplay()
//
        
        
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
    override var shouldAutorotate: Bool {
        return true
    }

    @IBAction func testtest(sender: AnyObject)
    {
//        print("sample")
//        Constants.MyNavi.showloading {
//            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
//                Constants.MyNavi.hideLoading {
//                    print("done")
//                }
//            }
//        }
    //    let Reload =  CustView.OAbuttoncreate(txtlbl: "YES", completion: {() in print("YES") })
     //   let HomeSel =  CustView.OAbuttoncreate(txtlbl: "NO", completion: {() in  print("NO") })
        
//            Constants.MyNavi.CustomAlert(textArr: [["type" : "H2", "string" : "WANT ANOTHER\n"],  ["type" : "H1", "string" : "ROUND OF HEAT?"]], buttons: [Reload, HomeSel])
        
       //  Constants.MyNavi.CustomAlert(textArr: [["type" : "H3", "string" : "UP FOR ANOTHER ROUND?"]], buttons: [Reload, HomeSel])
    }

    @IBAction func TempoButtonAct(sender: AnyObject)
    {
        self.view!.endEditing(true)

        Constants.MyNavi.Alertshow(title: "Feature Unavailable", themessage: "", with: [])

    }



    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }

    
    
    func createLine(fromPoint:CGPoint, toPoint:CGPoint, color:UIColor, lineWidth:CGFloat)->CAShapeLayer
    {
        let baseArc = UIBezierPath.init()
        baseArc.move(to:fromPoint)
        baseArc.addLine(to: toPoint)
        
        let baselayer = CAShapeLayer.init()
        baselayer.path = baseArc.cgPath
        baselayer.strokeColor = color.cgColor
        baselayer.lineWidth = lineWidth
        baselayer.fillColor = UIColor.clear.cgColor
        baselayer.lineCap = kCALineCapButt
        
        return baselayer
    }
    
    

    func getDashBox(screenNo:Int, baseView:CGSize)->CGRect
    {
        var ratx : CGFloat = 27.0
        var raty : CGFloat = 15.0
//        if screenNo == 2
//        {
//            ratx  = 18.0
//            raty  = 20.0
//        }
//        else if screenNo >= 4
//        {
//            ratx  = 20.0
//            raty  = 25.0
//        }
        
        //revision 06 05 2018
        if screenNo <= 1
        {
            ratx  = 20.0
            raty  = 25.0
        }
        
        let borderdMisc : CGFloat = 30
        let shortestSide = Constants.DeviceProperty.devWidth < Constants.DeviceProperty.devHeight ? Constants.DeviceProperty.devWidth : Constants.DeviceProperty.devHeight
        let visibleLimit = shortestSide - (borderdMisc*2.0)
        
        
//        let contentDisW : CGFloat = (screenNo == 2 || screenNo >= 4) ? ((ratx*visibleLimit)/raty)  : visibleLimit
//        let contentDisH : CGFloat = (screenNo == 2 || screenNo >= 4) ? visibleLimit  : ((raty*visibleLimit)/ratx)
        
        //revision 06 05 2018
        let contentDisW : CGFloat = screenNo <= 1 ? ((ratx*visibleLimit)/raty)  : visibleLimit
        let contentDisH : CGFloat = screenNo <= 1 ? visibleLimit  : ((raty*visibleLimit)/ratx)
        let contentDisY : CGFloat = (baseView.height - contentDisH)*0.5
        let contentDisX : CGFloat = (baseView.width - contentDisW)*0.5
        
        return CGRect(x: contentDisX, y: contentDisY, width: contentDisW, height: contentDisH)
        
    }
}

//#######################################################################################################################################################
//#######################################################################################################################################################
// SPLASH SCREEN
//#######################################################################################################################################################
//#######################################################################################################################################################

class LoadingView: CustView,UIGestureRecognizerDelegate /*Parent Class*/
{
    
   // @IBOutlet var splashLIndicator : UIActivityIndicatorView?

    
    override func viewDidLoad() {

        let textview = UITextView.init(frame: CGRect.zero)
        textview.isEditable = true
        self.view.addSubview(textview)
        textview.removeFromSuperview()
     //   super.viewDidLoad()
        
       // self.navigationController!.interactivePopGestureRecognizer!.delegate = (self as UIGestureRecognizerDelegate)

    }

    
    override func viewDidAppear(_ animated: Bool) {
     //   CustView.SignOut()
        super.viewDidAppear(animated)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            DispatchQueue.main.async {
              //  self.splashLIndicator?.isHidden = true
                
                let theNext : Tutorial_Screen = self.navigationController?.storyboard!.instantiateViewController(withIdentifier: "Tutorial_Screen") as! Tutorial_Screen
                Constants.MyNavi.goNextCrossFade(viewcontroller: theNext)
             
                
            }
        }
    }
    
   

}
