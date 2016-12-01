//
//  DiscountCell.swift
//  AfterDark
//
//  Created by Koh Yi Zhi Elliot - Ezekiel on 2/11/16.
//  Copyright © 2016 kohbroco. All rights reserved.
//

import UIKit

class DiscountCell: UITableViewCell {

    @IBOutlet weak var valueLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.frame = CGRect(x: 0, y: 0, width: Sizing.ScreenWidth(), height: Sizing.discountCellHeight)
        self.accessoryType = .disclosureIndicator
        
        valueLabel.adjustsFontSizeToFitWidth = true
        valueLabel.numberOfLines = 1
        
        self.valueLabel.textColor = ColorManager.discountCellValueTextColor
        }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func Load(discount : Discount)
    {
        titleLabel.text = discount.name
        descriptionLabel.text = discount.details
        valueLabel.text = discount.amount
    }
}