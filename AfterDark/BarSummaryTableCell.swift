//
//  CategoryTableCell.swift
//  AfterDark
//
//  Created by Koh Yi Zhi Elliot - Ezekiel on 3/1/17.
//  Copyright © 2017 kohbroco. All rights reserved.
//

import UIKit
import GoogleMaps
class BarSummaryTableCell : UITableViewCell {

    @IBOutlet weak var barNameLabel: UILabel!
    
    @IBOutlet weak var ratingStarContainerView: UIView!
    
    @IBOutlet weak var ratingCountLabel: UILabel!
    
    @IBOutlet weak var tagsLabel: UILabel!
    
    @IBOutlet weak var detailLabel: UILabel!
        
    
    @IBOutlet weak var exclusiveLabel: UILabel!
    
    @IBOutlet weak var outlineView: UIView!
    
    @IBOutlet weak var transportModeIcon: UIImageView!
    
    let walk = #imageLiteral(resourceName: "Walk").withRenderingMode(.alwaysTemplate)
    let transit = #imageLiteral(resourceName: "Transit").withRenderingMode(.alwaysTemplate)
    let drive = #imageLiteral(resourceName: "Drive").withRenderingMode(.alwaysTemplate)
    
    let ratingStarView = RatingStarView(frame: CGRect(x: 0, y: 0, width: 0, height: 40))
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.ratingStarContainerView.addSubview(ratingStarView)
        self.selectionStyle = .none

        ratingStarView.SetSizeFromWidth(ratingStarContainerView.bounds.width)
        
        transportModeIcon.image = transit
        transportModeIcon.tintColor = ColorManager.themeGray
        
        exclusiveLabel.clipsToBounds = true
        exclusiveLabel.layer.cornerRadius = 2.2

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    

    func SetContent(bar : Bar)
    {
        
        //set name, rating, number of ratings,tags,distance, time taken to travel, cost
        barNameLabel.text = bar.name
        ratingStarView.SetRating(bar.rating.avg)
        ratingCountLabel.text = "(\(bar.totalReviewCount) Ratings)"
        
        if bar.tags == ""
        {
            bar.tags = "nil"
        }
        
        tagsLabel.text = "Tags: \(bar.tags)"

//        var priceDeterminantString = ""
//        if bar.priceDeterminant != 0
//        {
//            for _ in 0...bar.priceDeterminant-1
//            {
//                priceDeterminantString += "$"
//            }
//        }
        
        
        
        
        if bar.distanceMatrixEnabled
        {
            if bar.distanceFromClientString != "" && bar.durationFromClientString != ""
            {
                detailLabel.text = "\(bar.durationFromClientString) - \(bar.distanceFromClientString)"// - \(priceDeterminantString)"
            }
            else
            {
                detailLabel.text = " - "//- \(priceDeterminantString)"
            }

        }
        else
        {
            detailLabel.text = " - "//- \(priceDeterminantString)"
        }
        
        //detailLabel.text = "5 mins - 0.5 km"
        
        
        switch Settings.travelMode {
        case .Walk:
            transportModeIcon.image = walk
        case .Transit:
            transportModeIcon.image = transit
        case .Drive:
            transportModeIcon.image = drive
        }
        
        exclusiveLabel.isHidden = !bar.isExclusive
        
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
