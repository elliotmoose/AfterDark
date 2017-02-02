//
//  DisplayTextViewController.swift
//  AfterDark
//
//  Created by Koh Yi Zhi Elliot - Ezekiel on 25/1/17.
//  Copyright © 2017 kohbroco. All rights reserved.
//

import UIKit

class DisplayTextViewController: UIViewController {
    
    static let singleton = DisplayTextViewController(nibName: "DisplayTextViewController", bundle: Bundle.main)
    
    @IBOutlet weak var titleLabel: UILabel!

    @IBOutlet weak var bodyTextView: UITextView!
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        Bundle.main.loadNibNamed(nibNameOrNil!, owner: self, options: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func SetText(title : String, body : String)
    {
        titleLabel.text = title
        bodyTextView.text = body
    }
    
    func SetTextAlignment(_ align : NSTextAlignment)
    {
        bodyTextView.textAlignment = align
    }
}
