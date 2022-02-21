//
//  Terms.swift
//  DocSolsM
//
//  Created by Jene Kirishima on 18/12/2018.
//  Copyright © 2018 Jene Kirishima. All rights reserved.
//

import Foundation
import UIKit

class TermsScreen: CustView, UIWebViewDelegate
{
    @IBOutlet var htmlView : UIWebView?
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        super.viewDidAppear(animated)
        
    }
    
    @IBAction func ButtonPushed(_ sender: UIButton) {
        
        let defaults = UserDefaults.standard
        if (sender.tag == 1)
        {  defaults.set(true, forKey: Constants.SaveKey.termsKey) }
        else { defaults.set(false, forKey: Constants.SaveKey.termsKey) }
        defaults.synchronize()
        
        self.dismiss(animated: true, completion: {
            if sender.tag != 1
            {
                Constants.MyNavi.GoToMain(completion: { (_) in
                    
                })
            }
        })
        
    }
        
    
    func loadWeb()
    {
         self.htmlView?.isHidden = true
        let url = Bundle.main.url(forResource: "terms", withExtension: "html")
        let request = URLRequest(url: url!)
        htmlView?.loadRequest(request)
        
    }
    
    public func webViewDidFinishLoad(_ webView: UIWebView)
    {
        self.htmlView?.isHidden = false
    }
}
