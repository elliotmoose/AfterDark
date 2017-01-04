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
        ratingStarImage.tintColor = ColorManager.themeBright
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 1)
        self.layer.shadowRadius = 2
        self.layer.shadowOpacity = 1
        self.clipsToBounds = false
    }

    
    func SetContent(bar : Bar)
    {
        
        self.barImage.image = bar.icon;
        self.barNameLabel.text = bar.name
        self.barRatingLabel.text = String(format: "%.1f", bar.rating.avg)
    }
    
    
    
}
