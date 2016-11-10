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
    
    @IBOutlet var dayLabels: [UILabel]!
    @IBOutlet var timingLabels: [UILabel]!

    
    
    
    
    var isExpanded = false

    override func awakeFromNib() {
        super.awakeFromNib()
        self.Arrow.transform = CGAffineTransform(rotationAngle: CGFloat(M_PI)); //rotation in radians
        
        self.Arrow.image? =  (self.Arrow.image?.withRenderingMode(.alwaysTemplate))!
        self.Arrow.tintColor = UIColor.white
        
        // Initialization code

        self.Arrow.transform = CGAffineTransform(rotationAngle: 0.01); //rotation in radians

        //change alphas
        for label in self.dayLabels
        {
            label.alpha = 0
        }
        
        for label in self.timingLabels
        {
            label.alpha = 0
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func ExpandCell()
    {
        UIView.animate(withDuration: 0.5, animations: {
            
            self.Arrow.transform = CGAffineTransform(rotationAngle: CGFloat(M_PI)); //rotation in radians
            

            //change alphas
            for label in self.dayLabels
            {
                label.alpha = 1
            }
            
            for label in self.timingLabels
            {
                label.alpha = 1
            }
        })
    }
    
    func CollapseCell()
    {
        UIView.animate(withDuration: 0.5, animations: {
            
            self.Arrow.transform = CGAffineTransform(rotationAngle: 0.01); //rotation in radians
            
            //change alphas
            for label in self.dayLabels
            {
                label.alpha = 0
            }
            
            for label in self.timingLabels
            {
                label.alpha = 0
            }
        })
    }
    
}
