//
//  DiscountDetailViewController.swift
//  AfterDark
//
//  Created by Koh Yi Zhi Elliot - Ezekiel on 3/11/16.
//  Copyright © 2016 kohbroco. All rights reserved.
//

import UIKit

class DiscountDetailViewController: UIViewController {
    
    @IBOutlet weak var blurrView: UIVisualEffectView!
    
    @IBOutlet weak var imageContainerView: UIView!
    
    @IBOutlet weak var barTitleLabel: UILabel!
    @IBOutlet weak var barIconImageView: UIImageView!
    @IBOutlet weak var discountTitleLabel: UILabel!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var claimNowButton: UIButton!
    
    var currentDiscount : Discount?
    
    @IBAction func claimNowOnClick(_ sender: UIButton) {
        ClaimFormViewController.singleton.currentDiscount = self.currentDiscount
//        self.present(ClaimFormViewController.singleton, animated: true, completion: nil)
        
        self.navigationController?.pushViewController(ClaimFormViewController.singleton, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    

    override func awakeFromNib() {

        
    }


    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        Bundle.main.loadNibNamed(nibNameOrNil!, owner: self, options: nil)
        
        barIconImageView?.layer.cornerRadius = (barIconImageView?.frame.size.height)!/2
        imageContainerView.clipsToBounds = false
        imageContainerView.layer.shadowOpacity = 0.5
        imageContainerView.layer.shadowOffset = CGSize(width: 0, height: 4)
        imageContainerView.layer.shadowColor = UIColor.black.cgColor
        
        claimNowButton.clipsToBounds = false
        claimNowButton.layer.shadowOpacity = 0.5
        claimNowButton.layer.shadowOffset = CGSize(width: 0, height: 1)
        claimNowButton.layer.shadowColor = UIColor.black.cgColor
    
        

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func Load(bar : Bar,discount : Discount)
    {
        barTitleLabel?.text = bar.name
        discountTitleLabel?.text = discount.name
        descriptionTextView?.text = discount.details
        currentDiscount = discount
        
        if bar.Images.count != 0
        {
            barIconImageView.image = bar.Images[0]
        }
    }
    
    func UpdateImage(image : UIImage)
    {
        DispatchQueue.main.async {
            self.barIconImageView.image = image
        }
    }
    
    func RedirectToBar()
    {
        //change to first tab
        self.tabBarController?.selectedIndex = 0
        
        //change to discounts tab
        guard let firstTabNavigationController = self.navigationController?.tabBarController?.viewControllers?[0] as? UINavigationController else {return}
        guard let barListTab = firstTabNavigationController.childViewControllers[0] as? BarListViewController else {return}
        guard let barID = currentDiscount?.bar_ID else {return}
        
        //reset the tab
        firstTabNavigationController.popToRootViewController(animated: false)
        
        barListTab.barListTableViewController.ChangeTab(1)
        barListTab.barListTableViewController.awaitingBlowUpBarID = barID
    }
    
    func ShowInfoButton()
    {
        let infoButton = UIButton(type: .infoLight)
        infoButton.addTarget(self, action: #selector(RedirectToBar), for: .touchUpInside)
        let barButton = UIBarButtonItem(customView: infoButton)
        self.navigationItem.rightBarButtonItem = barButton
    }
    
}
