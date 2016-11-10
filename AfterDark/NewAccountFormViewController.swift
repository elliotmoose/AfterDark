//
//  NewAccountFormViewController.swift
//  AfterDark
//
//  Created by Koh Yi Zhi Elliot - Ezekiel on 7/11/16.
//  Copyright © 2016 kohbroco. All rights reserved.
//

import UIKit

class NewAccountFormViewController: UIViewController {

    static let singleton = NewAccountFormViewController(nibName: "NewAccountFormViewController", bundle: Bundle.main)
    
    
    @IBAction func backButtonPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var confirmEmailTextField: UITextField!
    @IBOutlet weak var dobTextField: UITextField!
    
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var passwordLabel: UILabel!
    @IBOutlet weak var confirmPasswordLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var confirmEmailLabel: UILabel!
    @IBOutlet weak var dobLabel: UILabel!
    
    
    @IBAction func CreateButtonPressed(_ sender: Any) {
        let username = usernameTextField.text
        let password = passwordTextField.text
        let confirmPassword = confirmPasswordTextField.text
        let email = emailTextField.text
        let confirmEmail = confirmEmailTextField.text
        let dob = dobTextField.text
        
        //reset label colors
        usernameLabel.textColor = UIColor.black
        passwordLabel.textColor = UIColor.black
        confirmPasswordLabel.textColor = UIColor.black
        emailLabel.textColor = UIColor.black
        confirmEmailLabel.textColor = UIColor.black
        dobLabel.textColor = UIColor.black
        
        var issues = [String]()
        if confirmPassword != password
        {
            issues.append("- passwords do not match")
            confirmPasswordLabel.textColor = ColorManager.accountCreationHighlightErrorColor
        }
        
        if confirmEmail != email
        {
            issues.append("- emails do not match")
            confirmEmailLabel.textColor = ColorManager.accountCreationHighlightErrorColor
        }
        
        if username == ""
        {
            issues.append("- fill in username")
            usernameLabel.textColor = ColorManager.accountCreationHighlightErrorColor
        }
        if password == ""
        {
            issues.append("- fill in password")
            passwordLabel.textColor = ColorManager.accountCreationHighlightErrorColor
        }
        if confirmPassword == ""
        {
            issues.append("- fill in password confirmation")
            confirmPasswordLabel.textColor = ColorManager.accountCreationHighlightErrorColor
        }
        if email == ""
        {
            issues.append("- fill in email")
            emailLabel.textColor = ColorManager.accountCreationHighlightErrorColor
        }
        if confirmEmail == ""
        {
            issues.append("- fill in email confirmation")
            confirmEmailLabel.textColor = ColorManager.accountCreationHighlightErrorColor
        }
        
        if dob == ""
        {
            issues.append("- fill in date of birth")
            dobLabel.textColor = ColorManager.accountCreationHighlightErrorColor
        }
        
        if issues.count != 0
        {
            var errorString = ""
            
            for issue in issues{
                errorString.append(issue + "\n")
            }
            
            PopupManager.singleton.Popup(title: "Incomplete Form", body: errorString, presentationViewCont: self)
        }
        else //if no issues
        {
            Account.singleton.CreateNewAccount(username!, password!, email!, dob!, handler:
                {(success,result) -> Void in
                    
                    if success
                    {
                        PopupManager.singleton.Popup(title: "Account created!", body: result, presentationViewCont: self)
                    }
                    else
                    {
                        PopupManager.singleton.Popup(title: "Error", body: result, presentationViewCont: self)
                        
                        if result == "Username taken"
                        {
                            self.usernameLabel.textColor = ColorManager.accountCreationHighlightErrorColor
                        }
                        
                        if result == "Email already in use"
                        {
                            self.emailLabel.textColor = ColorManager.accountCreationHighlightErrorColor
                        }
                    }
                    
            })
        }
        
        
    }
    
    
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        
        //reset label colors
        usernameLabel.textColor = UIColor.black
        passwordLabel.textColor = UIColor.black
        confirmPasswordLabel.textColor = UIColor.black
        emailLabel.textColor = UIColor.black
        confirmEmailLabel.textColor = UIColor.black
        dobLabel.textColor = UIColor.black
    
    
    }
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: Bundle.main)
        Bundle.main.loadNibNamed("NewAccountFormViewController", owner: self, options: nil)
        self.modalTransitionStyle = .flipHorizontal
        
        let datePicker = UIDatePicker(frame: CGRect.zero)
        datePicker.datePickerMode = .date
        datePicker.setDate(Date(timeIntervalSince1970: 946684800), animated: false)
        datePicker.addTarget(self, action: #selector(DateUpdated), for: .valueChanged)
        
        dobTextField.inputView = datePicker
        addKeyboardToolBar()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var prefersStatusBarHidden: Bool
    {
        return true
    }
    
    func DateUpdated()
    {
        
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
        dobTextField.inputAccessoryView = numberToolbar
    }
    
    func cancelNumberPad()
    {
        dobTextField.endEditing(true)
        
    }
    
    func doneWithNumberPad()
    {
        dobTextField.endEditing(true)
        
        
        
        
    }
}
