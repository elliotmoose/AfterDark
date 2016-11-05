//
//  OpeningHoursCell.swift
//  AfterDark
//
//  Created by Koh Yi Zhi Elliot - Ezekiel on 4/11/16.
//  Copyright © 2016 kohbroco. All rights reserved.
//

import UIKit

class OpeningHoursCell: UITableViewCell {

    @IBOutlet weak var Icon: UIImageView!
    @IBOutlet weak var Detail: UILabel!
    @IBOutlet weak var Arrow: UIImageView!
    
    var isExpanded = false
    override func awakeFromNib() {
        super.awakeFromNib()
        self.Arrow.transform = CGAffineTransform(rotationAngle: CGFloat(M_PI)); //rotation in radians
        
        self.Arrow.image? =  (self.Arrow.image?.withRenderingMode(.alwaysTemplate))!
        self.Arrow.tintColor = UIColor.white
        
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func ExpandCell()
    {
        UIView.animate(withDuration: 0.5, animations: {
            
            self.Arrow.transform = CGAffineTransform(rotationAngle: CGFloat(M_PI)); //rotation in radians
            
        })
    }
    
    func CollapseCell()
    {
        UIView.animate(withDuration: 0.5, animations: {
            
            self.Arrow.transform = CGAffineTransform(rotationAngle: 0.01); //rotation in radians
            
        })
    }
}
