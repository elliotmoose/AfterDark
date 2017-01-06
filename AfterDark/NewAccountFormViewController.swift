//
//  NewAccountFormViewController.swift
//  AfterDark
//
//  Created by Koh Yi Zhi Elliot - Ezekiel on 7/11/16.
//  Copyright © 2016 kohbroco. All rights reserved.
//

import UIKit

class NewAccountFormViewController: UIViewController , UITextFieldDelegate{

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
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    
    let datePicker = UIDatePicker(frame: CGRect.zero)

    weak var delegate : LoginDelegate?
    
    var activeField : UITextField?
    
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
        
        //check username and password for length
        let (allowedUsernameLength,usernameMessage) = CheckForDisallowedLength(input: username!, maxLength: 20, minLength: 4)
        
        if !allowedUsernameLength
        {
            issues.append("- " + usernameMessage + " for username")
            usernameLabel.textColor = ColorManager.accountCreationHighlightErrorColor
        }
        
        
        let (allowedPasswordLength,passwordMessage) = CheckForDisallowedLength(input: password!, maxLength: 20, minLength: 4)
        
        if !allowedPasswordLength
        {
            issues.append("- " + passwordMessage + " for password")
            passwordLabel.textColor = ColorManager.accountCreationHighlightErrorColor
        }
        
        //check username and password for disallowed characters
        let disallowed = ["%","$","#","!","^","&","(",")",":",";","/","\\","[","]","=","+","?"]
        if !CheckForDisallowedCharacters(string: username!,disallowedCharacters: disallowed) || !CheckForDisallowedCharacters(string: password!,disallowedCharacters: disallowed)
        {
            issues.append("- punctuation is not allowed in usernames and passwords")
        }
        
        //check for valid email
        if !CheckForValidEmail(email: email!)
        {
            confirmEmailLabel.textColor = ColorManager.accountCreationHighlightErrorColor
            emailLabel.textColor = ColorManager.accountCreationHighlightErrorColor
            issues.append("- email is not valid")
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
            if Settings.dummyAppOn
            {
                PopupManager.singleton.Popup(title: "Account created!", body: "Your account is ready!", presentationViewCont: self, handler: {
                    
                    //dismiiss new account view
                    self.dismiss(animated: true, completion: nil)
                    
                    //dismiss login view
                    self.delegate?.Dismiss()

                    Account.singleton.user_name = username
                    Account.singleton.user_ID = "0"
                    Account.singleton.user_Email = email
                })

                return
            }
            
            Account.singleton.CreateNewAccount(username!, password!, email!, dob!, handler:
                {(success,result,dict) -> Void in
                    
                    if success
                    {
                        PopupManager.singleton.Popup(title: "Account created!", body: result, presentationViewCont: self, handler: {
                            
                            //dismiiss new account view
                            self.dismiss(animated: true, completion: nil)
                            
                            //dismiss login view
                            self.delegate?.Dismiss()
 
                            //update login details
                            let username = dict!["User_Name"] as? String
                            let ID = String(describing: (dict!["User_ID"] as? Int)!)
                            let email = dict!["User_Email"] as? String
                            
                            Account.singleton.user_name = username
                            Account.singleton.user_ID = ID
                            Account.singleton.user_Email = email
                            Account.singleton.Save()
                        
                        })
                       
                        
                    
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
    
    func CheckForDisallowedCharacters(string : String,disallowedCharacters : [String]) -> Bool
    {
        for char in disallowedCharacters
        {
            if string.contains(char)
            {
                return false
            }
        }
        
        return true
        
    }
    
    func CheckForValidEmail(email : String) -> Bool
    {
        //first check for disallowed characters?
        //if CheckForDisallowedCharacters(string: email, disallowedCharacters: ])
        
        let components = email.components(separatedBy: "@")
        
        if components.count == 2
        {
            if components[1].contains(".")
            {
                return true
            }
            else
            {
                return false
            }
        }
        else
        {
            return false
        }
        
    }
    
    func CheckForDisallowedLength(input : String, maxLength : Int, minLength : Int) -> (Bool,String) //success,message
    {
        let length = input.characters.count
        if length > maxLength
        {
            return (false,"A maximum of \(maxLength) is allowed")
        }
        else if length < minLength
        {
            return (false,"A minimum of \(minLength) is required")
        }
        else //success
        {
            return (true,"allowed")
        }
    }
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        
        registerForKeyboardNotifications()
        //reset label colors
        usernameLabel.textColor = UIColor.black
        passwordLabel.textColor = UIColor.black
        confirmPasswordLabel.textColor = UIColor.black
        emailLabel.textColor = UIColor.black
        confirmEmailLabel.textColor = UIColor.black
        dobLabel.textColor = UIColor.black
    
    
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        deregisterFromKeyboardNotifications()
    }
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: Bundle.main)
        Bundle.main.loadNibNamed("NewAccountFormViewController", owner: self, options: nil)
        self.modalTransitionStyle = .flipHorizontal
        
        datePicker.datePickerMode = .date
        datePicker.setDate(Date(timeIntervalSince1970: 946684800), animated: false)
        datePicker.addTarget(self, action: #selector(DateUpdated), for: .valueChanged)
        
        dobTextField.inputView = datePicker
        addKeyboardToolBar()
        
        //delegates
        usernameTextField.delegate = self
        passwordTextField.delegate = self
        confirmPasswordTextField.delegate = self
        emailTextField.delegate = self
        confirmEmailTextField.delegate = self
        dobTextField.delegate = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var prefersStatusBarHidden: Bool
    {
        return true
    }
    
    func DateUpdated(sender : Any)
    {

    }
    
    func addKeyboardToolBar()
    {
        let numberToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: Sizing.ScreenWidth(), height: 30))
        numberToolbar.barStyle = UIBarStyle.default
        numberToolbar.items = [
            UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.plain, target: self, action: #selector(cancelNumberPad)),
            UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil),
            UIBarButtonItem(title: "Next", style: UIBarButtonItemStyle.plain, target: self, action: #selector(doneWithNumberPad))]
        numberToolbar.sizeToFit()
        dobTextField.inputAccessoryView = numberToolbar
        emailTextField.inputAccessoryView = numberToolbar
        passwordTextField.inputAccessoryView = numberToolbar
        confirmPasswordTextField.inputAccessoryView = numberToolbar
        confirmEmailTextField.inputAccessoryView = numberToolbar
        usernameTextField.inputAccessoryView = numberToolbar
    }
    
    func cancelNumberPad()
    {
        let txtfield = FirstResponder()
        txtfield.endEditing(true)
        
    }
    
    func doneWithNumberPad()
    {
        let txtfield = FirstResponder()

        if txtfield == dobTextField
        {
            
            //fill text field with current date string
            let date = datePicker.date
            
            let format = DateFormatter()
            format.dateFormat = "dd/MM/yyyy"
            
            dobTextField.text = format.string(from: date)
        }
        else if(txtfield == usernameTextField)
        {
            passwordTextField.becomeFirstResponder()
        }
        else if(txtfield == passwordTextField)
        {
            confirmPasswordTextField.becomeFirstResponder()
        }
        else if(txtfield == confirmPasswordTextField)
        {
            emailTextField.becomeFirstResponder()
        }
        else if(txtfield == emailTextField)
        {
            confirmEmailTextField.becomeFirstResponder()
        }
        else if(txtfield == confirmEmailTextField)
        {
            
        }

        
        

        txtfield.endEditing(true)
    }
    
    func FirstResponder() -> UITextField
    {
        if usernameTextField.isFirstResponder
        {
            return usernameTextField
        }
        
        if passwordTextField.isFirstResponder
        {
            return passwordTextField
        }
        
        if confirmPasswordTextField.isFirstResponder
        {
            return confirmPasswordTextField
        }
        
        if emailTextField.isFirstResponder
        {
            return emailTextField
        }
        
        if confirmEmailTextField.isFirstResponder
        {
            return confirmEmailTextField
        }
        
        if dobTextField.isFirstResponder
        {
            return dobTextField
        }
        
        return usernameTextField
    }
    
    //notifictioncenter
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
    
    //textfield delegate functions
    func textFieldDidBeginEditing(_ textField: UITextField) {
        activeField = textField
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        activeField = nil
    }
    
    func keyboardWasShown(notification: NSNotification){
        //Need to calculate keyboard exact size due to Apple suggestions
        self.scrollView.isScrollEnabled = true
        var info = notification.userInfo!
        let keyboardSize = (info[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue.size
        let contentInsets : UIEdgeInsets = UIEdgeInsetsMake(0.0, 0.0, keyboardSize!.height, 0.0)
        
        self.scrollView.contentInset = contentInsets
        self.scrollView.scrollIndicatorInsets = contentInsets
        
        var aRect : CGRect = self.view.frame
        aRect.size.height -= keyboardSize!.height
        if let activeField = self.activeField {
            if (!aRect.contains(activeField.frame.origin)){
                self.scrollView.scrollRectToVisible(activeField.frame, animated: true)
            }
        }
    }
    
    func keyboardWillBeHidden(notification: NSNotification){
        //Once keyboard disappears, restore original positions
        var info = notification.userInfo!
        let keyboardSize = (info[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue.size
        let contentInsets : UIEdgeInsets = UIEdgeInsetsMake(0.0, 0.0, -keyboardSize!.height, 0.0)
        self.scrollView.contentInset = contentInsets
        self.scrollView.scrollIndicatorInsets = contentInsets
        self.view.endEditing(true)
        self.scrollView.isScrollEnabled = false
    }
}
