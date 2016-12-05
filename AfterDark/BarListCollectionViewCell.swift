//
//  BarListCollectionViewCell.swift
//  AfterDark
//
//  Created by Koh Yi Zhi Elliot - Ezekiel on 2/12/16.
//  Copyright © 2016 kohbroco. All rights reserved.
//

import UIKit

class BarListCollectionViewCell: UICollectionViewCell {

    
    
    @IBOutlet weak var barNameLabel: UILabel!
    
    @IBOutlet weak var barSubTitleLabel: UILabel!
    
    @IBOutlet weak var barImage: UIImageView!
    
    @IBOutlet weak var barRatingLabel: UILabel!
    
    @IBOutlet weak var ratingStarImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        ratingStarImage.image = (ratingStarImage.image?.withRenderingMode(.alwaysTemplate))!
        ratingStarImage.layer.cornerRadius = 5
    }

    
    func SetContent(bar : Bar,displayMode : DisplayBarListMode)
    {
        
        self.barImage.image = bar.icon;
        self.barNameLabel.text = bar.name
        self.barRatingLabel.text = String(format: "%.1f", bar.rating.avg)
    }
    
    
    
}
