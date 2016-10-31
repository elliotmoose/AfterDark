//
//  IconCell.swift
//  AfterDark
//
//  Created by Swee Har Ng on 24/10/16.
//  Copyright © 2016 kohbroco. All rights reserved.
//

import UIKit

class IconCell: UITableViewCell {

    @IBOutlet weak var Detail: UILabel!
    @IBOutlet weak var Icon: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
    

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
