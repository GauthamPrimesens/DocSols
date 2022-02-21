//
//  CustomInfo.swift
//  DocSolsM
//
//  Created by Jene Kirishima on 08/06/2018.
//  Copyright © 2018 Jene Kirishima. All rights reserved.
//

import Foundation
import UIKit


class Type_Screen: CustView
{
    
    @IBOutlet var sportsV : UIView?
    @IBOutlet var dressV : UIView?
    var ContentSubmit : NSDictionary = NSDictionary.init()
    
    @IBOutlet var contentV : UIView?
    @IBOutlet var theScroll : UIScrollView?
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
//        self.sportsV?.backgroundColor = .white
//        self.sportsV?.dropShadow(color: .lightGray, opacity: 0.75, offSet: CGSize(width: -1, height: 1), radius: 3.0, scale: false)
//
//        self.dressV?.backgroundColor = .white
//        self.dressV?.dropShadow(color: .lightGray, opacity: 0.75, offSet: CGSize(width: -1, height: 1), radius: 3.0, scale: false)


        self.contentV?.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 700)
        self.theScroll?.addSubview(self.contentV!)
        self.theScroll?.contentSize = (self.contentV?.frame.size)!
        self.theScroll?.contentOffset = CGPoint.zero
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        
        
        super.viewDidAppear(animated)
        if #available(iOS 11.0, *) {
            self.theScroll?.contentInsetAdjustmentBehavior = .never
        } else { self.automaticallyAdjustsScrollViewInsets = false  }
        
        let viewstoTap = [self.dressV!, self.sportsV!]
        for views in viewstoTap {
            let tapG = UITapGestureRecognizer.init(target: self, action: #selector(tapAction(_:)))
            views.dropShadow(color: .lightGray, opacity: 0.75, offSet: CGSize(width: -1, height: 1), radius: 3.0, scale: false)
            views.backgroundColor = .white
            
            views.isUserInteractionEnabled = true
            tapG.numberOfTapsRequired = 1
            views.addGestureRecognizer(tapG)
        }
        
        
    }
    
    @objc func tapAction(_ sender: UITapGestureRecognizer) {
        //sports = 0
        //dress = 1
       // print("\(String(describing: sender.view?.tag))")
        let modContent = NSMutableDictionary.init(dictionary: self.ContentSubmit)
        //let modContent = NSMutableDictionary.init(dictionary:["medias" : [UIImage.init(named: "testup1.jpg"), UIImage.init(named: "testup2.jpg"), UIImage.init(named: "testup3.jpg")]] )
        
        if let currenttag = sender.view?.tag
        {  modContent["shoe_type"] = NSNumber.init(value: currenttag - 1) }
        
        
        
        let theNext : Color_Screen = self.navigationController?.storyboard!.instantiateViewController(withIdentifier: "Color_Screen") as! Color_Screen
        theNext.isDress = sender.view?.tag == 1 ? false : true
        theNext.ContentSubmit = modContent
        Constants.MyNavi.goNextCrossFade(viewcontroller: theNext) { (_) in
        }
    }
    
    
}


class Color_Screen: CustView
{
    
    var ContentSubmit : NSDictionary = NSDictionary.init()
    var isDress : Bool = false
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
     
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        
        
        super.viewDidAppear(animated)
        
        for views in self.view.subviews
        {
            if views.tag == 300 || views.tag == 301
            {
                if isDress
                {
                    if views.tag == 300 { views.isHidden = true }
                    else { views.isHidden =  false }
                }
                else
                {
                    if views.tag == 301 { views.isHidden = true }
                    else { views.isHidden =  false }
                }
                
                views.dropShadow(color: .lightGray, opacity: 0.75, offSet: CGSize(width: -1, height: 1), radius: 3.0, scale: false)
                
                
                let tapG = UITapGestureRecognizer.init(target: self, action: #selector(tapAction(_:)))
                views.isUserInteractionEnabled = true
                tapG.numberOfTapsRequired = 1
                views.addGestureRecognizer(tapG)
                
            }
            else if views.tag == 302
            {
                if isDress
                {  views.isHidden = true }
                else {  views.isHidden = false }
            }
        }
        
    }
    
    @objc func tapAction(_ sender: UITapGestureRecognizer) {
        
        print("tapped \(String(describing: sender.view?.layer.name))")
        let modContent = NSMutableDictionary.init(dictionary: self.ContentSubmit)
        
        
        if let stringName =  sender.view?.layer.name
        {  modContent["shoe_colour"] = stringName }
        
        
        
        
        if Constants.Test_Mode
        {
            let theNext : Checkout_Screen = self.navigationController?.storyboard!.instantiateViewController(withIdentifier: "Checkout_Screen") as! Checkout_Screen
            theNext.ContentSubmit = modContent
            Constants.MyNavi.goNextCrossFade(viewcontroller: theNext) { (_) in
            }
        }
        else
        {
            
            let request = CustView.RegisterCheck(tokenRequired: false, dataTransfered: nil, theService:"settings/", Method: "GET")
            Constants.MyNavi.webRequest(hasLoading: true, theRequest: request) { (respo, hasVal, errC) in
                print("---- profiles info \(respo)")
                if errC == 200
                {
                    var eOstat = "no"
                    var pricetag = "129.99"
                    if let contentDict = respo as? NSDictionary
                    {
                        if let dataDict = contentDict["data"] as? NSDictionary
                        {
                            if let eOstatP = dataDict["Enable Orders"] as? String, let pricetagP = dataDict["Insole Price"] as? String {
                                eOstat = eOstatP
                                pricetag = pricetagP
                            }
                        }
                    }
                    
                    if eOstat == "no"
                    {
                        let theNext : Unpayed_Screen = self.navigationController?.storyboard!.instantiateViewController(withIdentifier: "Unpayed_Screen") as! Unpayed_Screen
                        theNext.ContentSubmit = modContent
                        Constants.MyNavi.goNextCrossFade(viewcontroller: theNext) { (_) in
                        }
                    }
                    else
                    {
                        let theNext : Checkout_Screen = self.navigationController?.storyboard!.instantiateViewController(withIdentifier: "Checkout_Screen") as! Checkout_Screen
                        theNext.priceTagString = pricetag
                        theNext.ContentSubmit = modContent
                        Constants.MyNavi.goNextCrossFade(viewcontroller: theNext) { (_) in
                        }
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
                    Constants.MyNavi.Alertshow(title: "Status Check Error", themessage: errormsg, with: [])
                }
                
                
                
                
            }
            
        }
    }
     


    
    
}
