//
//  PopUps.swift
//  DocSolsM
//
//  Created by Jene Kirishima on 05/07/2018.
//  Copyright © 2018 Jene Kirishima. All rights reserved.
//

import Foundation
import UIKit

//#########################################################################################################################################################
//#########################################################################################################################################################


class CheckoutSuccess: CustView, UIWebViewDelegate, UIScrollViewDelegate
{
    @IBOutlet var successText : UITextView?
    @IBOutlet var successsWeb : UIWebView?
    var successString : String = "Unknown response."
    override func viewDidLoad() {
        
        super.viewDidLoad()
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        
        Constants.MyNavi.updateInfo = false
        super.viewDidAppear(animated)
        self.successText?.text = successString
        
        if #available(iOS 11.0, *) {
            self.successsWeb?.scrollView.contentInsetAdjustmentBehavior = .never
        } else { self.automaticallyAdjustsScrollViewInsets = false  }
    }
    
    @IBAction func NextScreen(_ sender: UIButton) {
        
        if sender.tag == 0
        { Constants.MyNavi.GoToMain(completion: nil) }
        else
        {
            Constants.MyNavi.TempoScans = NSArray.init()
            let theNext : Profile_Screen = self.navigationController?.storyboard!.instantiateViewController(withIdentifier: "Profile_Screen") as! Profile_Screen
            Constants.MyNavi.goNextCrossFade(viewcontroller: theNext) { (_) in
                  theNext.fetchHistory()
            }
 
        }
        
    }
    
    
    func loadWeb()
    {
        self.successsWeb?.scrollView.delegate = self
        self.successsWeb?.scrollView.showsHorizontalScrollIndicator = false
//        self.successsWeb?.isHidden = true
//        let url = Bundle.main.url(forResource: "terms", withExtension: "html")
//        let request = URLRequest(url: url!)
        print("----\n \(successString)")
        Constants.MyNavi.showloading {
            self.successsWeb?.loadHTMLString(self.successString, baseURL: nil)

        }

     
    }
    
    public func webViewDidStartLoad(_ webView: UIWebView) {
      
    }
    
    public func webViewDidFinishLoad(_ webView: UIWebView)
    {
        
       //

        if webView.tag != 2
        {
            let cssString = "#email-template {  width: \(Constants.DeviceProperty.devWidth - 40)px !important; }"
            let jsString = "var style = document.createElement('style'); style.innerHTML = '\(cssString)'; document.head.appendChild(style);"
            self.successsWeb?.tag = 2
            self.successsWeb?.stringByEvaluatingJavaScript(from: jsString)
        }
     
        
        
         Constants.MyNavi.stopLoading()
    }
    
    public func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        Constants.MyNavi.stopLoading()

    }
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView)
    {
        if scrollView.contentOffset.x > 0 { scrollView.contentOffset.x = 0 }
    }
}


//#########################################################################################################################################################
//#########################################################################################################################################################


class SubmitSuccess: CustView
{
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        
        Constants.MyNavi.updateInfo = false
        super.viewDidAppear(animated)
        
    }
    
    @IBAction func NextScreen(_ sender: UIButton) {
        
        if sender.tag == 0
        { Constants.MyNavi.GoToMain(completion: nil) }
        else
        {
            Constants.MyNavi.TempoScans = NSArray.init()
            let theNext : Profile_Screen = self.navigationController?.storyboard!.instantiateViewController(withIdentifier: "Profile_Screen") as! Profile_Screen
            Constants.MyNavi.goNextCrossFade(viewcontroller: theNext) { (_) in
                  theNext.fetchHistory()
            }
            
        }
        
    }
    
    
}


//#########################################################################################################################################################
//#########################################################################################################################################################


class SubmitSuccessV2: CustView
{
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        
        Constants.MyNavi.updateInfo = false
        super.viewDidAppear(animated)
        
    }
    
    @IBAction func NextScreen(_ sender: UIButton) {
        
        if sender.tag == 0
        { Constants.MyNavi.GoToMain(completion: nil) }
        else
        {
            Constants.MyNavi.TempoScans = NSArray.init()
            let theNext : Profile_Screen = self.navigationController?.storyboard!.instantiateViewController(withIdentifier: "Profile_Screen") as! Profile_Screen
            Constants.MyNavi.goNextCrossFade(viewcontroller: theNext) { (_) in
                theNext.fetchHistory()
            }
            
        }
        
    }
    
    
}
