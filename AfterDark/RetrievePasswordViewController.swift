//
//  RetrievePasswordViewController.swift
//  AfterDark
//
//  Created by Koh Yi Zhi Elliot - Ezekiel on 20/1/17.
//  Copyright © 2017 kohbroco. All rights reserved.
//

import UIKit

class RetrievePasswordViewController: UIViewController {

    static let singleton = RetrievePasswordViewController(nibName: "RetrievePasswordViewController", bundle: Bundle.main)
    
    @IBOutlet weak var usernameTextField: UITextField!
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var resetPasswordButton: UIButton!
    
    @IBAction func resetButtonPressed(_ sender: Any) {
        let url = Network.domain + "ResetPassword.php"
        
        guard let username = usernameTextField.text else {return}
        guard let email = emailTextField.text else {return}
        
        let postParam = "User_Name=\(username)&User_Email=\(email)"
        Network.singleton.DataFromUrlWithPost(url, postParam: postParam) { (success, output) in
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
                                    guard let detail = dict["detail"] as? String else {return}
                                    PopupManager.singleton.Popup(title: "Yay!", body: detail, presentationViewCont: self, handler: {
                                        DispatchQueue.main.async {
                                            self.dismiss(animated: true, completion: nil)
                                        }
                                    })
                                }
                                else if succ == "false"
                                {
                                    guard let detail = dict["detail"] as? String else {return}
                                    PopupManager.singleton.Popup(title: "Error", body: detail, presentationViewCont: self)
                                }
                            }
                            else
                            {
                                PopupManager.singleton.Popup(title: "Error", body: "Invalid Server Response", presentationViewCont: self)
                            }
                            
                        }
                        else
                        {
                            PopupManager.singleton.Popup(title: "Error", body: "Invalid Server Response", presentationViewCont: self)
                        }
                    }
                    catch
                    {
                        
                    }
                        
                }
                else
                {
                    PopupManager.singleton.Popup(title: "Error", body: "Invalid Server Response", presentationViewCont: self)
                }
            }
            else
            {
                PopupManager.singleton.Popup(title: "Connection error", body: "Please check connection", presentationViewCont: self)
            }
        }
    }
    
    @IBAction func cancelButtonPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        Bundle.main.loadNibNamed(nibNameOrNil!, owner: self, options: nil)
        
        self.modalTransitionStyle = .flipHorizontal

        resetPasswordButton.layer.cornerRadius = 5
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    
    override func viewWillDisappear(_ animated: Bool) {
        usernameTextField.text = ""
        emailTextField.text = ""
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
