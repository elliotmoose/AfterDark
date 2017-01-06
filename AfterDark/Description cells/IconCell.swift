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
    
    @IBOutlet weak var detailLabelLeftConstraint: NSLayoutConstraint!

    @IBOutlet weak var detailLabelRightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var iconLeftConstraint: NSLayoutConstraint!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    
        self.backgroundColor = ColorManager.descriptionCellBGColor
        self.Detail.textColor = ColorManager.descriptionCellTextColor
        self.Icon.tintColor = ColorManager.descriptionIconsTintColor

        
        //layouts
        let tabWidth = Sizing.ScreenWidth()/4
        detailLabelLeftConstraint.constant = tabWidth  //(same as width of tabs)
        detailLabelRightConstraint.constant = tabWidth/2 //half of tab
        iconLeftConstraint.constant = tabWidth/2 - Icon.frame.width/2
        

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
