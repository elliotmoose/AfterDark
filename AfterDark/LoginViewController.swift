//
//  LoginViewController.swift
//  AfterDark
//
//  Created by Koh Yi Zhi Elliot - Ezekiel on 3/11/16.
//  Copyright © 2016 kohbroco. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    static let singleton = LoginViewController(nibName: "LoginViewController", bundle: Bundle.main)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    @IBOutlet weak var loginIconImageView: UIImageView!

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        Bundle.main.loadNibNamed("LoginViewController", owner: self, options: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
        
        //Bundle.main.loadNibNamed("LoginViewController", owner: self, options: nil)
        
    }
    

    override func awakeFromNib() {
        loginIconImageView.layer.cornerRadius = loginIconImageView.frame.size.width
    }

}
