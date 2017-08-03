//
//  BannerTableViewCell.swift
//  AfterDark
//
//  Created by Koh Yi Zhi Elliot - Ezekiel on 24/7/17.
//  Copyright © 2017 kohbroco. All rights reserved.
//

import UIKit

class BannerTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var bannerImage: UIImageView!
    @IBOutlet weak var bannerTitleLabel: UILabel!
    @IBOutlet weak var bannerSubTitleLabel: UILabel!
    
    public var banner : Banner?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    public func UpdateDisplay()
    {
        
        if let banner = self.banner
        {
            //step 1: set titles
            bannerTitleLabel.text = banner.title
            bannerSubTitleLabel.text = banner.description
            
            //step 2: set images
            bannerImage.image = banner.image
        }
        else
        {
            NSLog("No Banner to display")
        }
        
    }
}
