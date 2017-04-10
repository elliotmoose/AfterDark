//
//  PasscodeViewController.swift
//  AfterDark
//
//  Created by Koh Yi Zhi Elliot - Ezekiel on 5/2/17.
//  Copyright © 2017 kohbroco. All rights reserved.
//

import UIKit

class PasscodeViewController: UIViewController,UIKeyInput{

    static let singleton = PasscodeViewController(nibName: "PasscodeViewController", bundle: Bundle.main)
    
    let numberOfDigits = 4
    var inputPass = ""
    var spentAmount = ""
    var currentDiscount : Discount?
    var date : Double = 0
    
    
    @IBOutlet weak var buttonBottomConstraint: NSLayoutConstraint!
    
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: "PasscodeViewController", bundle: Bundle.main)
        Bundle.main.loadNibNamed("PasscodeViewController", owner: self, options: nil)
        
        
        //add instruction label
        let labelFontSize : CGFloat = 40
        let padding : CGFloat = 40
        
        let instructLabel = UILabel(frame: CGRect(x: 0, y: padding, width: Sizing.ScreenWidth(), height: labelFontSize))
        instructLabel.text = "Enter \(numberOfDigits)-Digit Pin"
        instructLabel.textAlignment = .center
        instructLabel.font = UIFont(name: "Mohave-Bold", size: labelFontSize)
        self.view.addSubview(instructLabel)
        
        //add text views
        let textViewWidth : CGFloat = 50
        let textViewHeight : CGFloat = 200
        let textViewSpacing : CGFloat = (Sizing.ScreenWidth() - (CGFloat(numberOfDigits)*textViewWidth))/CGFloat(numberOfDigits+1)
        
        for i in 0...numberOfDigits-1
        {
            let textView = UITextView(frame: CGRect(x: textViewSpacing*CGFloat(i+1) + CGFloat(i)*textViewWidth, y: padding + labelFontSize, width: textViewWidth, height: textViewHeight))
            textView.tag = i+1
            self.view.addSubview(textView)
            
            
            //design
            textView.text = "-"
            textView.isScrollEnabled = false
            textView.isEditable = false
            textView.textAlignment = .center
            textView.textColor = UIColor.black
            textView.font = UIFont(name: "Mohave", size: 150)
            textView.backgroundColor = UIColor.clear
            
        }

        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func viewDidAppear(_ animated: Bool) {
        registerForKeyboardNotifications()
        self.resignFirstResponder()
        self.becomeFirstResponder()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        deregisterFromKeyboardNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.resignFirstResponder()
        
        //reset
        ResetFields()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func registerForKeyboardNotifications(){
        //Adding notifies on keyboard appearing
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWasShown(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillBeHidden(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    func deregisterFromKeyboardNotifications(){
        //Removing notifies on keyboard appearing
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    func keyboardWasShown(notification: NSNotification){
        //Need to calculate keyboard exact size due to Apple suggestions
        
        var info = notification.userInfo!
        let keyboardSize = (info[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue.size
        
        let keyboardHeight = keyboardSize?.height
        buttonBottomConstraint.constant = keyboardHeight! - Sizing.tabBarHeight
        
        UIView.animate(withDuration: 0.5, animations: {
            self.view.layoutIfNeeded()
        })
    }
    
    func keyboardWillBeHidden(notification: NSNotification){
        
        buttonBottomConstraint.constant = 0
        
        UIView.animate(withDuration: 0.5, animations: {
            self.view.layoutIfNeeded()
        })
    }

    
    func UpdateDisplay()
    {
        DispatchQueue.main.async {
            
            //for each text view
            for i in 0...self.numberOfDigits-1
            {
                if let thisTextView = self.view.viewWithTag(i+1) as? UITextView
                {
                    thisTextView.text.characters.removeAll()
                    
                    //if this textView is suppose to have text
                    if i < self.inputPass.length
                    {
                        thisTextView.text = "•"
//                        thisTextView.text = self.inputPass[i]
                    }
                    else //remove
                    {
                        thisTextView.text = "-"
                    }
                }
            }
        }
    }
    
    //delegate functions
    override var canBecomeFirstResponder: Bool
    {
        return true
    }
    func insertText(_ text: String) {
        
        if inputPass.length < numberOfDigits
        {
            if text.length == 1
            {
                inputPass += text
                UpdateDisplay()
            }
        }
        
    }
    
    func deleteBackward() {
        
        if inputPass != ""
        {
            inputPass.characters.removeLast()
            
            UpdateDisplay()
        }
        
    }
    var hasText: Bool
    {
        if inputPass != ""
        {
            return true
        }
        else
        {
            return false
        }
    }
    
    var keyboardType: UIKeyboardType
    {
            return UIKeyboardType.numberPad
    }

    @IBAction func confirmButtonPressed(_ sender: Any) {
        
        //popup to confirm amount
        PopupManager.singleton.PopupWithCancel(title: "Confirm", body: "Confirm amount: $\(spentAmount)", presentationViewCont: self) { 
            self.SubmitClaim()
        }
        
    }
    
    
    func SubmitClaim()
    {
        guard let userID = Account.singleton.user_ID else {
            NSLog("error: userID doesnt exist")
            return
        }
        guard let username = Account.singleton.user_name else {
            NSLog("error: username doesnt exist")
            return
        }
        
        guard spentAmount != "0.00" else {return}
        
        guard inputPass != "" else
        {
            PopupManager.singleton.Popup(title: "Invalid Input", body: "Please enter passcode", presentationViewCont: self)
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
        
        guard date != 0 else {
            NSLog("error: No Date")
            return
        }
        
        //things to include in QR CODE:
        //NSDictionary -> json encode into string -> input string
        // user ID
        // user name
        // bar id
        // discount id
        // amount spent
        // date and time in seconds from 1970
        
        let url = Network.domain + "AddDiscountRequest.php"
        let postParam = "User_ID=\(userID)&User_Name=\(username)&Bar_ID=\(bar_ID)&Discount_ID=\(discountID)&Amount=\(spentAmount)&Date=\(self.date)&Passcode=\(inputPass)"
        
        Network.singleton.DataFromUrlWithPost(url, postParam: postParam) {
            (success, output) in
            
            if success
            {
                if let output = output
                {
                    do
                    {
                        if let dict = try JSONSerialization.jsonObject(with: output, options: .allowFragments) as? NSDictionary
                        {
                            if let succ = dict["success"] as? String
                            {
                                if succ == "true"
                                {
                                    //poup
                                    PopupManager.singleton.Popup(title: "Success", body: "Discount Authenticated! Loyalty Pts added", presentationViewCont: self, handler: { 
                                        
                                        //dismiss
                                        self.Dismiss()
                                    })
                                }
                                else
                                {
                                    if let detail = dict["detail"] as? String
                                    {
                                        PopupManager.singleton.Popup(title: "Error", body: detail, presentationViewCont: self)
                                    }
                                }
                                
                            }
                            else
                            {
                                PopupManager.singleton.Popup(title: "Error", body: "Invalid server response", presentationViewCont: self)
                            }
                        }
                        else
                        {
                            PopupManager.singleton.Popup(title: "Error", body: "Invalid server response", presentationViewCont: self)
                            
                        }
                    }
                    catch
                    {
                        
                    }
                }
                else
                {
                    PopupManager.singleton.Popup(title: "Error", body: "Invalid server response", presentationViewCont: self)
                }
            }
            else
            {
                PopupManager.singleton.Popup(title: "Error", body: "Please check connection", presentationViewCont: self)
            }
        }
    }
    
    func ResetFields()
    {
        spentAmount = ""
        currentDiscount = nil
        inputPass = ""
        date = 0
        for i in 0...self.numberOfDigits-1
        {
            if let thisTextView = self.view.viewWithTag(i+1) as? UITextView
            {
                thisTextView.text = "-"
            }
        }
    }
    
    func Dismiss()
    {
        DispatchQueue.main.async {
            let _ = self.navigationController?.popViewController(animated: true)
        }
    }
}
