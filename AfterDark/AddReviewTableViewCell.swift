//
//  AddReviewTableViewCell.swift
//  AfterDark
//
//  Created by Koh Yi Zhi Elliot - Ezekiel on 9/11/16.
//  Copyright © 2016 kohbroco. All rights reserved.
//

import UIKit

protocol AddReviewDelegate : class {
    func ratingUpdated(slider : ReviewStarSlider)
}


class AddReviewTableViewCell: UITableViewCell,AddReviewDelegate,AddDetailReviewDelegate{
    
    
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
    
    var isExpanded : Bool = false
    
    weak var delegate : AddReviewCellDelegate?
    
    @IBAction func writeReviewButtonPressed(_ sender: Any) {
        self.delegate?.ShowAddDetailReviewController()
        AddDetailedReviewViewController.singleton.avgSlider.SetRating(rating: avgSlider.currentRating)
        AddDetailedReviewViewController.singleton.ratingUpdated(slider: AddDetailedReviewViewController.singleton.avgSlider)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none

        avgSlider.delegate = self
        pricingSlider.delegate = self
        foodSlider.delegate = self
        ambienceSlider.delegate = self
        serviceSlider.delegate = self

        self.pricingLabel.alpha = 0
        self.foodLabel.alpha = 0
        self.ambienceLabel.alpha = 0
        self.serviceLabel.alpha = 0
        self.pricingSlider.alpha = 0
        self.foodSlider.alpha = 0
        self.ambienceSlider.alpha = 0
        self.serviceSlider.alpha = 0
        
        AddDetailedReviewViewController.singleton.delegate = self
    }

    
    internal func ratingUpdated(slider : ReviewStarSlider) {
       
        if slider == avgSlider
        {
            pricingSlider.SetRating(rating: slider.currentRating)
            foodSlider.SetRating(rating: slider.currentRating)
            ambienceSlider.SetRating(rating: slider.currentRating)
            serviceSlider.SetRating(rating: slider.currentRating)
        }
        else
        {
            //set avgslider to avg rating
            let avgRating :Float = (pricingSlider.currentRating + foodSlider.currentRating + ambienceSlider.currentRating + serviceSlider.currentRating)/4
            avgSlider.SetRating(rating: avgRating)
        }
        
        //update labels
        avgLabel.text = String(describing: avgSlider.currentRating)
        pricingLabel.text = String(describing: pricingSlider.currentRating)
        foodLabel.text = String(describing: foodSlider.currentRating)
        ambienceLabel.text = String(describing: ambienceSlider.currentRating)
        serviceLabel.text = String(describing: serviceSlider.currentRating)

        
    }
    
    func ExpandCell()
    {
        UIView.animate(withDuration: 0.5, animations: {
            
            self.pricingLabel.alpha = 1
            self.foodLabel.alpha = 1
            self.ambienceLabel.alpha = 1
            self.serviceLabel.alpha = 1
            self.pricingSlider.alpha = 1
            self.foodSlider.alpha = 1
            self.ambienceSlider.alpha = 1
            self.serviceSlider.alpha = 1

        })
    }
    
    func CollapseCell()
    {
        UIView.animate(withDuration: 0.5, animations: {
            
            self.pricingLabel.alpha = 0
            self.foodLabel.alpha = 0
            self.ambienceLabel.alpha = 0
            self.serviceLabel.alpha = 0
            self.pricingSlider.alpha = 0
            self.foodSlider.alpha = 0
            self.ambienceSlider.alpha = 0
            self.serviceSlider.alpha = 0
            
        })
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func DismissAddDetailReviewView() {
        self.delegate?.HideAddDetailReviewController()
    }
    
    func UpdateReviewTable()
    {
        self.delegate?.ReloadReviewTableData()
    }
}
