//
//  DescriptionCell.swift
//  AfterDark
//
//  Created by Swee Har Ng on 21/10/16.
//  Copyright © 2016 kohbroco. All rights reserved.
//

import UIKit

class DescriptionCell: UITableViewCell {

    @IBOutlet weak var descriptionTitle: UILabel!
    @IBOutlet weak var descriptionBodyLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
