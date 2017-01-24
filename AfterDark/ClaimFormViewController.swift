//
//  ClaimFormViewController.swift
//  AfterDark
//
//  Created by Koh Yi Zhi Elliot - Ezekiel on 3/11/16.
//  Copyright © 2016 kohbroco. All rights reserved.
//

import UIKit

class ClaimFormViewController: UIViewController,UITextFieldDelegate {

    static let singleton = ClaimFormViewController()
    @IBOutlet weak var spentAmountTextField: UITextField!
    
    @IBOutlet weak var claimButton: UIButton!
    @IBOutlet weak var qrImageView: UIImageView!
    
    var currentDiscount : Discount?
    
    @IBAction func claimOnClick(_ sender: Any) {
        submitClaimRequest()
        spentAmountTextField.resignFirstResponder()
    }
    
    var currentString = ""
    override func viewDidLoad() {
        super.viewDidLoad()

        Initialize()
        
    }

    override func viewWillDisappear(_ animated: Bool) {

    }
    
    func Initialize()
    {
        spentAmountTextField.text = "$0.00"
        addKeyboardToolBar()
        self.modalPresentationStyle = .currentContext
        self.modalTransitionStyle = .crossDissolve
        spentAmountTextField.delegate = self
        
        
        //shadows
        spentAmountTextField.layer.shadowOpacity = 0.4
        spentAmountTextField.layer.shadowOffset = CGSize(width: 2, height: 2)
        spentAmountTextField.clipsToBounds = false
        
        claimButton.layer.shadowOpacity = 0.4
        claimButton.layer.shadowOffset = CGSize(width: 2, height: 2)
        claimButton.clipsToBounds = false
    }

    override func viewDidAppear(_ animated: Bool) {
        spentAmountTextField.becomeFirstResponder()
    }
    
    //Textfield delegates
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool { // return NO to not change text
        
        switch string {
        case "0","1","2","3","4","5","6","7","8","9":
            currentString += string
            formatCurrency(string: currentString)
        default:
            let array = Array(string.characters)
            var currentStringArray = Array(currentString.characters)
            if array.count == 0 && currentStringArray.count != 0 {
                currentStringArray.removeLast()
                currentString = ""
                for character in currentStringArray {
                    currentString += String(character)
                }
                formatCurrency(string: currentString)
            }
        }
        return false
    }
    
    func formatCurrency(string: String) {
        let formatter = NumberFormatter()
        formatter.numberStyle = NumberFormatter.Style.currency
        formatter.locale = NSLocale(localeIdentifier: "en_US") as Locale!
        let numberFromField = (NSString(string: currentString).doubleValue)/100
        spentAmountTextField.text = formatter.string(from: NSNumber(value: numberFromField))
    }
    
    func addKeyboardToolBar()
    {
        let numberToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: Sizing.ScreenWidth(), height: 30))
        numberToolbar.barStyle = UIBarStyle.default
        numberToolbar.items = [
            UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.plain, target: self, action: #selector(cancelNumberPad)),
            UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil),
            UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.plain, target: self, action: #selector(doneWithNumberPad))]
        numberToolbar.sizeToFit()
        spentAmountTextField.inputAccessoryView = numberToolbar
    }
    
    func cancelNumberPad()
    {
        spentAmountTextField.endEditing(true)
        spentAmountTextField.text = "$0.00"
        
        //dismiss form layer
        self.dismiss(animated: true, completion: nil)
    }
    
    func doneWithNumberPad()
    {
        spentAmountTextField.endEditing(true)
        

        
        
    }
    
    func submitClaimRequest()
    {
        if spentAmountTextField.text == "$0.00"
        {
            PopupManager.singleton.Popup(title: "Invalid Value", body: "Please type in the amount spent",presentationViewCont: self)
        }
        else
        {
            //make qr code : format: userID,username,barID,discountID,amount,date
            guard let userID = Account.singleton.user_ID else {
                NSLog("error: userID doesnt exist")
                return
            }
            guard let username = Account.singleton.user_name else {
                NSLog("error: username doesnt exist")
                return
            }
            guard let index = spentAmountTextField.text?.index(after: (spentAmountTextField.text?.startIndex)!) else {                NSLog("error: index doesnt exist")
                return
            }
            guard let amount = spentAmountTextField.text?.substring(from: index) else {
                NSLog("error: amount doesnt exist")
                return
            }
            
            guard let currentDiscount = currentDiscount else
            {
                NSLog("error: discount doesnt exist")
                return
            }
            
            guard let discountID = currentDiscount.discount_ID else {
                NSLog("error: discountID doesnt exist")
                return
            }
            guard let bar_ID = currentDiscount.bar_ID else {
                NSLog("error: discount bar ID doesnt exist")
                return
            }
            
            let time = Date().timeIntervalSince1970

            //things to include in QR CODE:
            //NSDictionary -> json encode into string -> input string
            // user ID
            // user name
            // bar id
            // discount id
            // amount spent 
            // date and time in seconds from 1970
            let qrDict = NSMutableDictionary(dictionary: ["uID":userID,
                                                          "uName":username,"bID":bar_ID,"dID":discountID,"amt":amount,"t":time])
            
            //let inputString = "\(userID!),\(username!),\(barID!),\(discountID!),\(amount)"
            
            do
            {
                let inputData = try JSONSerialization.data(withJSONObject: qrDict, options: JSONSerialization.WritingOptions.init(rawValue: 0))
                
                let inputString = String(data: inputData, encoding: .utf8)!
                
                
                //set ui image
                GenerateQRCode(input: inputString)
                
                print(inputString)
            }
            catch
            {
                
            }
            
            

            
        }
        //activity indicator
    }
    
    func GenerateQRCode(input : String)
    {
        let stringData = input.data(using: .utf8)
        
        let qrFilter = CIFilter(name: "CIQRCodeGenerator")
        
        qrFilter?.setValue(stringData, forKey: "inputMessage")
        
        let image = qrFilter?.outputImage
        
        if let image = image
        {
            let transform = CGAffineTransform.init(scaleX: 5, y: 5); // Scale by 5 times along both dimensions
            let out = image.applying(transform)
            qrImageView.image = UIImage(ciImage: out)
            
            
        }
    }
    

    
}
