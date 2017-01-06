//
//  AddReviewViewController.swift
//  AfterDark
//
//  Created by Koh Yi Zhi Elliot - Ezekiel on 5/1/17.
//  Copyright © 2017 kohbroco. All rights reserved.
//

import UIKit

class ReviewViewController: UIViewController,DismissDelegate {

    @IBOutlet weak var avgSlider: ReviewStarSlider!
    
    @IBOutlet weak var pricingSlider: ReviewStarSlider!
    
    @IBOutlet weak var foodSlider: ReviewStarSlider!
    
    @IBOutlet weak var ambienceSlider: ReviewStarSlider!
    
    @IBOutlet weak var serviceSlider: ReviewStarSlider!
    
    @IBOutlet weak var avgLabel: UILabel!
    
    @IBOutlet weak var pricingLabel: UILabel!
    
    @IBOutlet weak var foodLabel: UILabel!
    
    @IBOutlet weak var ambienceLabel: UILabel!
    
    @IBOutlet weak var serviceLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    @IBAction func PresentAddReviewController(_ sender: Any) {
        let window = UIApplication.shared.delegate?.window!!
        AddReviewViewController.singleton.view.alpha = 0
        window?.addSubview(AddReviewViewController.singleton.view)
        
        UIView.animate(withDuration: 0.25, animations: {
            AddReviewViewController.singleton.view.alpha = 1
        })
        
        
    }

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        Bundle.main.loadNibNamed(nibNameOrNil!, owner: self, options: nil)
        
        AddReviewViewController.singleton.delegate = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    override func viewDidLayoutSubviews() {
        let detailViewFrame = CGRect(x: 0, y: 0, width: Sizing.ScreenWidth(), height: Sizing.mainViewHeight - Sizing.tabHeight - Sizing.galleryHeight)
        self.view.frame = detailViewFrame
    }

    
    func LoadRating(rating : Rating)
    {
        avgLabel.text = "\(rating.avg)"
        pricingLabel.text = "\(rating.price)"
        foodLabel.text = "\(rating.food)"
        ambienceLabel.text = "\(rating.ambience)"
        serviceLabel.text = "\(rating.service)"
        
        avgSlider.SetRating(rating: rating.avg)
        pricingSlider.SetRating(rating: rating.price)
        foodSlider.SetRating(rating: rating.food)
        ambienceSlider.SetRating(rating: rating.ambience)
        serviceSlider.SetRating(rating: rating.service)
    }
    
    func reloadData()
    {
        guard let bar = BarManager.singleton.displayedDetailBar else {return}
        self.LoadRating(rating: bar.rating)
    }
    
    func Dismiss() {
        UIView.animate(withDuration: 0.2, animations: {
            AddReviewViewController.singleton.view.alpha = 0
        })
        {
            (success) in
            AddReviewViewController.singleton.view.removeFromSuperview()

        }
        
        
    }
}
