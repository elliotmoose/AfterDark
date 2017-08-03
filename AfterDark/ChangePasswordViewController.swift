//
//  ChangePasswordViewController.swift
//  AfterDark
//
//  Created by Koh Yi Zhi Elliot - Ezekiel on 15/11/16.
//  Copyright © 2016 kohbroco. All rights reserved.
//

import UIKit

class ChangePasswordViewController: UIViewController {

    static let singleton = ChangePasswordViewController(nibName: "ChangePasswordViewController", bundle: Bundle.main)
    
    @IBOutlet weak var oldPassLabel: UILabel!
    
    @IBOutlet weak var newPassLabel: UILabel!
    
    @IBOutlet weak var cfmNewPassLabel: UILabel!
    
    @IBOutlet weak var oldPassTxtField: UITextField!
    
    @IBOutlet weak var newPassTxtField: UITextField!
    
    @IBOutlet weak var cfmNewPassTxtField: UITextField!
    
    @IBAction func ChangePassword(_ sender: Any) {
        
        
        oldPassLabel.textColor = UIColor.black
        newPassLabel.textColor = UIColor.black
        cfmNewPassLabel.textColor = UIColor.black
        
        //check for any empty regions
        var errors = ""
        
        if oldPassTxtField.text == ""
        {
            oldPassLabel.textColor = ColorManager.accountCreationHighlightErrorColor
            errors.append("Fill in Old Password \n")
        }
 
        if newPassTxtField.text == "" {
            
            newPassLabel.textColor = ColorManager.accountCreationHighlightErrorColor
            errors.append("Fill in New Password \n")

        }
        
        if cfmNewPassTxtField.text == "" {
            
            cfmNewPassLabel.textColor = ColorManager.accountCreationHighlightErrorColor
            errors.append("Fill in Confirm New Password \n")
        }
        
        if errors != ""
        {
            PopupManager.singleton.Popup(title: "Empty field", body: errors, presentationViewCont: self)
            return
        }
        
        //check if new and cfm pass matchs
        guard newPassTxtField.text == cfmNewPassTxtField.text
        else
        {
            PopupManager.singleton.Popup(title: "Mismatch", body: "New Passwords do not match", presentationViewCont: self)
            return
        }
        
        //send request to change pass
        let url = Network.domain + "ChangePassword.php"
        let oldPass = oldPassTxtField.text!
        let newPass = newPassTxtField.text!
        let userID = Account.singleton.user_ID!

        Network.singleton.DataFromUrlWithPost(url, postParam: "oldPass=\(oldPass)&newPass=\(newPass)&User_ID=\(userID)", handler: {
        (success,output) -> Void in
            
            if let output = output{
                
                guard success == true else{return}
                
                let jsonData = (output as NSData).mutableCopy() as! NSMutableData
                
                let dict = Network.JsonDataToDict(jsonData);
                
                let changeSuccess = dict["success"] as? String
                
               if let changeSuccess = changeSuccess
               {
                
                let detail = dict["detail"] as? String
                
                guard detail != nil else {return}
                
                if changeSuccess == "true"
                {
                    
                    PopupManager.singleton.Popup(title: "Success", body: "Password Successfully Changed!", presentationViewCont: self, handler: {
                        
                        //clean up
                        let _ = self.navigationController?.popViewController(animated: true)
                    
                        self.newPassTxtField.text = ""
                        self.oldPassTxtField.text = ""
                        self.cfmNewPassTxtField.text = ""
                    })
                    

                    
                }
                else if detail == "Incorrect Password"
                {
                    PopupManager.singleton.Popup(title: "Failed", body: "Wrong Old Password", presentationViewCont: self)
                }
                else if detail == "User Not Found"
                {
                    NSLog("User Not Found")
                }
                else
                {
                    PopupManager.singleton.Popup(title: "Failed", body: detail!, presentationViewCont: self)
                }
                
                }
                
                
                
                
                
            }
            
            
            
            
        })
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        Bundle.main.loadNibNamed(nibNameOrNil!, owner: self, options: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        oldPassTxtField.text = ""
        newPassTxtField.text = ""
        cfmNewPassTxtField.text = ""
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
