//
//  DiscountDetailViewController.swift
//  AfterDark
//
//  Created by Koh Yi Zhi Elliot - Ezekiel on 3/11/16.
//  Copyright © 2016 kohbroco. All rights reserved.
//

import UIKit

class DiscountDetailViewController: UIViewController {

    static let singleton = DiscountDetailViewController(nibName: "DiscountDetailViewController", bundle: Bundle.main)
    
    
    @IBOutlet weak var barTitleLabel: UILabel!
    @IBOutlet weak var barIconImageView: UIImageView!
    @IBOutlet weak var discountTitleLabel: UILabel!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var claimNowButton: UIButton!
    @IBAction func claimNowOnClick(_ sender: UIButton) {
        self.present(ClaimFormViewController.singleton, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    

    override func awakeFromNib() {
        barIconImageView?.layer.cornerRadius = (barIconImageView?.frame.size.height)!/2
        barIconImageView?.layer.masksToBounds = true
    }

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        Bundle.main.loadNibNamed(nibNameOrNil!, owner: self, options: nil)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func Load(bar : Bar,discount : Discount)
    {
        barTitleLabel?.text = bar.name
        barIconImageView.image = bar.icon
        discountTitleLabel?.text = discount.name
        descriptionTextView?.text = discount.details
    }
    
}
