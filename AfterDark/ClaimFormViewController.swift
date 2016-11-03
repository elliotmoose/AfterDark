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
    
    @IBAction func claimOnClick(_ sender: Any) {
        submitClaimRequest()
    }
    
    var currentString = ""
    override func viewDidLoad() {
        super.viewDidLoad()

        Initialize()
        
    }

    func Initialize()
    {
        spentAmountTextField.text = "$0.00"
        addKeyboardToolBar()
        self.modalPresentationStyle = .currentContext
        self.modalTransitionStyle = .crossDissolve
        spentAmountTextField.delegate = self
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
            //submit request for discount
            DiscountManager.singleton.ClaimDiscount(handler: {(success) in
                
                if success
                {
                    //popup success
                }
                else
                {
                    //error
                }
                
            })
        }
        //activity indicator
    }
}
