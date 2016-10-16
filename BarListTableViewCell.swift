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
        self.accessoryType = UITableViewCellAccessoryType.DetailDisclosureButton

    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the seleced state
    }
    

}
