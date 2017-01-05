//
//  CategoryTableCell.swift
//  AfterDark
//
//  Created by Koh Yi Zhi Elliot - Ezekiel on 3/1/17.
//  Copyright © 2017 kohbroco. All rights reserved.
//

import UIKit
import GoogleMaps
class CategoryTableCell: UITableViewCell {

    @IBOutlet weak var barNameLabel: UILabel!
    
    @IBOutlet weak var ratingStarContainerView: UIView!
    
    @IBOutlet weak var ratingCountLabel: UILabel!
    
    @IBOutlet weak var tagsLabel: UILabel!
    
    @IBOutlet weak var detailLabel: UILabel!
        
    @IBOutlet weak var outlineView: UIView!
    
    
    let ratingStarView = RatingStarView(frame: CGRect(x: 0, y: 0, width: 0, height: 40))
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.ratingStarContainerView.addSubview(ratingStarView)
        self.selectionStyle = .none

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    

    func SetContent(bar : Bar)
    {
        
        //set name, rating, number of ratings,tags,distance, time taken to travel, cost
        barNameLabel.text = bar.name
        ratingStarView.SetSizeFromWidth(ratingStarContainerView.bounds.width)
        ratingStarView.SetRating(bar.rating.avg)
        
        ratingCountLabel.text = "(\(bar.totalReviewCount) Ratings)"


        
        
        
        if bar.distanceMatrixEnabled
        {
            if bar.distanceFromClientString != "" && bar.durationFromClientString != ""
            {
                detailLabel.text = "\(bar.distanceFromClientString) - \(bar.durationFromClientString)"
            }
            else
            {
                detailLabel.text = " - "
            }

        }
        else
        {
            detailLabel.text = " - "
        }
        
        
        
    }
    
    @IBOutlet weak var tapAgainLabel: UILabel!
    
    func SetSelected()
    {
        outlineView.layer.borderColor = ColorManager.themeBright.cgColor
        outlineView.layer.borderWidth = 5
        tapAgainLabel.alpha = 1
    }
    
    func SetDeselected()
    {
        outlineView.layer.borderColor = UIColor.clear.cgColor
        tapAgainLabel.alpha = 0
    }

    
    
}
