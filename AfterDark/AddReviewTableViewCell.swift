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

class AddReviewTableViewCell: UITableViewCell,AddReviewDelegate{
    
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
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none

        avgSlider.delegate = self
        pricingSlider.delegate = self
        foodSlider.delegate = self
        ambienceSlider.delegate = self
        serviceSlider.delegate = self


        
        
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
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
