//
//  Gallery.swift
//  DocSolsM
//
//  Created by Jene Kirishima on 08/06/2018.
//  Copyright © 2018 Jene Kirishima. All rights reserved.
//

import Foundation
import UIKit

class OrientationScreenPort: CustView
{
    @IBOutlet var portraitClone : UIView?
    
    var forRedo : Bool = false
    var imageArr : NSMutableArray = NSMutableArray.init(array: [UIImage(named:"testup1.jpg")!,UIImage(named:"testup2.jpg")!,UIImage(named:"testup3.jpg")!, UIImage(named:"testup1.jpg")!, UIImage(named:"testup2.jpg")!, UIImage(named:"testup3.jpg")!])
    var videoData = NSData.init()
    var currentStep : Int = 0
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        
        super.viewDidAppear(animated)
        
    }
    
    func layoutCloneView()
    {
        NotificationCenter.default.addObserver(self, selector: #selector(RotateShift), name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
        
        let currentRect = CGRect(origin: CGPoint.zero, size: self.view.frame.size)
        self.portraitClone?.frame = currentRect
        self.view.addSubview(self.portraitClone!)
    }
    
    @objc func RotateShift()
    {
        if !excluTch && UIDeviceOrientationIsLandscape(UIDevice.current.orientation)
        {
            //shift to landscape requirements
            print("landscape")
            self.excluTch = true
            NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
            
            if !forRedo
            {
                let theNext : Record_Screen = self.navigationController?.storyboard!.instantiateViewController(withIdentifier: "Record_Screen") as! Record_Screen
                Constants.MyNavi.goOverCrossFade(viewcontroller: theNext) { (_) in
                    theNext.PreLayout()
                    
                }
            }
            else
            {
                let theNext : RedoRecord_Screen = self.navigationController?.storyboard!.instantiateViewController(withIdentifier: "RedoRecord_Screen") as! RedoRecord_Screen
                theNext.imageArr = imageArr
                theNext.videoData = videoData
                
    
                
                if currentStep < 2 {  theNext.stepInt = currentStep + 1 }
                else { theNext.stepInt = currentStep + 2 }
          
                Constants.MyNavi.goOverCrossFade(viewcontroller: theNext) { (_) in
                    theNext.PreLayout()
                }
            }
           
        }
        
    }
    
}


class Gallery_Screen: CustView, UIScrollViewDelegate
{
    
    @IBOutlet var startBtn : UIButton?
    @IBOutlet var saveBtn : UIButton?
    
    @IBOutlet var imagecontainer : UIView?
    
    var imageArr : NSMutableArray = NSMutableArray.init(array: [UIImage(named:"testup1.jpg")!,UIImage(named:"testup2.jpg")!,UIImage(named:"testup3.jpg")!, UIImage(named:"testup1.jpg")!, UIImage(named:"testup2.jpg")!, UIImage(named:"testup3.jpg")!])
    
    var videoData = NSData.init()
    
    override func viewDidLoad() {

        super.viewDidLoad()
        
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        
        super.viewDidAppear(animated)
        if #available(iOS 11.0, *) {
        } else { self.automaticallyAdjustsScrollViewInsets = false  }

    }
    

    func layoutDone()
    {
        for imagv in (imagecontainer?.subviews)!
        {
            if let xxx = imagv as? UIImageView
            {
                if let imgxx = self.imageArr[xxx.tag] as? UIImage
                {  xxx.image = imgxx }

            }
        }
        
   
    }
    


    
    @IBAction func clickButton(_ sender: Any) {
    
        if (sender as AnyObject).tag != 1
        {
            Constants.MyNavi.popBack()
        }
        else
        {
          
            let theNext : ReviewSubPhoto = self.navigationController?.storyboard!.instantiateViewController(withIdentifier: "ReviewSubPhoto") as! ReviewSubPhoto
            theNext.imageArr = self.imageArr
            theNext.videoData = self.videoData
            Constants.MyNavi.goOverCrossFade(viewcontroller: theNext) { (_) in
            }
           
           
        }
    }
}
