//
//  DiscountClaimViewController.swift
//  AfterDark
//
//  Created by Koh Yi Zhi Elliot - Ezekiel on 2/11/16.
//  Copyright © 2016 kohbroco. All rights reserved.
//

import UIKit
import Foundation

class DiscountClaimViewController: UIViewController,UITextFieldDelegate {
    
    
    static var singleton = DiscountClaimViewController()

    //@IBOutlet weak var barHeaderView: UIView!

    var barHeaderView : UIView?
    var barIconImageView: UIImageView?
    var barTitleName: UILabel?

    
    var discountTitleLabel: UILabel?
    var descriptionTextView: UITextView?
    
    var claimButton: UIButton!
    
    func claimButtonOnClick(_ sender: UIButton) {
        //present view controller
        self.present(ClaimFormViewController.singleton, animated: true, completion: nil)
    }
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        Initialize()
        // Do any additional setup after loading the view.
        
    }


    func Initialize()
    {
        //sizing
        let barHeaderHeight = Sizing.HundredRelativeHeightPts() + 10
        let discountTitleHeight = Sizing.HundredRelativeHeightPts()
        let discountTitleWidth = Sizing.ScreenWidth() - 10
        barHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: Sizing.ScreenWidth(), height: barHeaderHeight))
        barIconImageView = UIImageView(frame: CGRect(x: 5, y: 5, width: Sizing.HundredRelativeHeightPts(), height: Sizing.HundredRelativeHeightPts()))
        barTitleName = UILabel(frame: CGRect(x: Sizing.HundredRelativeHeightPts() + 15, y: 5, width: Sizing.ScreenWidth() - Sizing.HundredRelativeHeightPts() + 20, height: Sizing.HundredRelativeHeightPts()))
        discountTitleLabel = UILabel(frame: CGRect(x: 5, y: barHeaderHeight, width: discountTitleWidth, height: discountTitleHeight))
        
        descriptionTextView = UITextView(frame: CGRect(x: 5, y: barHeaderHeight + discountTitleHeight, width: discountTitleWidth, height: Sizing.HundredRelativeHeightPts() * 2))
        
        
        barTitleName?.textAlignment = .center
        discountTitleLabel?.textAlignment = .center
        
        barTitleName?.textColor = ColorManager.claimBarTitleTextColor
        discountTitleLabel?.textColor = ColorManager.discountTitleLabelTextColor
        
        
        
        self.view.addSubview(barIconImageView!)
        self.view.addSubview(barTitleName!)
        self.view.addSubview(discountTitleLabel!)
        
        
        barIconImageView?.layer.cornerRadius = (barIconImageView?.frame.size.height)!/2
        
        barHeaderView?.backgroundColor = ColorManager.barHeaderViewColor
        discountTitleLabel?.backgroundColor = ColorManager.discountTitleBGColor
       // claimButton.backgroundColor = ColorManager.claimButtonColor

 
    }
    
    func Load(bar : Bar,discount : Discount)
    {
        barTitleName?.text = bar.name
        discountTitleLabel?.text = discount.name
        descriptionTextView?.text = discount.details
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


}
