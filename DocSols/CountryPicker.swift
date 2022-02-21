//
//  CountryPicker.swift
//  DocSolsM
//
//  Created by Jene Kirishima on 10/01/2019.
//  Copyright © 2019 Jene Kirishima. All rights reserved.
//

import Foundation
import UIKit

protocol CountryPickerScreenDelegate: class {
    func updateTextfield(_ string: String?)
}

class CountryPickerScreen: CustView, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate
{
    
    let cellsize : CGFloat = 50.0
    @IBOutlet var cList : UITableView?
    var countryList : NSArray = NSArray.init()
    var cellList : NSMutableArray = NSMutableArray.init()
    
    @IBOutlet var textfieldCt : UITextField?
    
    weak var delegate: CountryPickerScreenDelegate?
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.cList!.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        if let listStored = UserDefaults.standard.value(forKey: Constants.SaveKey.countryKey) as? NSArray, (listStored.count > 0) { self.countryList = listStored }
        
        
        let paddingView: UIView = UIView.init(frame: CGRect(x: 0, y: 0, width: 10, height: self.textfieldCt!.frame.size.height))
        self.textfieldCt?.leftView = paddingView
        self.textfieldCt?.leftViewMode = .always
        self.textfieldCt?.delegate = self
        self.textfieldCt?.addTarget(self, action: #selector(TFChange(_:)), for: .editingChanged   )
        
        self.textfieldCt?.layer.borderColor =  UIColor.init(netHex: 0xd1d1d1).cgColor
        self.textfieldCt?.layer.borderWidth = 1.0
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        super.viewDidAppear(animated)
        
    }
    
    
    @IBAction func ButtonPushed(_ sender: UIButton) {
        
        self.dismissScreen()
        
    }
    
    func dismissScreen()
    {
        self.view.endEditing(true)
        
        self.dismiss(animated: true, completion: {
            //            if sender.tag != 1
            //            {
            //                Constants.MyNavi.GoToMain(completion: { (_) in
            //
            //                })
            //            }
        })
    }
    
    //#################################################################################################################################################################
    //################################################################################################################################################################
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        
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
        if let pView = self.cellList[indexPath.row] as? UIView  {
            if let contentData = pView.layer.value(forKey: "Data") as? NSDictionary
            {
                print("content \(contentData)")
                
                if let stringCode = contentData["code"] as? String { delegate?.updateTextfield(stringCode) }
            
                self.dismissScreen()
            }
        }
    }
    
    //#############################################################################################################################################################
    //#############################################################################################################################################################
    
    func createcellTable(string:String) -> UIView
    {
        let padding:CGFloat = 15.0
        let contentWidth : CGFloat = Constants.DeviceProperty.devWidth - ((padding*1.5)*2.0)
        let theAttN = CustView.getAttributeDict(fontName: "HelveticaNeue-Medium", alignment:.left, size: 16, color:.init(netHex: 0x22385B))
        let attStr = NSAttributedString.init(string: string, attributes: theAttN)
        
        let descLbl = CustView.statLabel(rect: CGRect(x: padding, y: 0, width:contentWidth, height: cellsize), attStr: attStr)

        let thereturnView = UIView.init(frame: CGRect(x: 0, y: 0, width: Constants.DeviceProperty.devWidth, height: cellsize))
        
        let theLine = self.createLine(fromPoint: CGPoint(x:0, y: cellsize - 1.0 ), toPoint: CGPoint(x:Constants.DeviceProperty.devWidth , y: cellsize - 1.0 ), color: UIColor.init(netHex: 0xd1d1d1), lineWidth: 0.5)
        
        thereturnView.addSubview(descLbl)
        thereturnView.layer.addSublayer(theLine)
        
        return thereturnView
        
    }
    
    //#############################################################################################################################################################
    //#############################################################################################################################################################
    
    @objc func keyboardWillHide(_ notification:NSNotification) {

        
    }
    
    
    @objc func TFChange(_ textField: UITextField)
    {
        var exSt = textField.text!
        if (exSt.hasPrefix(" ")) {
            let curInd = exSt.startIndex
            exSt = String(exSt[exSt.index(after: curInd)...])
            
            
        }
        
        textField.text = exSt
        self.filterContent(text: textField.text!)

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
    
    //#############################################################################################################################################################
    //#############################################################################################################################################################
    
    
    func filterContent(text:String)
    {
     
        
        let searchPredicate = NSPredicate(format: "name CONTAINS[C] %@", text)
        let FilteredArray = countryList.filtered(using: searchPredicate)
        
        self.cellList.removeAllObjects()
        for content in FilteredArray
        {
            if let titleStr = (content as! NSDictionary)["name"] as? String, let codeStr = (content as! NSDictionary)["code"] as? String
            {
                let cellV = self.createcellTable(string: "\(titleStr) [\(codeStr)]")
                cellV.layer.setValue(content, forKey:"Data")
                self.cellList.add(cellV)
            }
        }
        
        self.cList?.reloadData()
    }
}
