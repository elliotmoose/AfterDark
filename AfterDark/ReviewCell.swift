//
//  ReviewCell.swift
//  AfterDark
//
//  Created by Swee Har Ng on 25/10/16.
//  Copyright © 2016 kohbroco. All rights reserved.
//

import UIKit

class ReviewCell: UITableViewCell {

    @IBOutlet weak var ReviewTitleLabel: UILabel!
    @IBOutlet weak var ReviewBodyLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
