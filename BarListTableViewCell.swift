//
//  BarListTableViewCell.swift
//  AfterDark
//
//  Created by Swee Har Ng on 16/10/16.
//  Copyright © 2016 kohbroco. All rights reserved.
//

import UIKit

class BarListTableViewCell: UITableViewCell {

    @IBOutlet weak var bar_Icon: UIImageView!
    @IBOutlet weak var bar_NameLabel: UILabel!
    @IBOutlet weak var bar_RatingLabel: UILabel!

    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.accessoryType = UITableViewCellAccessoryType.detailDisclosureButton
        bar_Icon.layer.masksToBounds = true

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the seleced state
    }
    
    func SetContent(_ barIconImage : UIImage?, barName : String, barRating : Rating)
    {
        
        self.bar_Icon.image = barIconImage;
        self.bar_NameLabel.text = barName
        self.bar_RatingLabel.text = String(format: "%.1f",barRating.avg)
    }
    

}
